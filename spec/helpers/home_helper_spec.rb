require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the HomeHelper. For example:
#
# describe HomeHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe HomeHelper do
 # pending "add some examples to (or delete) #{__FILE__}"
 
  context "should write" do
    
    def convert_hash_title(title)
      case title
      when :first_name
        "First Name"
      when :last_name
        "Last"
      when :days
        "Pat"
      when :start_time
        "Mtg Start"
      when :end_time
        'Mtg End'
      when :start_date
        'Start Date'
      when :end_date
        'End Date'
      when :subject
        'Subject'
      when :course_id
        'Catalog'
      when :name
        'CDescr'
      when :room_capacity
        'Capacity'
      when :class_num
        'Class Nbr'
      when :sec_id
        'Section'
      when :acad_group
        "Acad Group"
      when :role
        'Role'
      when :sec_capacity
        'Cap Enrl'
      when :session
        'Session'
      when :crsatr_val
        'CrsAtr Val'
      when :component
        'Component'
      when :location
        'Location'
      when :mode 
        'Mode'
      when :sec_description
        'SDescr'
      else
        'Error'
      end
    end

    def convert_hash(hash)
      new_hash = {}
      hash.each do |key, val|
        if key == :building
          new_hash['Facil ID'] = "#{hash[:building]}#{hash[:room_num]}"
        else
          new_hash[convert_hash_title(key)] = hash[key]
        end
      end
      new_hash
    end

    def test_no_dep_write_func(row, model, func)
      row_count = model.all.count
      id = send(func, convert_hash(row))
      count = model.where(row).count

      expect([id, count]).to eq([row_count + 1, 1])
    end

    it "instructor" do
      test_no_dep_write_func({first_name: "John", last_name: "Smith"}, Instructor, :write_instructor)
    #  row = {first_name: "John", last_name: "Smith"}
     # id = write_instructor(row)
      #count = Instructor.where(row).count

      #expect([id, count]).to eq([1, 1])
    end

    it "time_slot" do
      test_no_dep_write_func({days: "MWF", start_time: "3:00:00 PM", end_time: "4:00:00 PM"}, TimeSlot, :write_time_slot)
      #row = {days: "MWF", start_time: "3:00:00 PM", end_time: "4:00:00 PM"}
      #id = write_time_slot(row)
      #count = TimeSlot.where(row).count

      #expect([id, count]).to eq([1, 1])
    end

    it "course_date" do
      test_no_dep_write_func({start_date: "3/3/2014", end_date: "3/3/2015"}, CourseDate, :write_course_date)
    end

    it "room" do
      test_no_dep_write_func({building: "PKI", room_num: 532, room_capacity: 35}, Room, :write_room)
    end

    it "course" do
      test_no_dep_write_func({subject: "CSCI", course_id: 3550, name: "NoName"}, Course, :write_course)
    end

    it "section_setting" do
      hash = {first_name: "Joe", last_name: "Lancelot", days: "M", start_time: "5:50:00 PM", end_time: "6:50:00 PM", start_date: "1/1/2014", end_date: "6/6/6666", building: "PKI", room_num: 270}
      id = write_section_setting(convert_hash(hash))
      expect(id).to eq(1)
    end

    it "section" do

    end
  end

  context "get_building_and_room " do
    it "should correctly get PKI532" do
      expect(get_building_and_room("PKI532")).to eq({building: "PKI", room: 532})
    end

    it "should correctly get ART0132" do
      expect(get_building_and_room("ART0132")).to eq({building: "ART", room: 132})
    end
  end
end
