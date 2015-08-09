module SectionsHelper
  include ApplicationHelper
  def get_option_list(params=nil)
    list = {}
    list[:rooms] = update_rooms(params) unless disabled(params, :room_disabled)
    list[:times] = update_times(params) unless disabled(params, :time_disabled)
    list[:instructors] = update_instructors(params) unless disabled(params, :instructor_disabled)
    list[:seat_lbl] = update_seats(params) unless disabled(params, :seat_disabled)
    list[:dates] = update_dates

    list[:room] = update_current_room(params, list) unless disabled(params, :room_disabled)
    list[:time] = update_current_time(params, list) unless disabled(params, :time_disabled)
    list[:instructor] = update_current_instructor(params, list) unless disabled(params, :instructor_disabled)

    list[:courses] = get_course_list

    list
  end

  def get_section_data(sets, sec)
    sets[:course] = sec.course.to_arr_element unless sec.course.nil?
    sets[:session] = sec.session
    sets[:component] = sec.component
    sets[:section] = sec.sec_id
    sets[:class_nbr] = sec.class_num
    sets[:date] = sec.section_setting.course_date.to_arr_element unless sec.section_setting.nil? || sec.section_setting.course_date.nil?
    sets[:room] = sec.section_setting.room.to_arr_element unless sec.section_setting.nil? || sec.section_setting.room.nil?
    sets[:instructor] = sec.section_setting.instructor.to_arr_element unless sec.section_setting.nil? || sec.section_setting.instructor.nil?
    sets[:time] = sec.section_setting.time_slot.to_sec_hash unless sec.section_setting.nil? || sec.section_setting.time_slot.nil? || sec.section_setting.time_slot.start_time.nil?
    sets[:sec_descr] = sec.sec_description
    sets[:crs_atr] = sec.crsatr_val
    sets[:role] = sec.role
    sets[:acad_group] = sec.acad_group
    sets[:location] = sec.location
    sets[:mode] = sec.mode
    sets[:seats] = sec.sec_capacity

    sets[:times][:end] = update_time(nil, :start)
    sets
  end

  def get_tb_attributes
    tb = {}
    tb[:placeholder] = get_placeholders
    tb[:label] = get_labels

    tb
  end

  def sec_params(params, ss)
    {course_id: params[:course_list].to_i, 
     section_setting_id: ss, 
     mode: params[:mode], 
     location: params[:location], 
     crsatr_val: params[:crs_atr], 
     sec_capacity: params[:seats], 
     class_num: params[:class_nbr].to_i, 
     role: params[:role], 
     acad_group: params[:acad_group], 
     sec_description: params[:sec_descr],
     component: params[:component],
     session: params[:session].to_i,
     sec_id: params[:section].to_i}
  end

  def generate_disable_hash(action)
    return generate_newdit_disable_hash if action == :new || action == :edit 
    return generate_inst_disable_hash if action == :instructor
    return generate_cross_disable_hash if action == :cross
    return generate_comb_disable_hash if action == :combine
  end

  def get_time(params)
    days = get_days(params)
    startt = get_start_time(params)
    endt = get_end_time(params)

    return nil if days.nil? || startt.nil? || endt.nil?

    time = {}
    time[:days] = days
    time[:start] = startt
    time[:end] = endt

    time
  end



  def update_rooms(params=nil)
    rooms = Room.all
    room_list = []
    room_list << default_element
    rooms.each { |r| room_list << r.to_arr_element if room_qualified?(r, params)}

    room_list
  end

  def update_times(params=nil)
    times = {}
    times[:days] = update_days(params)
    times[:start] = update_time(params, :start)
    times[:end] = update_time(params, :end)

    times
  end

  def update_instructors(params=nil)
    instructors = Instructor.all
    instructor_list = [] << default_element

    instructors.each { |i| instructor_list << i.to_arr_element if instructor_qualified?(i, params) }

    instructor_list
  end

  private

  def get_placeholders
    placeholders = {}
    placeholders[:descr] = "Describe, if necessary"
    placeholders[:number] = "Enter Number"
    placeholders[:data] = "Enter Data"
    placeholders[:comp] = "LAB-LEC-IND-SEM-FLD"

    placeholders
  end

  def get_labels
    labels = {}

    labels[:acad_group] = "Academic Group"
    labels[:role] = "Instructor Role"
    labels[:component] = "Component"
    labels[:session] = "Session Number"
    labels[:crs_atr] = "Cross Attribute"
    labels[:section] = "Section Number"
    labels[:sec_descr] = "Description"
    labels[:class_nbr] = "Class Number"
    labels[:location] = "Location"
    labels[:mode] = "Mode"

    labels
  end

  def generate_newdit_disable_hash
    exceptions = [:course]
    list = enable_all(exceptions)

    disable_hash(list)
  end

  def generate_inst_disable_hash
    exceptions = [:instructor]
    list = disable_all(exceptions)

    disable_hash(list)
  end

  def generate_cross_disable_hash
    exceptions = [:course, :class_nbr, :sec_descr, :location, :mode, :acad_group, :component]
    list = disable_all(exceptions)

    disable_hash(list)
  end

  def generate_comb_disable_hash
    exceptions = [:section, :class_nbr, :sec_descr, :location, :seats, :mode, :acad_group, :component]
    list = disable_all(exceptions)

    disable_hash(list)
  end

  def disable_hash(list)
    hash = {}

    generate_attributes.each do |ga|
      disable = list.any? { |l| l == ga }
      hash[ga] = disable
    end

    hash
  end

  def generate_attributes
    [:room, :time, :instructor, :class_nbr, :course, :component, :session, :sec_descr, :section, :location, :seats, :mode, :role, :date, :acad_group]
  end

  def enable_all(exceptions)
    exceptions
  end

  def disable_all(exceptions)
    generate_attributes.reject { |el| exceptions.any? { |ex| el == ex } }
  end

  def disabled(params, tag)
    return false if params.nil? || params[tag].nil?
    params[tag].eql?("true")
  end

  def update_days(params)
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  end

  def get_course_list
    list = []
    Course.all.each { |c| list << c.to_arr_element }
    list
  end

  def update_current_room(params, hash)

    return default_element if params.nil?

    room_id = params[:room].to_i

    return default_element if room_id == 0

    hash[:rooms].each do |room_set|
      return room_set if room_set[1] == room_id
    end

    puts "Here"
    default_element
  end

  def update_dates
    CourseDate.all.map { |d| d.to_arr_element}
  end

  def update_current_instructor(params, hash)
    return default_element if params.nil?

    inst_id = params[:instructor].to_i

    return default_element if inst_id == 0

    hash[:instructors].each { |set| return set if set[1] == inst_id }

    default_element
  end

  def update_current_time(params, hash)
    time = {}
    print params
    puts ""
    print hash
    puts ""
    return {period: default_element, hour: default_element, minute: default_element, start: {}, end: {}} if params.nil?

    time[:period] = update_current_time_piece(params[:etime_p], hash[:times][:end][:period])
    time[:hour] = update_current_time_piece(params[:etime_h], hash[:times][:end][:hours])
    time[:minute] = update_current_time_piece(params[:etime_m], hash[:times][:end][:minutes])

    print time
    puts ""
    time
  end

  def update_seats(params)
    return "" if params.nil?

    capacity = Room.find(params[:room].to_i).room_capacity

    capacity = capacity - params[:seats].to_i

    if capacity <= 0
      return "OUT OF ROOM"
    else
      return "#{capacity} seats left in room"
    end
  end

  def update_current_time_piece(piece, list)
    puts "piece: #{piece}"
    list.each do |item|
      return item if piece.eql?(item[1].to_s)
    end

    default_element
  end

  def update_time(params, what)
    time = {}
    time = update_from_times(params) if what == :end

    unless what == :end
      time[:period] = update_period(params)
      time[:hours] = update_hours(params)
      time[:minutes] = update_minutes(params)
    end

    time
  end

  def update_period(params)
    periods = []
    periods << default_element
    periods << ["AM", "AM"]
    periods << ["PM", "PM"]

    periods
  end

  def update_hours(params)
    hours = []
    hours << default_element
    (1..12).each { |n| hours << [n.to_s, n] }
    hours
  end

  def update_minutes(params)
    minutes = []
    minutes << default_element
    (0..11).each { |n| minutes << [sprintf("%02d", n * 5), n * 5] }
    minutes
  end

  def room_qualified?(room, params)
   # puts params
    return true if params.nil?
   # puts "Here"
    return false unless radio_button_good?(params[:board], room.board_type)
    return false unless radio_button_good?(params[:chair], room.chair_type)
    return false unless radio_button_good?(params[:desk], room.desk_type)

    time_conflicting = time_taken?(Room, room, params)
    #return false unless params[:board].nil? || params[:board].eql?("on") || room.board_type.eql?(params[:board])
   # return false unless params[:board]
   # puts "Must be true"
    true && !time_conflicting
  end

  def instructor_qualified?(inst, params)

    return true if params.nil?

    return !time_taken?(Instructor, inst, params)
  end

  def radio_button_good?(param, checker)
    param.nil? || param.eql?("on") || checker.eql?(param)
  end

  # time_taken?
  # Takes a room or instructor, and given the time parameters
  # from the form, check against all times object currently has.
  #
  # Attack this problem like a bounding box collision detection type
  # of problem.
  #
  # If any time is invalid, time is not taken, so return false
  #
  # We work in 24h format, since we are going to use the hour() and minute()
  # methods from ApplicationHelper.
  #
  # Think of hours as X, and minutes as Y.  We multiply X by 60, and add it
  # to Y.  This gives a low number, and a high number.  This is our time range.
  #
  # Before we compare the times, we take all the days that are checked.  If no days
  # are checked, then we say time is not taken.  When we begin to iterate through
  # the time slots, we check the days against our selected days.  If there is a one
  # or more letter match, we test the times, otherwise we skip the entry.
  #
  # If one edge is in the other's range, time is taken
  # If this above condition is false, we check the other side, time is taken if we have match
  # If this is not true, then time is ultimately not taken for this value.
  # return false
  #
  # Oh, and model is not necessary, sorry.
  def time_taken?(model, ss_obj, params)
    stime = time_format(params[:stime_h], params[:stime_m], params[:stime_p])
    etime = time_format(params[:etime_h], params[:etime_m], params[:etime_p])

    # Invalid time, do not care
    return false if stime.nil? || etime.nil?

    time_wanted = get_range_times(stime, etime)

    # Get the days in an array.
    # If nothing is checked, get the
    # fuck out of here, man!  Evolution!
    days = checked_days(params)
    return false if days.size == 0

    ss_obj.section_settings.each { |s| return true if has_conflict?(s.time_slot, days, time_wanted) }
    
    false
  end

  def get_range_times(stime, etime)
    time = {}
    time[:x] = timerange(stime)
    time[:y] = timerange(etime)

    time
  end

  def timerange(time)
    hour(time) * 60 + minute(time)
  end

  def checked_days(params)
    checked = []
    [:mon, :tue, :wed, :thu, :fri, :sat].each { |v| checked << params[v] unless params[v].nil? }
    checked
  end

  def time_format(hour, minute, period)
    return nil if hour.empty? || minute.empty? || period.empty?

    "#{hour}:#{sprintf("%02d", minute)}:00 #{period}"
  end

  # We first check the days and see if we have any match.
  # If not, return false.
  #
  # Then we make another range of times for our obj time
  #
  def has_conflict?(ts, days, t_range)
    slot_days = ts.days
    return false if no_matching_days?(slot_days, days)

    # We have matching days, so continue on.
    slot_range = get_range_times(ts.start_time, ts.end_time)

    collided?(t_range, slot_range)
  end

  def no_matching_days?(day_str, day_arr)
    day_arr.each { |day| return false if day_str =~ /.*#{day}.*/ }

    true
  end

  def collided?(r, s)
    any_ledge_collision?(r, s) || any_redge_collision?(r, s)
  end

  def any_ledge_collision?(r, s)
    ledge_in_range?(r, s) || ledge_in_range?(s, r)
  end

  def any_redge_collision?(r, s)
    redge_in_range?(r, s) || redge_in_range?(s, r)
  end

  def ledge_in_range?(r, s)
    (r[:x] >= s[:x] && r[:x] <= s[:y])
  end

  def redge_in_range?(r, s)
    r[:y] >= s[:x] && r[:y] <= s[:y]
  end

  def default_element
    ["None", nil]
  end

  def update_from_times(params)
    valid = !(params.nil? || params[:stime_h].empty? || params[:stime_m].empty? || params[:stime_p].empty?)
    time = {}
    
    time[:period] = [] << default_element
    time[:hours] = [] << default_element
    time[:minutes] = [] << default_element

    time = add_time_end(params, time) if valid

    time
  end

  def add_time_end(params, time)
    time[:period] = add_end_period(params, time[:period])
    time[:hours] = add_end_hours(params, time[:hours])
    time[:minutes] = add_end_minutes(params, time[:minutes])

    time
  end

  def add_end_period(params, periods)
    ["AM", "PM"].each { |p| periods << [p, p] if period_qualified?(params, p) }
    periods
  end

  def add_end_hours(params, hours)
    (1..12).each { |h| hours << [h.to_s, h] if hour_qualified?(params, h) }
    hours
  end

  def add_end_minutes(params, minutes)
    (0..11).each { |m| minutes << [sprintf("%02d", m * 5), m * 5] if minute_qualified?(params, m * 5) }
    minutes
  end

  def period_qualified?(params, p)
    return false if p.eql?("AM") && params[:stime_p].eql?("PM")

    if p.eql?("AM")
      return false if cannot_advance_period?(params)
      return true
    end

    if p.eql?("PM")
      return true if params[:stime_p].eql?("AM")
      return false if cannot_advance_period?(params)
    end

    true
  end

  def cannot_advance_period?(params)
    return params[:stime_h].to_i == 11 && params[:stime_m].to_i == 55
  end

  def hour_qualified?(params, h)

    # Start hour and current hour
    sh = params[:stime_h]
    ch = h

    return false if params[:etime_p].empty?

    # Start time is in the AM, and end time is in PM, all is allowed
    return true if !params[:stime_p].eql?(params[:etime_p])

    # Same hour
    ch = "0" if ch.to_i == 12
    sh = "0" if sh.to_i == 12
    if ch.to_i == sh.to_i
      # Cannot go beyond 55 minutes in 5 minute interval
      return false if params[:stime_m].to_i == 55
      return true
    end

    # We know that periods match at this point.
    # Disqualified if hour is less than start hour
    return false if ch.to_i < sh.to_i

    true
  end

  def minute_qualified?(params, m)
    return false if params[:etime_h].empty? || params[:etime_p].empty?

    # Hour equal and period not equal
    # Always true
    return true if !params[:etime_p].eql?(params[:stime_p])

    # We know period is equal
    # If hour is equal, then all all minutes less than or equal
    # to start minutes are bad
    return false if params[:etime_h].eql?(params[:stime_h]) && m.to_i <= params[:stime_m].to_i

    # Hour is not equal
    # All else is true
    true
  end

  def get_days(params)
    options = {mon: "M", tue: "T", wed: "W", thu: "R", fri: "F", sat: "S"}

    day_str = ""
    options.each { |key, val| day_str += (params[key].nil? ? "" : val) }
    day_str.empty? ? nil : day_str
  end

  def get_start_time(params)
    get_setime(params, {hr: :start_hours, min: :start_minutes, per: :start_periods})
  end

  def get_end_time(params)
    get_setime(params, {hr: :end_hours, min: :end_minutes, per: :end_periods})
  end

  def get_setime(params, using)
  	hour = nil
  	min = nil
  	per = nil

    hour = params[using[:hr]] unless params[using[:hr]].empty?
    min = sprintf("%02d", params[using[:min]]) unless params[using[:min]].empty?
    per = params[using[:per]] unless params[using[:per]].empty?

    return nil if hour.nil? || min.nil? || per.nil?

    #time = "#{params[using[:hr]]}:#{params[using[:min]]}:00 #{params[using[:per]]}"
    "#{hour}:#{min}:00 #{per}"
  end

end
