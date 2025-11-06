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

    render json: applications, include: %i[user application_status]
  end

  def show
  end

  def create
  end

  def update
    # params[:id] は application_id
    @application = Application.find(params[:id])
    
    # デバッグログ
    Rails.logger.info "=== Approval Debug ==="
    Rails.logger.info "Current user: #{current_api_v1_user.name} (#{current_api_v1_user.role.name})"
    Rails.logger.info "Application user: #{@application.user.name} (#{@application.user.role.name})"
    Rails.logger.info "Application status: #{@application.application_status.name}"
    
    # 権限チェック - applicationを渡す
    authorize @application, :update?, policy_class: ApprovalPolicy
    
    status = params[:status] # "approved" or "rejected"
    
    unless %w[approved rejected].include?(status)
      return render json: { error: 'Invalid status' }, status: :bad_request
    end

    ActiveRecord::Base.transaction do
      # approvalレコードを作成または更新
      @approval = @application.approvals.find_or_initialize_by(approver_id: current_api_v1_user.id)
      @approval.update!(
        status: status, 
        approver_id: current_api_v1_user.id, 
        comment: params[:comment]
      )
      
      # applicationのステータスを更新
      # シードデータに合わせて日本語名を使用
      new_status_name = (status == 'approved') ? '承認' : '却下'
      application_status = ApplicationStatus.find_by!(name: new_status_name)
      @application.update!(application_status: application_status)
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
end
