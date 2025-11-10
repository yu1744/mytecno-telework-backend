class AddOvertimeReasonToApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :applications, :overtime_reason, :string
  end
end
