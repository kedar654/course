require 'spec_helper'

describe Instructor do
  it "should not be valid without first name" do
    instructor = Instructor.new(last_name: "Smith")
    instructor.should_not be_valid
  end

  it "should not be valid without last name" do
    instructor = Instructor.new(first_name: "John")
    instructor.should_not be_valid
  end

  it "should be valid with both first and last name" do
    instructor = Instructor.new(first_name: "John", last_name: "Smith")
    instructor.should be_valid
  end
end