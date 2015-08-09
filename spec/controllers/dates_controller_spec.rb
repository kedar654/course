require 'spec_helper'

describe DatesController do
  describe "POST create," do
    describe "if successful," do
      params = {start_date: "1/1/2014", end_date: "5/6/2014"}

      it "redirects to index" do
        post :create, params
        expect(response).to redirect_to(dates_path)
      end

      it "puts data into database" do
        post :create, params
        expect(CourseDate.where(params).count).to eq(1)
      end
    end

    describe "if not successful," do
      params = {start_date: "2-5asg", end_date: "asdgga"}

      it "redirects to new" do
        post :create, params
        expect(response).to redirect_to(new_date_path)
      end
    end
  end

  describe "PATCH update" do
    params = {start_date: "1/1/2015", end_date: "6/6/2015"}
    date = CourseDate.create(params)
    params[:id] = date.id

    describe "if successful," do
      params[:start_date] = "1/2/2015"
      params[:end_date] = "6/7/2015"

      it "redirects to index" do
        patch(:update, params)
        expect(response).to redirect_to(dates_path)
      end

      it "updates data" do
        patch(:update, params)
        expect(CourseDate.where(params).count).to eq(1)
      end
    end

    describe "if not successful," do
      non_params = {}
      non_params[:start_date] = "fffff"
      non_params[:end_date] = "ffff"
      non_params[:id] = params[:id]

      it "redirects to edit" do
        patch(:update, non_params)
        expect(response).to redirect_to(edit_date_path(non_params[:id]))
      end
    end
  end
end
