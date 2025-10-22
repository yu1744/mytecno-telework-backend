class AddStatusAndCommentToApprovals < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:approvals, :status)
      add_column :approvals, :status, :string, null: false, default: 'pending'
    end
  end
end
