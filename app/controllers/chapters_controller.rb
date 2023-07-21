class ChaptersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        if params[:id_course]
            chapters = Chapter.where(id_course: params[:id_course])
        else 
            chapters = Chapter.all
        end

        render json: {
            chapters: chapters
        }, status: :ok
    end

    def create
        chapter = Chapter.create!(chapter_params)

        render json: {
            chapter: ChapterSerializer.new(chapter)
        }, status: :created
    end
    
    def update
        chapter = Chapter.find_by(id: params[:id])

        if chapter 
            chapter.update!(chapter_params)
            render json: {
                chapter: ChapterSerializer.new(chapter)
            }, status: :ok
        else 
            render json: { error: 'Invalid course' }, status: :unprocessable_entity
        end
    end

    def show
        chapter = Chapter.find(params[:id])
        
        render json: {
            chapter: ChapterSerializer.new(chapter)
        }, status: :ok
    end

    def destroy
        Chapter.find(params[:id]).destroy
        render json: {}, status: :ok
    end

    private

    def render_not_found_response
        render json: { error: "Course Not Found" }, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def chapter_params
        params.require(:chapter).permit(:name, :description, :id_course)
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
