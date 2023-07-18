class CoursesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        search = params[:search]
        level = params[:level]
        arr_level = level.split(',')

        if search
            courses = Course.where("name LIKE ?", "%" + search + "%").page(params[:page] ? params[:page].to_i : 1)        
        end

        if level
            courses = Course.where(level: arr_level).page(params[:page] ? params[:page].to_i : 1)        
        end

        if !search && !level
            courses = Course.page(params[:page] ? params[:page].to_i : 1) 
        end
 
        render json: {courses:courses, meta:pagination_meta(courses) }
    end

    def create
        course = Course.create!(course_params)
        # UploadVideoJob.perform_later(course.id)

        render json: course, status: :created
    end
    
    def update
        course = Course.find_by(id: params[:id])

        if course 
            course.update!(course_params)
            render json: {
                course: {
                    "id" => course.id,
                    "name" => course.name,
                    "description" => course.description,
                    "thumbnail" => course.thumbnail,
                    "tags" => course.tags,
                    "level" => course.level,
                },
                
            }, status: :ok
        else 
            render json: { error: 'Invalid course' }, status: :unprocessable_entity
        end
    end

    def show
        course = Course.find(params[:id])
        
        render json: {
            course: {
                "id" => course.id,
                "name" => course.name,
                "description" => course.description,
                "thumbnail" => course.thumbnail,
                "tags" => course.tags,
                "level" => course.level,
            },
            
        }, status: :ok
    end

    def destroy
        Course.find(params[:id]).destroy
        head :no_content
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
