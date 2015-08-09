module CoursesHelper
	def course_params
		params.require(:course).permit(:subject, :course_id, :name)
	end
end
