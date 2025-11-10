class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message
      t.boolean :read, default: false
      t.string :link

      t.timestamps
    end
  end
end
