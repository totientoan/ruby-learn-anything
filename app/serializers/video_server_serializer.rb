# app/serializers/video_server_serializer.rb
class VideoServerSerializer < ActiveModel::Serializer
    attributes :id, :url, :id_server_provider
end