# app/serializers/course_serializer.rb
class CourseSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :thumbnail, :tags, :level
    has_many :chapters, serializer: ChapterSerializer
end