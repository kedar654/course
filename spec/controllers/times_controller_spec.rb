require 'spec_helper'
=begin
def create_params(params)
  final_par = {start_time: "", end_time: ""}

  params.each { |key, val| final_par[key] = val }

  final_par
end

describe TimesController do
  describe "POST create" do
    it "redirects to new if input is invalid" do
      params = {monday: true, s_hr: 12, s_min: 30, s_per: "PM", e_hr: 12, e_min: 0, s_per: "PM"}
      post :create, params 
      expect(response).to redirect_to(new_time_path)
    end

    context "if successful," do
      params = {monday: true, s_hr: 12, s_min: 30, s_per: "PM", e_hr: 2, e_min: 25, e_per: "PM"}
      it "redirects to index" do
        post :create, params
        expect(response).to redirect_to(times_path)
      end

      it "puts the data into database" do
        post :create, params
        expect(TimeSlot.where(days: "M", start_time: "12:30:00 PM", end_time: "2:25:00 PM").count).to eq(1)
      end
    end
  end

  describe "GET index" do
    it "assigns @time_slots" do
      time_slot = TimeSlot.create(days: "W", start_time: "2:45:00 PM", end_time: "3:00:00 PM")
      get :index
      expect(assigns[:times][time_slot.id - 1]).to eq(time_slot)
    end
  end
end
=end