module RoomsHelper
  def room_params
  	params[:room].each {|key, val| params[:room][key] = nil if val.empty? }
    params.require(:room).permit(:building, :room_num, :room_capacity, :desk_type, :board_type, :chair_type)
  end
end
