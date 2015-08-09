require 'spec_helper'

describe TimeSlot do
  it "should be valid with correct time format" do
    time = TimeSlot.new(days: "M", start_time: "1:30:00 PM", end_time: "2:30:00 PM")
    time.should be_valid
  end

  it "should be valid with correct days" do
    time = TimeSlot.new(days: "MTWRFS", start_time: "1:30:00 PM", end_time: "2:30:00 PM")
    time.should be_valid
  end

  context "should not be valid with incorrect" do
    it "start_time seconds" do
      time = TimeSlot.new(days: "M", start_time: "1:30:0 PM", end_time: "2:30:00 PM")
      time.should_not be_valid
    end

    it "start_time minutes" do
      time = TimeSlot.new(days: "M", start_time: "1:5:00 PM", end_time: "2:30:00 PM")
      time.should_not be_valid
    end

    it "end_time minutes" do
      time = TimeSlot.new(days: "M", start_time: "1:30:00 PM", end_time: "2:3:00 PM")
      time.should_not be_valid
    end

    it "end_time seconds" do
      time = TimeSlot.new(days: "M", start_time: "1:30:00 PM", end_time: "3:30:0 PM")
      time.should_not be_valid
    end

    it "day" do
      time = TimeSlot.new(days: "N", start_time: "1:30:00 PM", end_time: "3:30:00 PM")
      time.should_not be_valid
    end
  end

  it "should not be valid with start time greater than end time" do
    time = TimeSlot.new(days: "MW", start_time: "5:30:00 PM", end_time: "1:30:00 PM")
    time.should_not be_valid
  end
end