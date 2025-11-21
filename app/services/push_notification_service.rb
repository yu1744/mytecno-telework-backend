class PushNotificationService
  require 'webpush'

  class << self
    # プッシュ通知を送信
    def send_notification(user, title, body, data = {})
      return unless user.present?

      # ユーザーのすべての購読を取得
      subscriptions = PushSubscription.where(user: user)
      return if subscriptions.empty?

      message = {
        title: title,
        body: body,
        icon: '/icon-192x192.png',
        badge: '/icon-96x96.png',
        data: data.merge(timestamp: Time.current.to_i)
      }

      subscriptions.each do |subscription|
        send_to_subscription(subscription, message)
      rescue Webpush::InvalidSubscription, Webpush::ExpiredSubscription => e
        # 無効または期限切れの購読を削除
        Rails.logger.warn "Removing invalid subscription: #{e.message}"
        subscription.destroy
      rescue StandardError => e
        Rails.logger.error "Failed to send push notification: #{e.message}"
      end
    end

    # 申請作成時の通知
    def notify_application_created(application)
      # 承認者に通知
      approvers = find_approvers_for(application)
      approvers.each do |approver|
        send_notification(
          approver,
          '新しい申請がありました',
          "#{application.user.name}さんから在宅勤務申請が届いています",
          {
            type: 'application_created',
            application_id: application.id,
            url: '/approvals'
          }
        )
      end
    end

    # 承認時の通知
    def notify_application_approved(application, approver, comment = nil)
      message = "あなたの在宅勤務申請が承認されました"
      message += "\nコメント: #{comment}" if comment.present?

      send_notification(
        application.user,
        '申請が承認されました',
        message,
        {
          type: 'application_approved',
          application_id: application.id,
          approver_name: approver.name,
          url: '/history'
        }
      )
    end

    # 却下時の通知
    def notify_application_rejected(application, approver, comment)
      send_notification(
        application.user,
        '申請が却下されました',
        "却下理由: #{comment}",
        {
          type: 'application_rejected',
          application_id: application.id,
          approver_name: approver.name,
          url: '/history'
        }
      )
    end

    # デッドライン警告通知
    def notify_deadline_warning(application)
      # 申請日の前日にリマインダー
      send_notification(
        application.user,
        '在宅勤務のリマインダー',
        "明日(#{application.date.strftime('%Y年%m月%d日')})は在宅勤務の予定です",
        {
          type: 'deadline_warning',
          application_id: application.id,
          url: '/history'
        }
      )
    end

    private

    def send_to_subscription(subscription, message)
      Webpush.payload_send(
        message: JSON.generate(message),
        endpoint: subscription.endpoint,
        p256dh: subscription.p256dh_key,
        auth: subscription.auth_key,
        vapid: {
          subject: ENV.fetch('VAPID_SUBJECT', 'mailto:admin@example.com'),
          public_key: vapid_public_key,
          private_key: vapid_private_key
        }
      )
    end

    def find_approvers_for(application)
      user = application.user
      approvers = []

      # ユーザーの上司
      approvers << user.manager if user.manager.present?
      approvers << user.approver if user.approver.present?

      # 同じ部署の承認者権限を持つユーザー
      if user.department.present?
        department_approvers = User.joins(:role)
                                    .where(department: user.department, roles: { name: ['approver', 'admin'] })
                                    .where.not(id: user.id)
        approvers.concat(department_approvers.to_a)
      end

      # 管理者
      admin_users = User.joins(:role).where(roles: { name: 'admin' })
      approvers.concat(admin_users.to_a)

      approvers.uniq
    end

    def vapid_public_key
      ENV.fetch('VAPID_PUBLIC_KEY') do
        raise 'VAPID_PUBLIC_KEY environment variable not set'
      end
    end

    def vapid_private_key
      ENV.fetch('VAPID_PRIVATE_KEY') do
        raise 'VAPID_PRIVATE_KEY environment variable not set'
      end
    end
  end
end
