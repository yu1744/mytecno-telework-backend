class AddColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :group, null: true, foreign_key: true
    add_column :users, :position, :string
    add_column :users, :is_caregiver, :boolean
    add_column :users, :has_child_under_elementary, :boolean
  end
end
