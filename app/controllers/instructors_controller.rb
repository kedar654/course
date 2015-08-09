class InstructorsController < ApplicationController
  include InstructorsHelper
  include ApplicationHelper

  def new
    @instructor = Instructor.new
  end

  def create
    @instructor = Instructor.new(instructor_params)
    valid = @instructor.save
    flash.notice = cu_flash(val: valid, action: 'created', model: "Instructor", record: @instructor)
   # flash.notice = (valid ? "Instructor created successfully" : "Instructor not created: #{errors(@instructor)}")
    redirect_to (valid ? instructors_path : new_instructor_path)
  end

  def index
    @instructors = Instructor.all

    @get_class = table_row_class_proc
  end

  def edit
    @instructor = Instructor.find(params[:id])
  end

  def update
    @instructor = Instructor.find(params[:id])
    valid = @instructor.update(instructor_params)

    flash.notice = cu_flash(val: valid, action: 'updated', model: "Instructor", record: @instructor)
    #flash.notice = (valid ? "Instructor updated successfully" : "Instructor not updated: #{errors(@instructor)}")
    redirect_to (valid ? instructors_path : new_instructor_path)
  end

  def destroy
    Instructor.find(params[:id]).destroy
    flash.notice = d_flash("Instructor")
    redirect_to instructors_path
  end
end
