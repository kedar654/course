class CreateSectionSettings < ActiveRecord::Migration
  def change
    create_table :section_settings do |t|
      t.references :time_slot
      t.references :instructor
      t.references :room
      t.references :course_date

      t.timestamps
    end
    add_index :section_settings, ["time_slot_id", "instructor_id", "room_id"], name: 'section_setting_index', unique: true
 end
end
