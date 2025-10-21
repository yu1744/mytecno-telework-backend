class AddMissingColumnsToApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :applications, :work_option, :string unless column_exists?(:applications, :work_option)
    add_column :applications, :is_special, :boolean unless column_exists?(:applications, :is_special)
    add_column :applications, :is_overtime, :boolean unless column_exists?(:applications, :is_overtime)
    add_column :applications, :overtime_end, :time unless column_exists?(:applications, :overtime_end)
  end
end
