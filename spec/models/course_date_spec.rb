require 'spec_helper'

describe CourseDate do
  it "should not be valid with start date greater than end date" do
    date = CourseDate.new(start_date: "5/7/2004", end_date: "1/3/2003")
    date.should_not be_valid
  end

  it "should be valid with correct date" do
    date = CourseDate.new(start_date: "1/3/2014", end_date: "5/1/2014")
    date.should be_valid
  end
end