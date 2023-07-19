class UploadVideosController < ApplicationController
    before_action :authorize_request
    def store
    end

    def upload
        drive_service = GoogleDriveService.authorize

        video_file_path = Rails.root.join('storage', 'videos', 'video1.mp4')
        video_file = File.open(video_file_path)
        file_metadata = {
            name: File.basename(video_file),
            parents: ['1EAJGOF0ZRV8acayIX_xYtTC0iWyoGaOc']
        }
        uploaded_file = drive_service.create_file(file_metadata, upload_source: video_file, content_type: 'video/*')


        render json: { message: 'Video uploaded successfully!', file_id: uploaded_file.id }
    rescue StandardError => e
        render json: { error: "Error uploading video: #{e.message}" }, status: :unprocessable_entity
    end

    def upload_file_local
        if params[:file].present?
          upload_path = Rails.root.join('storage/videos', params[:file].original_filename)

          File.open(upload_path, 'wb') do |file|
            file.write(params[:file].read)
          end
    
          render json: { message: 'File uploaded successfully.' }
        else
          render json: { error: 'File not found.' }, status: :unprocessable_entity
        end
    end

end
