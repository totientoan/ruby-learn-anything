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

      if params[:id_server_provider].present? && params[:id_server_provider].respond_to?(:each)
        url = upload_file_local(user_params[:file])
        data_server_provider = []
        params[:id_server_provider].each do |server_provider|
          data_server_provider.push({
            id_video: video.id,
            id_server_provider: server_provider[1].to_i,
            url: url.to_s
          })
        end
        VideoServer.insert_all(data_server_provider)
      else
      end
    end
    UploadVideoServerJob.perform_later(video.id, url.to_s)

    render json: video, serializer: VideoSerializer
  end

  def update
    video_servers = nil
    url = nil
    video = Video.find(params[:id])
    if video
      ActiveRecord::Base.transaction do
        video.update(
          name: user_params[:name],
          description: user_params[:description],
          duration: user_params[:duration],
          id_chapter: user_params[:id_chapter],
          id_user: user_params[:id_user]
        )
        if params[:id_server_provider].present? && params[:id_server_provider].respond_to?(:each)
          video.video_servers.destroy_all
          video.save
          url = upload_file_local(user_params[:file])
          data_server_provider = []
          params[:id_server_provider].each do |server_provider|
            data_server_provider.push({
              id_video: video.id,
              id_server_provider: server_provider[1].to_i,
              url: url.to_s
            })
          end
          VideoServer.insert_all(data_server_provider)
        else
        end
      end
      UploadVideoServerJob.perform_later(params[:id], url.to_s)
    else
      render json: { error: 'User not found' }, status: :not_found
    end
    video = Video.includes(:video_servers).find(params[:id])

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
