class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots do |t|
      t.string  :days
      t.string  :start_time
      t.string  :end_time

      t.timestamps
    end

    add_index :time_slots, ["days", "start_time", "end_time"], unique: true, name: "time_slot_index"
  end
end
