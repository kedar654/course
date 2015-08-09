class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string  :building
      t.integer :room_num
      t.integer :room_capacity
      t.string  :desk_type
      t.string  :board_type
      t.string  :chair_type
      t.timestamps

    end
    add_index :rooms, ["building", "room_num"], :unique => true
    #execute "ALTER TABLE rooms ADD PRIMARY KEY (building, room_num);"
  end
end
