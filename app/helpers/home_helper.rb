require 'csv'
require 'time'



module HomeHelper
  include ApplicationHelper
  
  def read_csv(file)
    csv = CSV.open file.path, headers: true

    csv.each { |row| put_row_into_database(row) }
  end

  def write_csv
    csv_file = "Class Nbr,Subject,Catalog,Section,Comb Sect,CDescr,SDescr,Acad Group,Cap Enrl,Tot Enrl,Pat,Mtg Start,Mtg End,Facil ID,Capacity,Last,First Name,Role,Start Date,End Date,Session,Location,Mode,CrsAtr Val,Component\n"

    sections = Section.report_table_array
    sections.each { |sec| csv_file << write_csv_line(sec) << "\n" }

    send_data csv_file, filename: "PKI Rooms.csv"
  end

  private

  def generate_csv_line_order
    [:class_num, :subject, :course_id, :sec_id, :comb, :course_name, :section_description, :acad_group, :enroll_cap, :tot_enr, :days, :start_time, :end_time, :room, :room_cap, :last_name, :first_name, :role, :start_date, :end_date, :session, :location, :mode, :crsatr_val, :component]
  end

  def write_csv_line(section)
    line = ""
    generate_csv_line_order.each_with_index { |item, i| line << (i > 0 ? "," : "") << handle_csv_item(section, item) }
    line
  end

  def handle_csv_item(sec, item)
    return case item
    when :comb
      csv_comb(sec)
    when :tot_enr
      "0"
    when :room
      building_room(sec)
    else
      enter_csv_item(sec, item)
    end
  end

  def enter_csv_item(sec, item)
    if sec[item] =~ /.*\,.*/
      return "\"#{sec[item]}\""
    else
      return "#{sec[item]}"
    end
  end
  
  def put_row_into_database(row)
    write_section(row, write_course(row))

    sleep(0.0001)
  end

  def write_section(row, course)
    section_setting = write_section_setting(row)
    insert_into Section, {class_num: row['Class Nbr'],
                          course_id: course,
                          section_setting_id: section_setting,
                          sec_id: row['Section'],
                          sec_description: row['SDescr'],
                          sec_capacity: row['Cap Enrl'],
                          acad_group: row['Acad Group'],
                          role: row['Role'],
                          session: row['Session'],
                          crsatr_val: row['CrsAtr Val'],
                          component: row['Component'],
                          location: row['Location'],
                          mode: row['Mode']}
  end

  def write_instructor(row)
    insert_into(Instructor, {first_name: row['First Name'], 
                             last_name: row['Last']})

  end

  def write_time_slot(row)
    insert_into TimeSlot,  {days: row['Pat'],
                            start_time: row['Mtg Start'],
                            end_time: row['Mtg End']}
  end

  def write_course_date(row)
    insert_into CourseDate, { start_date: row['Start Date'], 
                              end_date: row['End Date']}
  end

  def write_room(row)
    facil_id = get_building_and_room(row['Facil ID'])

    insert_into Room, { building: facil_id[:building],
                        room_num: facil_id[:room],
                        room_capacity: row['Capacity'] }
  end

  def write_section_setting(row)
    instructor = write_instructor(row)
    time_slot = write_time_slot(row)
    course_date = write_course_date(row)
    room = write_room(row)

    insert_into SectionSetting, { instructor_id: instructor,
                                  time_slot_id: time_slot,
                                  course_date_id: course_date,
                                  room_id: room }
  end

  def write_course(row)
    insert_into Course, subject: row['Subject'], course_id: row['Catalog'], name: row['CDescr']
  end

  def get_building_and_room(facil_id)
    facil_id.match(/([^0-9]+)([0-9]+)/)
    {building: $1, room: $2.to_i}
  end

  def building_room(section)
    "#{section[:building]}#{section[:room_num]}"
  end

  def csv_comb(sec)
    if Section.find(sec.id).section_setting.sections.count > 1
      "C"
    else
      ""
    end
  end
end

