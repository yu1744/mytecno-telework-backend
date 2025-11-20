class AddApproverIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :approver, null: true, foreign_key: { to_table: :users }
  end
end
