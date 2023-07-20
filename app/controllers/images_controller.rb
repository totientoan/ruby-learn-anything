require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

class ImagesController < ApplicationController
  include GoogleDriveService

  def upload
    begin
      FileUtils.rm_rf(Dir.glob('public/images/*'))

      if params[:file].present? && ['image/png', 'image/jpeg', 'image/jpg'].include?(params[:file].content_type) && params[:file].size < 3.megabytes
        # Thay đổi đường dẫn thư mục tùy ý ở đây, ví dụ: 'public/uploads'
        upload_path = Rails.root.join('public/images', params[:file].original_filename)

        # Lưu file vào thư mục được chỉ định
        File.open(upload_path, 'wb') do |file|
          file.write(params[:file].read)
        end
        # save to local successfully

        file = params[:file].original_filename
        drive_service = GoogleDriveService.authorize
        image_file_path = Rails.root.join('public', 'images', file)

        image_file = File.open(image_file_path)
        file_metadata = {
          name: File.basename(image_file),
          parents: [ENV['image_folder_id']]
        }
        uploaded_file = drive_service.create_file(file_metadata, upload_source: image_file, content_type: 'image/*')
        web_view_url = "https://drive.google.com/file/d/#{uploaded_file.id}/view"
        render json: { message: 'Video uploaded successfully!', file_id: uploaded_file.id, url: web_view_url }
      else
        render json: { error: 'File type not allowed or file not found.' }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: "Error retrieving files: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def list_folders
    drive_service = GoogleDriveService.authorize

    # Retrieve the list of files in the root of Google Drive (non-folders)
    id_folder = ENV['image_folder_id']
    response = drive_service.list_files(q: "'#{id_folder}' in parents and mimeType!='application/vnd.google-apps.folder' and trashed=false",
                                        fields: 'files(id, name, web_view_link)',
                                        spaces: 'drive')

    files = response.files

    render json: { files: files }
  rescue StandardError => e
    render json: { error: "Error retrieving files: #{e.message}" }, status: :unprocessable_entity
  end

end