class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    add_index :instructors, ["first_name", "last_name"], unique: true
  end
end
