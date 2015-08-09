require 'spec_helper'

describe Room do
  context "should not be valid" do  
    it "occurs with non-numeric room number" do
      room = Room.new(building: "PKI", room_num: "BAD")
      room.should_not be_valid
    end

    it "occurs with negative room number" do
      room = Room.new(building: "PKI", room_num: -2)
      room.should_not be_valid
    end

    it "occurs with room number of zero" do
      room = Room.new(building: "PKI", room_num: 0)
      room.should_not be_valid
    end

    it "occurs without building" do
      room = Room.new(room_num: 2, building: "")
      room.should_not be_valid
    end
  end
  
  context "should be valid" do
    it "with building and positive room number" do
      room = Room.new(building: "PKI", room_num: 1)
      room.should be_valid
    end
  end
end