module TimesHelper
  include ApplicationHelper

  def get_time_assoc
    TimeSlot.all.map{ |time| yield(time) }
  end

  def get_time_instructors
    get_time_assoc { |t| get_time_instructor(t) }
  end

  def get_time_instructor(time)
    time.section_settings.size
  end

  def get_time_sections
    get_time_assoc { |t| get_time_section(t) }
  end

  def get_time_section(time)
    sum = 0
    time.section_settings.each { |ss| sum += ss.sections.size }
    
    sum
  end

  def get_time_rooms
    get_time_assoc { |t| get_time_room(t) }
  end

  def get_time_room(time)
    time.section_settings.select('room_id').uniq.count
  end

  def get_hour_hash
    (1..12).map { |n| [n.to_s, n] }
  end

  def get_minute_hash
     (0..11).map { |n| [sprintf("%02d", n * 5), sprintf("%02d", n * 5)]}
  end

  def get_period_hash
    [["AM", "AM"],
     ["PM", "PM"]]
  end

  def get_days(params)
    options = {monday: "M", tuesday: "T", wednesday: "W", thursday: "R", friday: "F", saturday: "S"}

    day_str = ""
    options.each { |key, val| day_str += (params[key].nil? ? "" : val) }
    day_str
  end

  def get_stime(params)
    get_setime(params, {hr: :s_hr, min: :s_min, per: :s_per})

  end

  def get_etime(params)
     get_setime(params, {hr: :e_hr, min: :e_min, per: :e_per})
  end

  def get_setime(params, using)
    time = "#{params[using[:hr]]}:#{params[using[:min]]}:00 #{params[using[:per]]}"

  end

end
