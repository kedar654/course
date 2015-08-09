# == Description
# This is the table for the section settings.
#
# Many sections are combination sections with the
# same instructor, time slot, and room.
# This table removes redundancy, and can also
# be used to identify what section is a combination
# section.
#
# == Column Names
# * instructor_id
# * time_slot_id
# * room_id
# * course_date_id
# 
# == Notes
# All columns are foreign keys
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
class SectionSetting < ActiveRecord::Base
	has_many    :sections

	belongs_to  :instructor
	belongs_to	:time_slot
	belongs_to  :room
	belongs_to  :course_date
	#belongs_to  :course_date, primary_key: "semester", foreign_key: "semester"

	before_destroy { destruct }

	def destruct
		if  time_slot && time_slot.section_settings.count == 1
			time_slot.destroy
		end

		if course_date && course_date.section_settings.count == 1
			course_date.destroy
		end
	end
end
