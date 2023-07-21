class Chapter < ApplicationRecord
    has_many :videos, foreign_key: :id_chapter
end
