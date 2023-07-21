# app/serializers/video_serializer.rb
class VideoSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :duration, :id_chapter, :id_user
    has_many :video_servers, serializer: VideoServerSerializer
end