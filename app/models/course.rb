# == Description
# This is the table for courses
#
# == Column Names
# * subject
# * course_id
# * name
# 
# == Notes
# course_id is the course_number.
# It does not reference any table.
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
class Course < ActiveRecord::Base 

  class CourseValidator < ActiveModel::Validator

    def vnil(var)
      var.nil? ? 0 : var
    end

    def cond_error(r, cond, error)
      if cond
        r.errors[:base] << error
      end
    end

    def validate(record)
      cond_error(record, (vnil(record.course_id) <= 0), "Course number <= 0")
    end
  end
  #self.primary_keys = :course_id, :subject
  has_many :sections, dependent: :destroy

  validates :course_id, presence: true
  validates :subject, presence: true
  validates :name, presence: true

  validates :course_id, numericality: { only_integer: true }

  validates_with CourseValidator

  def to_arr_element
    ["#{self.subject} #{self.course_id}", self.id]
  end
end
