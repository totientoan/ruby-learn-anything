class Video < ApplicationRecord
    has_many :video_servers, foreign_key: :id_video
end
