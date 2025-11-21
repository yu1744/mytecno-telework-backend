# frozen_string_literal: true

class CreatePushSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :push_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :endpoint, null: false
      t.text :p256dh_key, null: false
      t.text :auth_key, null: false
      t.timestamps
    end

    add_index :push_subscriptions, [:user_id, :endpoint], unique: true
  end
end
