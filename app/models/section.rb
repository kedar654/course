# == Description
# This is the table for the course section.
# This is the main table, which can join all
# other tables.
#
# == Column Names
# * class_num
# * course_id
# * section_setting_id
# * sec_id
# * sec_description
# * sec_capacity
# * crsatr_val
# * mode
# * acad_group
# * location
# * component
# 
# == Notes
# All the other *_id's correspond to another table, except sec_id.
# sec_id is the section number for a course.
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
class Section < ActiveRecord::Base

  # Initializes default values
  def initialize(params=nil)

    # === Params
    # what - a parameter hash value
    #
    # === Return
    # True if 'what' is an empty string
    #
    # False otherwise
    #
    # === Description
    # A method inside of initialize(params), finds out if string 
    # is empty.
    def is_str_empty?(what)
      what.class.name.eql?("String") && what.eql?("")
    end

    def default_val(what, val)
      (is_str_empty?(what) || what.nil?) ? val : what
    end

    return super if params.nil?
    params[:session] = default_val(params[:session], 1)
    params[:sec_id] = default_val(params[:sec_id], 1)
    params[:sec_capacity] = default_val(params[:sec_capacity], 0)

    super(params)
  end

  # Untested until section adding is implemented.
  #
  # Checks its section setting and finds out how many sections it has.  
  # If it has only one, delete the section setting.  
  # Then delete the section.
  def destruct
    if self.section_setting.sections.count == 1
      section_setting.destroy
    end
  end

  # Validator for Section
  class SectionValidator < ActiveModel::Validator

    def vnil(var)
      var.nil? ? 0 : var
    end

    def cond_error(r, cond, error)
      if cond
        r.errors[:base] << error
      end
    end

    def validate(record)
      cond_error(record, (vnil(record.sec_id) <= 0), "Section number <= 0")
      cond_error(record, (vnil(record.class_num) <= -1), "Negative class number")
      cond_error(record, (vnil(record.sec_capacity) <= -1), "Negative enroll cap")
      cond_error(record, (vnil(record.session) <= -1), "Negative session")
    end
  end

  before_destroy { destruct }

  belongs_to :course
  belongs_to :section_setting

  validates :sec_id, presence: true
  validates :course_id, presence: true
  
  validates :sec_id, numericality: { only_integer: true }
  validates :class_num, numericality: { only_integer: true }
  validates :sec_capacity, numericality: { only_integer: true }
  validates :session, numericality: { only_integer: true }

  validates_with SectionValidator
  
  # Combines multiple tables into one table for generating reports
  #
  # Returns the report table
  def self.report_table_array
    self.report_table_query.to_a
  end

  # Combines multiple tables into one table for generating reports
  #
  # Returns an array of rows
  def self.report_table_query
    report_query = ([]  << 'sections.id as id, ' << 
                        'sections.class_num as class_num, ' <<
                        'courses.subject as subject, ' <<
                        'courses.course_id as course_id, ' <<
                        'sections.sec_id as sec_id, ' <<
                        'courses.name as course_name, ' <<
                        'sections.sec_description as section_description, ' <<
                        'sections.acad_group as acad_group, ' <<
                        'sections.sec_capacity as enroll_cap, ' <<
                        'time_slots.days as days, ' <<
                        'time_slots.start_time as start_time, ' <<
                        'time_slots.end_time as end_time, ' <<
                        'rooms.building as building, ' <<
                        'rooms.room_num as room_num, ' <<
                        'rooms.room_capacity as room_cap, ' <<
                        'instructors.last_name as last_name, ' <<
                        'instructors.first_name as first_name, '  <<
                        'sections.role as role, ' <<
                        'course_dates.start_date as start_date, ' <<
                        'course_dates.end_date as end_date, ' <<
                        'sections.session as session, ' <<
                        'sections.location as location, ' <<
                        'sections.mode as mode, ' <<
                        'sections.crsatr_val as crsatr_val, ' <<
                        'sections.component as component').join("")
    
    Section.joins(:course, section_setting: [:instructor, :time_slot, :room, :course_date]).select(report_query)
  end

  def room_s
    "#{self.section_setting.room.building}#{self.section_setting.room.room_num}" unless self.section_setting.room.nil?
  end

  def time_s
    "#{self.section_setting.time_slot.days}   #{self.section_setting.time_slot.start_time}  -  #{self.section_setting.time_slot.end_time}" unless self.section_setting.time_slot.nil?
  end

  def instructor_s
    "#{self.section_setting.instructor.last_name}, #{self.section_setting.instructor.first_name}" unless self.section_setting.instructor.nil?
  end

  def date_s
    "#{self.section_setting.course_date.start_date} -- #{self.section_setting.course_date.end_date}" unless self.section_setting.course_date.nil?
  end

  def course_id_s
    "#{self.course.subject} #{self.course.course_id}-#{sprintf("%03d", self.sec_id)}"
  end
end
