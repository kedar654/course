require 'time'
require 'date'

module ApplicationHelper
  # === Parameters:
  # model - model class name (eg: Instructor, Section, etc.)
  #
  # values - hash with column_names, and tuple values
  #
  # === Description
  # Inserts values into model database and returns
  # the id
  #
  # If values already exist in the database,
  # return the id of the tuple with same values.
  #
  # === Example call
  #   insert_into Instructor, first_name: "Harvey", last_name "Siy"
  def insert_into(model, values)
    return model.where(values).select(:id)[0].id if model.where(values).count > 0

    model.create(values)
    model.last.id
  end

  def table_row_class_proc
    Proc.new { |n| n % 2 == 0 ? "table-row-even" : "table-row-odd" }
  end

  def hour(time)
    time_conv(time).hour
  end

  def minute(time)
    time_conv(time).min
  end

  def hour_murica(time)  # Fuck yeah!
    time_conv(time).strftime("%I").to_i
  end

  def period_murica(time) # Fuck yeah?...
    time_conv(time).strftime("%p")
  end

  def cu_flash(params)
    "#{params[:model]} " << (params[:val] ?  cu_success(params) : cu_fail(params))
  end

  def d_flash(name)
    "#{name} successfully destroyed"
  end

  private

  def time_conv(time)
    Time.strptime(time, "%I:%M:%S %P")
  end

  def cu_success(params)
    "#{params[:action]} successfully!"
  end

  def cu_fail(params)
    "not #{params[:action]}: #{errors(params[:record])}"
  end

  def errors(record)
    out = ""
    record.errors.full_messages.each_with_index { |message, i| out << (i > 0 ? "; " : "") << message }
    out
  end
end
