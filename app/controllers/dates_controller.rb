class DatesController < ApplicationController
  include DatesHelper
  include ApplicationHelper
  def new
    @date = CourseDate.new
    @year_hash = get_year_hash
    @month_hash = get_month_hash
    @day_hash = get_day_hash

    @s_year = ["2014", 2014]
    @s_month = ["1", 1]
    @s_day = ["1", 1]

    @e_year = @s_year
    @e_month = @s_month
    @e_day = @s_day

    @action = :create
  end

  def create
    start_date = (params[:start_date].nil? ? get_sdate(params) : params[:start_date])
    end_date = (params[:end_date].nil? ? get_edate(params) : params[:end_date])

    @date = CourseDate.new(start_date: start_date, end_date: end_date)
    valid = @date.save
    
    flash.notice = cu_flash(val: valid, action: 'created', model: "Date", record: @date)
    
    redirect_to (valid ? dates_path : new_date_path)
  end

  def index
    @dates = CourseDate.all
    @get_class = table_row_class_proc
  end

  def edit
    @date = CourseDate.find(params[:id])

    @year_hash = get_year_hash
    @month_hash = get_month_hash
    @day_hash = get_day_hash

    params = split_date_params(@date)

    @s_year = params[:start_date_year]
    @s_month = params[:start_date_month]
    @s_day = params[:start_date_day]

    @e_year = params[:end_date_year]
    @e_month = params[:end_date_month]
    @e_day = params[:end_date_day]

    @action = :update

    # Set in view the default values.
  end

  def update
    start_date = (params[:start_date].nil? ? get_sdate(params) : params[:start_date])
    end_date = (params[:end_date].nil? ? get_edate(params) : params[:end_date])

    @date = CourseDate.find(params[:id])
    
    valid = @date.update(start_date: start_date, end_date: end_date)
    flash.notice = cu_flash(val: valid, action: 'updated', model: "Date", record: @date)
    redirect_to (valid ? dates_path : edit_date_path(params[:id]))
  end
end
