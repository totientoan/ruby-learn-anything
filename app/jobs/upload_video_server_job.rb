class UploadVideoServerJob < ApplicationJob
  queue_as :default
  include GoogleDriveService
  def perform(video_server_id, url)
    # Do something later
    video_server = VideoServer.find(video_server_id)
    url_convert = "https://drive.google.com/file/d/#{upload(url)}/view"
    video_server.update(url: url_convert)
  end

  def upload(video_file_path)
    drive_service = GoogleDriveService.authorize
    file_path = Rails.root.join(video_file_path)
    video_file = File.open(file_path)
    file_metadata = {
        name: File.basename(video_file),
        parents: [ENV['folder_video_id']]
    }
    uploaded_file = drive_service.create_file(file_metadata, upload_source: video_file, content_type: 'video/*')
    if File.exist?(video_file_path)
      File.delete(video_file_path)
    end

    uploaded_file.id
  rescue StandardError => e
    e.message
  end
end
