class CoursesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        search = params[:search]
        level = params[:level]

        if search
            courses = Course.where("name LIKE ?", "%" + search + "%").page(params[:page] ? params[:page].to_i : 1)        
        end

        if level
            courses = Course.where(level: level.split(',')).page(params[:page] ? params[:page].to_i : 1)
        end

        if !search && !level
            courses = Course.page(params[:page] ? params[:page].to_i : 1) 
        end
 
        render json: {courses:courses, meta:pagination_meta(courses) }
    end

    def create
        course = Course.create!(course_params)
        # UploadVideoJob.perform_later(course.id)

        render json: {
            course: CourseSerializer.new(course)
        }, status: :created
    end
    
    def update
        course = Course.find_by(id: params[:id])

        if course 
            course.update!(course_params)
            render json: {
                course: CourseSerializer.new(course)
            }, status: :ok
        else 
            render json: { error: 'Invalid course' }, status: :unprocessable_entity
        end
    end

    def show
        course = Course.includes(chapters: { videos: :video_servers }).find(params[:id])

        render json: course, include: ['chapters', 'chapters.videos', 'chapters.videos.video_servers'], serializer: CourseSerializer
    end

    def destroy
        Course.find(params[:id]).destroy
        render json: {}, status: :ok
    end

    private

    def render_not_found_response
        render json: { error: "Course Not Found" }, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def course_params
        params.require(:course).permit(:name, :description, :thumbnail, :tags, :level)
    end

    def pagination_meta(object) {        
        current_page: object.current_page,        
        next_page: object.next_page,        
        prev_page: object.prev_page,        
        total_pages: object.total_pages,        
        total_count: object.total_count
    }    
    end
end
