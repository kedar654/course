# == Description
# This is the table for the course date. This is
# self-explanitory
#
# == Column Names
# * start_date
# * end_date
# 
# == Notes
# Pointless table because there's only one tuple.
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
class CourseDate < ActiveRecord::Base
	#self.primary_keys = :year, :semester
	
	class CourseDateValidator < ActiveModel::Validator
    
    def date_valid?(date)
      begin 
        Date.strptime(date, "%m/%d/%Y")
      rescue
        return false
      end
      true
    end

    def date_values(date)
      date =~ /(\d+)\/(\d+)\/(\d+)/

      year = $3.nil? ? 0 : $3
      month = $1.nil? ? 0 : $1
      day = $2.nil? ? 0 : $2

      "#{year}#{sprintf("%02d", month)}#{sprintf("%02d", day)}".to_i
    end

    def std_lt_edd_validate(r)
      r.errors[:base] << "Start date must be before end date" if date_values(r.start_date) >= date_values(r.end_date)
    end

    def std_validate(r)
      r.errors[:base] << "Start date invalid" unless date_valid?(r.start_date)
    end

    def edd_validate(r)
      r.errors[:base] << "End date invalid" unless date_valid?(r.end_date)
    end

    def validate(record)
      std_validate(record)
      edd_validate(record)
      std_lt_edd_validate(record)
    end
	end

	has_many :section_settings
	validates_with CourseDateValidator

  def to_arr_element
    element = []

    element << "#{self.start_date} -- #{self.end_date}"
    element << self.id

    print element
    puts ""

    element
  end
end
