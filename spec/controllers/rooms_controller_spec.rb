require 'spec_helper'

module RoomParams
  def self.create_params(params)
    final_par = {building: "", room_num: "", room_capacity: ""}

    params.each { |key, val| final_par[key] = val }

    final_par
  end
end

describe RoomsController do

  describe "POST create" do
    it "redirects to new if input is invalid" do
      params = RoomParams.create_params(room_capacity: -3)
      post :create, room: params 
      expect(response).to redirect_to(new_room_path)
    end

    context "if successful," do
      #params = {building: "PKI", room_num: 123, room_capacity: 3, desk_type: "", chair_type: "", board_type: ""}
      params = RoomParams.create_params(building: "PKI", room_num: 123, room_capacity: 3)
      it "redirects to index" do
        post :create, room: params
        expect(response).to redirect_to(rooms_path)
      end

      it "puts the data into database" do
        post :create, room: params
        expect(Room.where(params).count).to eq(1)
      end
    end
	end

  describe "GET index" do
    it "assigns @rooms" do
      room = Room.create(building: 'PKI', room_num: 323)
      get :index
      expect(assigns[:rooms][room.id - 1]).to eq(room)
    end
  end

  describe "PATCH update" do
    it "redirects to edit if input is invalid" do
      params = RoomParams.create_params(room_num: 255, building: "PKI")
      room = Room.create(params)
      params[:id] = room.id
      params[:room_num] = -32

      patch :update, id: params[:id], room: params
      expect(response).to redirect_to(edit_room_path(room.id))
    end

    context "if successful," do
      params = RoomParams.create_params(building: "PKI", room_num: 325, room_capacity: 1)
      Room.create(params)
      params[:id] = Room.where(params)[0].id
      params[:room_capacity] = 20

      it "redirects to index if successful" do
        patch :update, id: params[:id], room: params
        expect(response).to redirect_to(rooms_path)
      end

      it "updates the tuple" do
        patch :update, id: params[:id], room: params
        expect(Room.where(id: params[:id])[0].room_capacity).to eq(20)
      end
    end
  end
end
