# app/models/video_server.rb
class VideoServer < ApplicationRecord
    belongs_to :video, foreign_key: :id_video
end