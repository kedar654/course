# == Description
# This is the table for the room properties
#
# == Column Names
# * building
# * room_num
# * room_capacity
# * desk_type
# * board_type
# * chair_type
# 
# == Notes
#
# == Model List
# Ordered by least dependent to most dependent
#
#
#
# Course
#
# CourseDate
#
# Instructor
#
# Room
#
# TimeSlot
#
# SectionSetting
#
# Section

class Room < ActiveRecord::Base

  def initialize(params=nil)
    return super if params.nil?
    params[:room_capacity] = 0 if params[:room_capacity].nil? || params[:room_capacity].to_s.empty?
   # params[:desk_type] = nil unless params[:desk_type].nil? || !params[:desk_type].empty?
   # params[:board_type] = nil unless params[:board_type].nil? || !params[:board_type].empty?
   # params[:chair_type] = nil unless params[:chair_type].nil? || !params[:chair_type].empty?
    super(params)
  end

  class RoomValidator < ActiveModel::Validator
    def nnil(num)
      num.nil? ? 0.1 : num
    end
    def validate(record)
      if nnil(record.room_num) <= 0
        record.errors[:base] << "Room num must be greater than 0"
      end

      if nnil(record.room_capacity) < 0
        record.errors[:base] << "Room capacity must be positive"
      end
    end
  end

  #self.primary_keys = :building, :room_num
  has_many :section_settings

  validates :building, presence: true
  validates :room_num, presence: true

  validates :room_num, numericality: { only_integer: true }
  validates :room_capacity, numericality: { only_integer: true}
  validates_with RoomValidator

  def self.all_room_props
    props = {}

    props[:board] = all_type(:board_type)
    props[:desk] = all_type(:desk_type)
    props[:chair] = all_type(:chair_type)

    props
  end

  def to_arr_element
    element = []

    element << "#{self.building}#{self.room_num}"
    element << self.id

    element
  end

  private

  def self.all_type(element)
    types = []

    type_list = Room.select(element).distinct

    type_list.each do |t|
      types << t[element]
    end

    types
  end
end
