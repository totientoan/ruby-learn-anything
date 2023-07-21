class Course < ApplicationRecord
    paginates_per 50

    validates :name, :description, :thumbnail, :tags, :level, presence: true
    validates :name, uniqueness: {message: 'An account associated with %{value} already exists'}
    validates :name, length: {in: 5..20}, on: :create
    validates :description, length: {in: 5..20}

    has_many :chapters, foreign_key: :id_course
end
