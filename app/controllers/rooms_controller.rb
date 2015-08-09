class RoomsController < ApplicationController
  include RoomsHelper
  include ApplicationHelper

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    valid = @room.save
    #flash.notice = (valid ? "Room created successfully" : "Room not created: #{errors(@room)}")
    flash.notice = cu_flash(val: valid, action: 'created', model: "Room", record: @room)
    redirect_to (valid ? rooms_path : new_room_path)
  end

  def index
    @rooms = Room.all

    @get_class = table_row_class_proc
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    valid = @room.update(room_params)

    flash.notice = cu_flash(val: valid, action: 'updated', model: "Room", record: @room) 
    redirect_to (valid ? rooms_path : edit_room_path(params[:id]))
  end

  def destroy
    Room.find(params[:id]).destroy

    flash.notice = d_flash("Room")
    redirect_to rooms_path
  end
end
