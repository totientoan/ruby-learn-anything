# app/serializers/chapter_serializer.rb
class ChapterSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :id_course
    has_many :videos, serializer: VideoSerializer
end
