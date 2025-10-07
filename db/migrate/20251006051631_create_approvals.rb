class CreateApprovals < ActiveRecord::Migration[8.0]
  def change
    create_table :approvals do |t|
      t.references :application, null: false, foreign_key: true
      t.string :comment
      t.references :approver, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
