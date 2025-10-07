class CreateApplicationStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :application_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
