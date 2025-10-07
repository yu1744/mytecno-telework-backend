class CreateUserTransportRoutes < ActiveRecord::Migration[8.0]
  def change
    create_table :user_transport_routes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :transport_route, null: false, foreign_key: true

      t.timestamps
    end
  end
end
