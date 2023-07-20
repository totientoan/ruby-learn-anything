class UploadVideosController < ApplicationController
  before_action :authorize_request
  def store
    video = nil
    video_server = nil
    url = nil
    ActiveRecord::Base.transaction do
      video = Video.new({
        name: user_params[:name],
        description: user_params[:description],
        duration: user_params[:duration],
        id_chapter: user_params[:id_chapter],
        id_user: user_params[:id_user]
      })
      video.save!

      url = upload_file_local(user_params[:file])
      video_server = VideoServer.new({
        id_video: video.id,
        id_server_provider: user_params[:id_server_provider],
        url: url
      })
      video_server.save!
    end
    UploadVideoServerJob.perform_later(video_server.id, url.to_s)

    render json: video, serializer: VideoSerializer
  end

  def upload_file_local(param_file)
      if param_file.present?
        upload_path = Rails.root.join('public/videos', param_file.original_filename)

        File.open(upload_path, 'wb') do |file|
          file.write(param_file.read)
        end
  
        upload_path
      else
        render json: { error: 'File not found.' }, status: :unprocessable_entity
      end
  end

  def user_params
    params.permit(:name, :description, :duration, :id_chapter, :id_user, :id_server_provider, :file)
  end
end
