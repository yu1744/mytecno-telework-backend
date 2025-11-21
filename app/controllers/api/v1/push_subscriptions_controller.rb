class Api::V1::PushSubscriptionsController < ApplicationController
  before_action :authenticate_api_v1_user!

  # POST /api/v1/push_subscriptions
  def create
    subscription = current_api_v1_user.push_subscriptions.find_or_initialize_by(
      endpoint: subscription_params[:endpoint]
    )

    subscription.assign_attributes(
      p256dh_key: subscription_params[:keys][:p256dh],
      auth_key: subscription_params[:keys][:auth]
    )

    if subscription.save
      render json: { message: '通知の購読を登録しました' }, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/push_subscriptions
  def destroy
    subscription = current_api_v1_user.push_subscriptions.find_by(
      endpoint: params[:endpoint]
    )

    if subscription&.destroy
      render json: { message: '通知の購読を解除しました' }, status: :ok
    else
      render json: { error: '購読が見つかりません' }, status: :not_found
    end
  end

  # GET /api/v1/push_subscriptions/vapid_public_key
  def vapid_public_key
    render json: {
      public_key: ENV.fetch('VAPID_PUBLIC_KEY', generate_vapid_keys[:public_key])
    }
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, keys: [:p256dh, :auth])
  end

  def generate_vapid_keys
    # 開発環境用の一時的なVAPID鍵生成
    # 本番環境では環境変数に設定すること
    vapid_key = Webpush.generate_key
    {
      public_key: vapid_key.public_key,
      private_key: vapid_key.private_key
    }
  end
end
