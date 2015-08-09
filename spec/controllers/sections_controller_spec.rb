require 'spec_helper'


describe SectionsController do
  describe "POST create" do
    context "valid" do
      it "occurs when all section setting fields are null" do
        params = {start_hours: "", 
                  start_minutes: "", 
                  start_periods: "", 
                  end_hours: "", 
                  end_minutes: "", 
                  end_periods: "",
                  room_num: "",
                  instructor_list: "",
                  class_nbr: 2952,
                  section: 25,
                  seats: 1,
                  session: 1,
                  course_list: 1,
                  date_list: 1,
                  location: "",
                  role: "",
                  acad_group: "",
                  component: "",
                  crs_atr: "",
                  mode: "",}
        post :create, params

        expect(Section.where(sec_id: 25, course_id: 1, class_num: 2952).count).to eq(1)
      end
    end

    context "invalid" do
      it "occurs when all class number is negative" do
        params = {start_hours: "", 
                  start_minutes: "", 
                  start_periods: "", 
                  end_hours: "", 
                  end_minutes: "", 
                  end_periods: "",
                  room_num: "",
                  instructor_list: "",
                  class_nbr: -2952,
                  section: 25,
                  seats: 1,
                  session: 1,
                  course_list: 1,
                  date_list: 1,
                  location: "",
                  role: "",
                  acad_group: "",
                  component: "",
                  crs_atr: "",
                  mode: "",}
        post :create, params

        expect(Section.where(sec_id: 25, course_id: 1, class_num: -2952).count).to eq(0)
      end
    end
  end

  describe "POST update" do
  
  end

  describe "GET cross" do

  end

  describe "GET new" do

  end

  describe "GET edit" do

  end

  describe "GET combine" do

  end

  describe "GET add_instructor" do

  end
end
