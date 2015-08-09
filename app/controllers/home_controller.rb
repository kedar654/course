class HomeController < ApplicationController
  include HomeHelper

  def index
    redirect_to controller: :home, action: :list
  end

  def import

  end

  def do_import
    read_csv(params[:import][:file])

    flash.notice = "Successfully imported data"
    redirect_to '/'
  end

  def room_pdf
 
    PdfReport::Pdfreport.create_room_pdf(Section.find(:all))
    pdf_filename = File.join(Rails.root, "public/room.pdf")
    send_file(pdf_filename, :filename => "room.pdf", :type => "application/pdf")
  
    
    
  end
   
  def instructor_pdf
 
    if request.get?
     p "i am get request" 
    end
    if request.post?
    PdfReport::Pdfreport.create_instructor_pdf(Course.find(:all),params[:room_num])
    pdf_filename = File.join(Rails.root, "public/instructor.pdf")
    
    send_file(pdf_filename, :filename => "instructor.pdf", :type => "application/pdf")
 
      
    end
    
  end
  

  def export
    write_csv
    # redirect_to '/'
  end

  def list
    @report_table = Section.report_table_array
    @get_class = table_row_class_proc
  end

  def delete_all
    Course.destroy_all
    TimeSlot.destroy_all
    Instructor.destroy_all
    Room.destroy_all
    CourseDate.destroy_all

    flash.notice = "Deleted all data"
    redirect_to '/'

  end
end
