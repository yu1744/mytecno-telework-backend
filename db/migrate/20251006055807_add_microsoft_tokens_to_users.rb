class AddMicrosoftTokensToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :microsoft_access_token, :string
    add_column :users, :microsoft_refresh_token, :string
    add_column :users, :microsoft_token_expires_at, :datetime
  end
end
