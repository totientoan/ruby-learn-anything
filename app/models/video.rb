class Video < ApplicationRecord
    has_one :video_server, foreign_key: :id_video
end
