class CoursesController < ApplicationController
  include CoursesHelper
  include ApplicationHelper

   
  
  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    valid = @course.save

    
    #flash.notice = (valid ? "Course created successfully" : "Instructor not created: #{errors(@course)}")
    flash.notice = cu_flash(val: valid, action: 'created', model: "Course", record: @course)
    redirect_to (valid ? courses_path : new_course_path)
  end

  def index
    @courses = Course.all.sort { |c1, c2| ("#{c1.subject}#{c1.course_id}" <=> "#{c2.subject}#{c2.course_id}") }
   # @get_class = table_row_class_proc
  end

  def show
    @course = Course.find(params[:id])
    @sections = @course.sections
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    valid = @course.update(course_params)

    flash.notice = cu_flash(val: valid, action: 'updated', model: "Course", record: @course)
    redirect_to (valid ? courses_path : edit_course_path(params[:id]))
  end

  def destroy
    Course.find(params[:id]).destroy
    flash.notice = d_flash("Course")
    redirect_to courses_path
  end
end
