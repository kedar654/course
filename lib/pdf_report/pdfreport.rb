module PdfReport

  class Pdfreport
  
    require "prawn"
 
    require 'prawn/table'

    def self.create_instructor_pdf(reportvalue,room_num)
      Prawn::Document.generate("#{Rails.root}/public/instructor.pdf",:page_size => [1000, 1500] ) do 
        font "Times-Roman", :style => :bold,:size=>15
        draw_text("AS OF #{Date.today.strftime("%d/%m/%y")}" , :size=>13,:at => [ 10, (bounds.top - 2)])
        draw_text("PKI #{room_num}" , :size=>13,:at => [ 10, (bounds.top - 25)])
        move_down 10
        font "Times-Roman", :style => :normal,:size=>17
        
        data = [["Time","Monday","Tuesday","Wensday","Thursday","Friday"],
          ["0730",""," "," "," "," "],
          ["0800"," "," "," "," "," "],
          ["0830"," "," "," "," "," "],
          ["0900"," "," "," "," "," "],
          ["0930"," "," "," "," "," "],
          ["1000"," "," "," "," "," "],
          ["1030"," "," "," "," "," "],
          ["1100"," "," "," "," "," "],
          ["1130"," "," "," "," "," "],
          ["1200"," "," "," "," "," "],
          ["1230"," "," "," "," "," "],
          ["1300"," "," "," "," "," "],
          ["1330"," "," "," "," "," "],
          ["1400"," "," "," "," "," "],
          ["1430"," "," "," "," "," "],
          ["1500"," "," "," "," "," "],
          ["1530"," "," "," "," "," "],
          ["1600"," "," "," "," "," "],
          ["1650"," "," "," "," "," "],
          ["1700"," "," "," "," "," "],
          ["1730"," "," "," "," "," "],
          ["1800"," "," "," "," "," "],
          ["1830"," "," "," "," "," "],
          ["1900"," "," "," "," "," "],
          ["1930"," "," "," "," "," "],
          ["2000"," "," "," "," "," "],
          ["2030"," "," "," "," "," "],
          ["2100"," "," "," "," "," "],
          ["2130"," "," "," "," "," "],
          ["2200"," "," "," "," "," "],
          ["2230"," "," "," "," "," "],
          ["2300"," "," "," "," "," "],
          ["2330"," "," "," "," "," "],
          ["2400"," "," "," "," "," "]  
        ]  
        dayarray = {  "M"=>1,"T"=>2,"W"=>3,"R"=>4,"F"=>5,"S"=>6}
        timearray = [ [7,30,1],[8,0,2],[8,30,3],[9,0,4],[9,30,5],[10,0,6],[10,30,7],[11,0,8],[11,30,9],[12,0,10],[12,30,11],[13,0,12],[13,30,13],[14,0,14],[14,30,15],[15,0,16],[15,30,17],[16,0,18],[16,30,19],[17,0,20],[17,30,21],[18,0,22],[18,30,23],[19,0,24],[19,30,25],[20,0,26],[20,30,27],[21,0,28],[21,30,29],[22,0,30],[22,30,31],[23,0,32],[23,30,33],[24,0,34] ]
         reportvalue.each do |course|
          course.sections.each do |section|
            if section.section_setting
            if section.section_setting.room
            if section.section_setting.course_date  
            if  section.section_setting.time_slot 
            if  section.section_setting.room.room_num == room_num.to_i
             # start_date = Date.parse(section.section_setting.course_date.start_date.split("/")[1]+"/"+section.section_setting.course_date.start_date.split("/")[0] +"/" + section.section_setting.course_date.start_date.split("/")[2])
             # end_date = Date.parse(section.section_setting.course_date.end_date.split("/")[1]+"/"+section.section_setting.course_date.end_date.split("/")[0]+"/"+section.section_setting.course_date.end_date.split("/")[2] )
              if true#Date.today >= start_date
                if true#Date.today <= end_date
                  dayarray.each do |dkey,dvalue|
                    if section.section_setting.time_slot.days.include? dkey  
                      timearray.each do |key|
                        current_time = Time.new(Date.today.year,Date.today.month,Date.today.day, key[0], key[1], 00) 
                        starthour = section.section_setting.time_slot.start_time.split(":")[0].to_i
                        startminut = section.section_setting.time_slot.start_time.split(":")[1].to_i
                        endthour = section.section_setting.time_slot.end_time.split(":")[0].to_i
                        endminut = section.section_setting.time_slot.end_time.split(":")[1].to_i
                        if  section.section_setting.time_slot.start_time.include? "PM"
                          if section.section_setting.time_slot.start_time.split(":")[0].to_i > 11
                            starthour = section.section_setting.time_slot.start_time.split(":")[0].to_i + 11
                          else
                            starthour = section.section_setting.time_slot.start_time.split(":")[0].to_i + 12
                          end
                        end        
                        if  section.section_setting.time_slot.end_time.include? "PM"
                          if   section.section_setting.time_slot.end_time.split(":")[0].to_i > 11
                            endthour = section.section_setting.time_slot.end_time.split(":")[0].to_i + 11
                          else
                            endthour = section.section_setting.time_slot.end_time.split(":")[0].to_i + 12
                          end
                        end        
                        start_time = Time.new(Date.today.year,Date.today.month,Date.today.day, starthour, startminut, 00)
                        end_time = Time.new(Date.today.year,Date.today.month,Date.today.day, endthour, endminut, 00)
                        if ( start_time.between?(current_time,(current_time+29.minutes)) )    
                          data[key[2]][dvalue] = "#{course.subject.upcase}#{course.course_id}"
                        end
                        if ( start_time < current_time and  end_time >= (current_time) )
                          data[key[2]][dvalue] = "#{course.subject.upcase}#{course.course_id}"
                        end         
                        if ( start_time < current_time and  end_time >= (current_time-29.minutes) )    
                          data[key[2]][dvalue] = "#{course.subject.upcase}#{course.course_id}"
                        end 
                      end
                    end
                  end  
                end
              end
            end
          end
            end
            end
          end
          end       
        end
        move_down 20
        indent(150) do
          table(data)
        end                            
      end
    end
  
  
    def self.create_room_pdf(reportvalue)
      Prawn::Document.generate("#{Rails.root}/public/room.pdf",:page_size => [1000, 1500] ) do  
        @total_pages = reportvalue.size / 10
        if reportvalue.size % 10 != 0
          @total_pages = @total_pages + 1
        end
        @start_page = 0
        def create_header
          @start_page = @start_page + 1
          font "Times-Roman", :style => :bold
          draw_text('University of Nebraska-Omaha', :size=>16,:at => [350, (bounds.top - 2)])
          font "Times-Roman", :style => :bold
          draw_text('Page No', :at => [750, (bounds.top - 2)])
          font "Times-Roman", :style => :normal
          draw_text("#{@start_page}" , :at => [810, (bounds.top - 2)])
          font "Times-Roman", :style => :bold
          draw_text('of', :at => [830, (bounds.top - 2)])
          font "Times-Roman", :style => :normal
          draw_text( "#{@total_pages}", :at => [860, (bounds.top - 2)])
          font "Times-Roman", :style => :bold
          draw_text('Schedule of Classes for Spring 2014', :size=>16, :at => [330, (bounds.top - 21)])
          draw_text('Run Date', :at => [750, (bounds.top - 15)])
          font "Times-Roman", :style => :normal
          draw_text( "#{ Date.today.strftime("%d/%m/%y")}", :at => [810, (bounds.top - 15)])
          font "Times-Roman", :style => :bold
          draw_text('Regular acadamic session', :size=>16, :at => [360, (bounds.top - 39)])
          font "Times-Roman", :style => :bold
          draw_text('Run Time', :at => [750, (bounds.top - 27)])
          font "Times-Roman", :style => :normal
          draw_text("#{Time.now.strftime("%H:%M:%S")}", :at => [810, (bounds.top - 27)])
          font "Times-Roman", :style => :bold
          draw_text('Information Science & Tech and Computer Science', :size=>16,:at => [290, (bounds.top - 68)])
          x=0
          y=100      
          font "Times-Roman", :style => :normal
          draw_text 'Subject', :at => [x, (bounds.top - y)],   :size=>15
             
          x=x+60
          draw_text 'Catelog Nbr', :at => [x, (bounds.top - y)],     :size=>15
          x=x+90
          draw_text 'Section', :at => [x, (bounds.top - y)],         :size=>15
          x=x+60
          draw_text 'Class Nbr', :at => [x, (bounds.top - y)],          :size=>15
          x=x+70
          draw_text 'Course Title', :at => [x, (bounds.top - y)],        :size=>15
          x=x+180
          draw_text 'Component', :at => [x, (bounds.top - y)],       :size=>15
          x=x+100
          draw_text 'Units', :at => [x, (bounds.top - y)],         :size=>15
          x=x+80
          draw_text 'Topics', :at => [x, (bounds.top - y)],      :size=>15
          ###################3end of subject top line
          font "Times-Roman", :style => :normal
        end
        create_header
        x=640
        y=100
        j=-1
        for i in 1..reportvalue.size do
          j=j+1
          reportvalue[j]
          y=y+10
          stroke do
            horizontal_line(0, 800, :at => bounds.top - y)
          end
          y=y+20 
          x=0
          draw_text  "#{reportvalue[j].course.subject}", :at => [x, (bounds.top - y)], :size=>'13' if  reportvalue[j].course
          x=60
          draw_text "#{reportvalue[j].course.course_id}", :at => [x, (bounds.top - y)],:size=>'13' if  reportvalue[j].course 
          x=x+90
          draw_text "#{reportvalue[j].sec_id}", :at => [x, (bounds.top - y)],        :size=>'13' 
          x=x+60
          draw_text "#{reportvalue[j].class_num}", :at => [x, (bounds.top - y)],:size=>'13' 
          x=x+70
          draw_text "#{reportvalue[j].course.name}", :at => [x, (bounds.top - y)],      :size=>'13' 
          x=x+180
          draw_text "#{reportvalue[j].component}", :at => [x, (bounds.top - y)],      :size=>'13' 
          draw_text "#{reportvalue[j].mode}", :at => [x-10, (bounds.top - (y+15))],    :size=>'13' 
          x=x+100
          draw_text '3', :at => [x, (bounds.top - y)],       :size=>'13' 
          x=x+80
          draw_text 'topics', :at => [x, (bounds.top - y)],       :size=>'13' 
          y=y+40
          x=0
          draw_text 'Bldg', :at => [x, (bounds.top - y)],        :size=>13 
          font "Times-Roman", :style => :normal
          x=x+30
          draw_text "#{reportvalue[j].location}", :at => [x, (bounds.top - y)],        :size=>13 
          x=x+170
          draw_text 'Room', :at => [x, (bounds.top - y)],         :size=>13 
          font "Times-Roman", :style => :normal
          x=x+35
          draw_text  "#{reportvalue[j].section_setting.room.room_num}", :at => [x, (bounds.top - y)], :size=>13   if  reportvalue[j].section_setting.room
          x=x+50
          draw_text 'Days', :at => [x, (bounds.top - y)],            :size=>13 
          x=x+35
          font "Times-Roman", :style => :normal
          draw_text  "#{reportvalue[j].section_setting.time_slot.days}", :at => [x, (bounds.top - y)],:size=>13  if reportvalue[j].section_setting.time_slot
          x=x+70
          draw_text 'Time', :at => [x, (bounds.top - y)],            :size=>13 
          font "Times-Roman", :style => :normal
          x=x+30
          draw_text  "#{reportvalue[j].section_setting.time_slot.start_time} - #{reportvalue[j].section_setting.time_slot.end_time}", :at => [x, (bounds.top - y)],:size=>13 if reportvalue[j].section_setting.time_slot 
          x=x+155
          draw_text 'Intructer', :at => [x, (bounds.top - y)],          :size=>13 
          x=x+70
          font "Times-Roman", :style => :normal
          draw_text "#{reportvalue[j].section_setting.instructor.first_name} #{reportvalue[j].section_setting.instructor.last_name}", :at => [x, (bounds.top - y)],:size=>13  if reportvalue[j].section_setting.instructor
          x=0
          y=y+40  
          draw_text 'Class Entrl Capacity', :at => [x, (bounds.top - y)],           :size=>13 
          x=x+120
          font "Times-Roman", :style => :normal
          draw_text "#{reportvalue[j].sec_capacity}", :at => [x, (bounds.top - y)],        :size=>13 
          x=x+40
          draw_text 'Class Entrl Tot', :at => [x, (bounds.top - y)],       :size=>13 
          x=x+90
          font "Times-Roman", :style => :normal
          draw_text  "0", :at => [x, (bounds.top - y)],        :size=>13 
          x=x+50
          draw_text 'Class Waite Cap', :at => [x, (bounds.top - y)],         :size=>13 
          x=x+100
          font "Times-Roman", :style => :normal
          draw_text  "0", :at => [x, (bounds.top - y)],        :size=>13 
          x=x+30
          draw_text 'Class Wait Tot', :at => [x, (bounds.top - y)],
            :size=>13 
          x=x+90
          font "Times-Roman", :style => :normal
          draw_text "0", :at => [x, (bounds.top - y)],         :size=>13 
          x=x+40
          draw_text 'Class Min Enrol', :at => [x, (bounds.top - y)],        :size=>13 
          x=x+100
          font "Times-Roman", :style => :normal
          draw_text  "0", :at => [x, (bounds.top - y)],        :size=>13 
          if i%10 == 0 and i !=  reportvalue.size
            start_new_page
            #start new page
            create_header
            x=640
            y=100

          end
        end
      end
    end
  end
end
