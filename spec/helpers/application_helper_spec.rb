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
describe ApplicationHelper do
 # pending "add some examples to (or delete) #{__FILE__}"
 describe "insert_into" do

 end

  describe "time conversion calls " do
    def time_is_correct?(time, hour, minute)
      time.hour == hour && time.min == minute
    end

    it "converts '12:30:00 PM' successfully" do
      time_is_correct?(time_conv("12:30:00 PM"), 12, 30) 
    end

    it "converts '1:00:00 AM' successfully" do
      time_is_correct?(time_conv("1:00:00 AM"), 1, 0)
    end
  end

  describe "table_row_class_proc " do
    it "should put in odd number and return 'table-row-odd'" do
      expect(table_row_class_proc.call(1)).to eq("table-row-odd")
    end

    it "should put in even number and return 'table-row-even'" do
      expect(table_row_class_proc.call(2)).to eq("table-row-even")
    end
  end

  describe "insert_into calls " do
    it "returns the id of the new Course and puts it in the database" do
      row_count = Course.all.count
      values = {subject: "CSCI", course_id: 4130, name: "No Name"}
      id = insert_into Course, values
      expect([id, Course.where(values).count]).to eq([row_count + 1, 1])
    end

    it "returns the id of the matching SectionSetting and doesn't put it in database" do
      values = {instructor_id: 1, time_slot_id: 1, course_date_id: 1, room_id: 1}
      first_id = insert_into SectionSetting, values
      second_id = insert_into SectionSetting, values

      expect([first_id == second_id, SectionSetting.where(values).count]).to eq([true, 1])
    end
  end
end