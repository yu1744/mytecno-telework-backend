class CreateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :applications do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.float :work_hours
      t.string :reason
      t.references :application_status, null: false, foreign_key: true
      t.boolean :is_special_case
      t.string :special_reason
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
