require 'spec_helper'

module CourseParams
  def self.create_params(params)
    final_par = {subject: "", course_id: "", name: ""}

    params.each { |key, val| final_par[key] = val }

    final_par
  end
end

describe CoursesController do

  describe "POST create" do
    it "redirects to new if input is invalid" do
      params = CourseParams.create_params(course_id: -3)
      post :create, course: params 
      expect(response).to redirect_to(new_course_path)
    end

    context "if successful," do
      params = CourseParams.create_params(subject: "CSCI", course_id: 3333, name: "Test")
      it "redirects to index" do
        post :create, course: params
        expect(response).to redirect_to(courses_path)
      end

      it "puts the data into database" do
        post :create, course: params
        expect(Course.where(params).count).to eq(1)
      end
    end
	end

  describe "GET index" do
    it "assigns @courses" do
      course = Course.create(subject: "MATH", course_id: 2030, name: "Discrete Math")
      get :index
      expect(assigns[:courses][course.id - 1]).to eq(course)
    end
  end

  describe "PATCH update" do
    it "redirects to edit if input is invalid" do
      params = CourseParams.create_params(subject: "TEST", course_id: 1337, name: "Editz")
      course = Course.create(params)
      params[:id] = course.id
      params[:course_id] = -32

      patch :update, id: params[:id], course: params
      expect(response).to redirect_to(edit_course_path(params[:id]))
    end

    context "if successful," do
      params = CourseParams.create_params(subject: "FEAR", course_id: 666, name: "Satanic Panic")
      course = Course.create(params)
      params[:id] = course.id
      params[:course_id] = 616

      it "redirects to index if successful" do
        patch :update, id: params[:id], course: params
        expect(response).to redirect_to(courses_path)
      end

      it "updates the tuple" do
        patch :update, id: params[:id], course: params
        expect(Course.where(id: params[:id])[0].course_id).to eq(616)
      end
    end
  end
end
