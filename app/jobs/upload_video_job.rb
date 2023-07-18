class UploadVideoJob < ApplicationJob
  queue_as :default

  def perform(courseId)
    
    # courses = Course.where(level: 1)
    # courses.each do |course|
    #   course.update(level: 2)
    # end

    course = Course.find_by(id: courseId)
    course.update(level: 0)


    puts "uploading video in background"
  end
end


# insert this line to controller to dispatch job
# UploadVideoJob.perform_later(arg1, arg2, ...)
