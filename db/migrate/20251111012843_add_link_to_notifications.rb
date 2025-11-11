class AddLinkToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :link, :string unless column_exists?(:notifications, :link)
  end
end
