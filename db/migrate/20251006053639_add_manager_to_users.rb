class AddManagerToUsers < ActiveRecord::Migration[8.0]
  def up
    add_reference :users, :manager, null: true, foreign_key: { to_table: :users }
  end

  def down
    remove_reference :users, :manager, foreign_key: { to_table: :users }
  end
end
