# == Description
# This is the table for the instructor.
#
# == Column Names
# * first_name
# * last_name
# 
# == Notes
# Assumes that no two instructors share the same exact name.
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
class Instructor < ActiveRecord::Base
	has_many :section_settings
	
	validates :first_name, presence: true
	validates :last_name, presence: true

	def to_arr_element
		return ["#{self.first_name} #{self.last_name}", self.id]
	end
end
