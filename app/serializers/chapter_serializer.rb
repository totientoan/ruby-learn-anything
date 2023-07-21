# app/serializers/chapter_serializer.rb
class ChapterSerializer < ActiveModel::Serializer
    attributes :id, :name, :description
    has_many :videos, serializer: VideoSerializer
end