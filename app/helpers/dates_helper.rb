require 'date'

module DatesHelper
  def get_month_hash
    (1..12).map { |n| [Date.new(2000, n, 1).strftime("%B"), n] }
  end

  def get_year_hash
    (2014..2362).map { |n| ["#{n}", n] }
  end

  def get_day_hash
    (1..31).map { |n| ["#{n}", n] }
  end

  def split_date_params(params)
    syr = get_year(params.start_date)
    smt = get_month(params.start_date)
    sdy = get_day(params.start_date)

    eyr = get_year(params.end_date)
    emt = get_month(params.end_date)
    edy = get_day(params.end_date)

    cdate = {}
    cdate[:start_date_year] = get_num_hash(syr)
    cdate[:start_date_month] = get_num_hash(smt)
    cdate[:start_date_day] = get_num_hash(sdy)

    cdate[:end_date_year] = get_num_hash(eyr)
    cdate[:end_date_month] = get_num_hash(emt)
    cdate[:end_date_day] = get_num_hash(edy)

    cdate
  end

  def get_year(date)
    get_date(date).year 
  end

  def get_month(date)
    get_date(date).month 
  end

  def get_day(date)
    get_date(date).day
  end

  def get_sdate(params)
    get_sedate(params, {yr: :start_date_year, mt: :start_date_month, dy: :start_date_day})
  end

  def get_edate(params)
     get_sedate(params, {yr: :end_date_year, mt: :end_date_month, dy: :end_date_day})
  end

  def get_sedate(params, using)
    "#{params[using[:mt]]}/#{sprintf("%d", params[using[:dy]])}/#{sprintf("%d", params[using[:yr]])}"
  end

  private

  def get_date(date)
    Date.strptime(date, '%m/%d/%Y')
  end

  def get_num_hash(val)
    ["#{val}", val]
  end

end
