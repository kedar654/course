module InstructorsHelper
  def instructor_params
    params.require(:instructor).permit(:first_name, :last_name)
  end
end
