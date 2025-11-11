class Api::V1::ApprovalsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    authorize :approval, :index?

    applications =
      if current_api_v1_user.role.name == 'admin'
        Application.pending
      elsif current_api_v1_user.role.name == 'approver'
        department_id = current_api_v1_user.department_id
        user_ids = User.where(department_id: department_id).pluck(:id)
        Application.pending.where(user_id: user_ids)
      else
        []
      end

    # Exclude applications from the current user
    applications = applications.where.not(user_id: current_api_v1_user.id) if applications.respond_to?(:where)

    # Sorting
    sort_column = params[:sort_by].in?(%w[created_at date status]) ? params[:sort_by] : 'created_at'
    sort_direction = params[:sort_order].in?(%w[asc desc]) ? params[:sort_order] : 'desc'

    applications = applications.left_outer_joins(:application_status)

    order_clause = if sort_column == 'status'
                     "application_statuses.name #{sort_direction}"
                   else
                     "applications.#{sort_column} #{sort_direction}"
                   end
    applications = applications.order(Arel.sql(order_clause))

    render json: applications, include: %i[user application_status]
  end

  def show
  end

  def create
  end

  def update
    # params[:id] は application_id
    @application = Application.find(params[:id])

    # 権限チェック
    unless @application.approvable_by?(current_api_v1_user)
      return render json: { error: 'この申請を承認する権限がありません。' }, status: :forbidden
    end

    # デバッグログ
    Rails.logger.info "=== Approval Debug ==="
    Rails.logger.info "Current user: #{current_api_v1_user.name} (#{current_api_v1_user.role.name})"
    Rails.logger.info "Application user: #{@application.user.name} (#{@application.user.role.name})"
    Rails.logger.info "Application status: #{@application.application_status.name}"

    # 権限チェック - applicationを渡す
    # authorize @application, :update?, policy_class: ApprovalPolicy

    status = approval_params[:status]
    comment = approval_params[:comment]

    unless %w[approved rejected].include?(status)
      return render json: { error: 'Invalid status' }, status: :bad_request
    end

    if status == 'rejected' && comment.blank?
      return render json: { error: 'Comment is required for rejection' }, status: :bad_request
    end

    ActiveRecord::Base.transaction do
      # approvalレコードを作成または更新
      @approval = @application.approvals.find_or_initialize_by(approver_id: current_api_v1_user.id)
      @approval.update!(
        status: status,
        approver_id: current_api_v1_user.id,
        comment: comment
      )

      # applicationのステータスを更新
      # シードデータに合わせて日本語名を使用
      new_status_name = (status == 'approved') ? '承認' : '却下'
      application_status = ApplicationStatus.find_by!(name: new_status_name)
      @application.update!(application_status: application_status)

      # 通知を作成
      status_ja = (status == 'approved') ? '承認' : '却下'
      application_type = @application.application_type
      message = "#{application_type}が#{current_api_v1_user.name}によって#{status_ja}されました。"
      Notification.create!(
        user: @application.user,
        message: message,
        link: '/history',
        read: false
      )
    end

    render json: { message: "Application #{status} successfully." }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Record not found.' }, status: :not_found
  rescue Pundit::NotAuthorizedError => e
    Rails.logger.error "Authorization failed: #{e.message}"
    render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
  rescue => e
    Rails.logger.error "Error in approval update: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
  end
  private

  def approval_params
    params.require(:approval).permit(:status, :comment)
  end
end
