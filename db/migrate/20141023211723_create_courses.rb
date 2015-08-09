class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :course_id
      t.string 	:subject
      t.string 	:name

      t.timestamps
    end
    add_index :courses, ["course_id", "subject"], :unique => true
    #execute "ALTER TABLE words ADD PRIMARY KEY (course_id, subject);"


  end
end
