require 'spec_helper'

describe Course do
  it "is not be valid without course name" do
    course = Course.new(subject: "CSCI", course_id: 3940)
    course.should_not be_valid
  end

  it "should not be valid without subject" do
    course = Course.new(course_id: 3940, name: "Peer Review")
    course.should_not be_valid
  end

  it "should not be valid without catalog" do
    course = Course.new(subject: "CSCI", name: "Peer Review")
    course.should_not be_valid
  end

  it "should be valid with subject, name, and title" do
    course = Course.new(subject: "CSCI", course_id: 3940, name: "Peer Review")
    course.should be_valid
  end

  it "should not be valid with catalog less than or equal to 0" do
    course = Course.new(subject: "CSCI", course_id: -1, name: "TEST")
    course.should_not be_valid
  end

  it "should not be valid with non-numeric catalog" do
    course = Course.new(subject: "CSCI", course_id: "BAD", name: "GAG")
    course.should_not be_valid
  end
end