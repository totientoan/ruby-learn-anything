# app/serializers/video_serializer.rb
class VideoSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :duration, :id_chapter, :id_user
    belongs_to :video_server, serializer: VideoServerSerializer
  end