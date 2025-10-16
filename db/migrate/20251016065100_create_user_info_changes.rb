class CreateUserInfoChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :user_info_changes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :changer, null: false, foreign_key: { to_table: :users }
      t.date :effective_date, null: false
      t.references :new_department, foreign_key: { to_table: :departments }
      t.references :new_role, foreign_key: { to_table: :roles }
      t.references :new_manager, foreign_key: { to_table: :users }
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end
  end
end