class Chapter < ApplicationRecord
    has_many :videos, foreign_key: :id_chapter
    paginates_per 50
    validates :name, :description, :id_course, presence: true
    validates :name, uniqueness: {message: 'An account associated with %{value} already exists'}
    validates :name, length: {in: 5..200}, on: :create
    validates :description, length: {in: 5..1000}
    validates :id_course, numericality: { only_integer: true }
end
