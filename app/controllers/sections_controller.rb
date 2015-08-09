class SectionsController < ApplicationController
  include SectionsHelper

  class Homie
    include ApplicationHelper
  end

	def new
    @section = Section.new
    @action = :create

    @room_props = Room.all_room_props

    @sets = get_option_list
    @sets[:course] = Course.find(params[:course_id]).to_arr_element
    @sets[:section] = nil
    @sets[:session] = 1
    @sets[:component] = "LEC"
    @sets[:class_nbr] = nil
    @sets[:seats] = 1

    @disabled = generate_disable_hash(:new)

    @textbox_vals = get_tb_attributes
  end

  def cross
    @section = Section.find(params[:id])
    @action = :create

    @room_props = Room.all_room_props

    @sets = get_option_list

    @sets = get_section_data(@sets, @section)

    @disabled = generate_disable_hash(:cross)

    @textbox_vals = get_tb_attributes
  end

  def combine
    @section = Section.find(params[:id])
    @action = :create

    @room_props = Room.all_room_props

    @sets = get_option_list

    @sets = get_section_data(@sets, @section)

    @disabled = generate_disable_hash(:combine)
    @textbox_vals = get_tb_attributes
  end

  def add_instructor
    @section = Section.find(params[:id])
    @action = :create

    @room_props = Room.all_room_props

    @sets = get_option_list

    @sets = get_section_data(@sets, @section)

    @disabled = generate_disable_hash(:instructor)

    @textbox_vals = get_tb_attributes
  end

  def create
    print params
    puts "\n\n"
    
    valid = true
    time = nil
    time_id = nil

    # Get time
    time_valid = !(time = get_time(params)).nil?
    time_id = Homie.new.insert_into(TimeSlot, days: time[:days], start_time: time[:start], end_time: time[:end]) if time_valid

    room_id = params[:room_num].to_i
    room_id = nil if room_id == 0

    inst_id = params[:instructor_list].to_i
    inst_id = nil if inst_id == 0

    date_id = params[:date_list].to_i
    date_id = nil if date_id == 0

    # Now get section setting
    ss_id = Homie.new.insert_into(SectionSetting, time_slot_id: time_id, room_id: room_id, instructor_id: inst_id, course_date_id: date_id)


    @section = Section.new(sec_params(params, ss_id))
    valid = @section.save

    flash.notice = cu_flash(val: valid, action: 'created', model: "Section", record: @section)

    redirect_to (valid ? course_path(params[:course_list].to_i) : :back)
  end

  def edit
    @section = Section.find(params[:id])
    @action = :update

    @room_props = Room.all_room_props

    @sets = get_option_list

    @sets = get_section_data(@sets, @section)

    @disabled = generate_disable_hash(:edit)

    @textbox_vals = get_tb_attributes
  end

  def update
    print params
    puts "\n\n"
    
    valid = true
    time = nil
    time_id = nil

    # Get time
    time_valid = !(time = get_time(params)).nil?
    time_id = Homie.new.insert_into(TimeSlot, days: time[:days], start_time: time[:start], end_time: time[:end]) if time_valid

    room_id = params[:room_num].to_i
    room_id = nil if room_id == 0

    inst_id = params[:instructor_list].to_i
    inst_id = nil if inst_id == 0

    date_id = params[:date_list].to_i
    date_id = nil if date_id == 0

    # Now get section setting
    ss_id = Homie.new.insert_into(SectionSetting, time_slot_id: time_id, room_id: room_id, instructor_id: inst_id, course_date_id: date_id)


    @section = Section.find(params[:id])
    valid = @section.update(sec_params(params, ss_id))

    flash.notice = cu_flash(val: valid, action: 'updated', model: "Section", record: @section)

    redirect_to (valid ? course_path(params[:course_list].to_i) : :back)
  end

  def destroy
    Section.find(params[:id]).destroy
    redirect_to courses_path
  end

  def update_list
    @new_sets = get_option_list(params)
    @disabled = {}
    @disabled[:room] = params[:room_disabled]
    @disabled[:time] = params[:time_disabled]
    @disabled[:instructor] = params[:instructor_disabled]
    @disabled[:seats] = params[:seat_disabled]

   # page["room"].replace_html partial: "pieces/room/room_num", locals: {rooms: @new_rooms}
  end
end
