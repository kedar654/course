require 'spec_helper'

describe Section do
  context "should not be valid" do
    def section_should_not_be_valid(params)
      section = Section.new(params)
      section.should_not be_valid
    end

    context "with negative" do
      it "enroll cap" do
        section_should_not_be_valid(class_num: 1, course_id: 1, section_setting_id: 1, sec_id: 1, sec_capacity: -3)
      end
  
      it "class number" do
        section_should_not_be_valid(class_num: -1, course_id: 1, section_setting_id: 1, sec_id: 1)
      end

      it "sec_id" do
        section_should_not_be_valid(class_num: 1, course_id: 1, section_setting_id: 1, sec_id: -1)
      end

      it "session" do
        section_should_not_be_valid(class_num: 1, course_id: 1, section_setting_id: 1, sec_id: 1, session: -1)
      end
    end

    context "with non-numeric" do
      it "class number" do
        section_should_not_be_valid(class_num: "BAD", course_id: 1, section_setting_id: 1, sec_id: 1)
      end

      it "sec_id" do
        section_should_not_be_valid(class_num: 1, course_id: 1, section_setting_id: 1, sec_id: "BAD")
      end

      it "sec_capacity" do
        section_should_not_be_valid(class_num: 1, course_id: 1, section_setting_id: 1, sec_id: 1, sec_capacity: "BAD")
      end

      it "session" do
        section_should_not_be_valid(class_num: 1, course_id: 1, section_setting_id: 1, sec_id: 1, session: "BAD")
      end
    end # context "with non-numeric"
  end

  context "should be valid" do
    it "with correct input" do
      section = Section.new(class_num: 1, course_id: 1, section_setting_id: 1, sec_id: 1)
      section.should be_valid
    end
  end
end