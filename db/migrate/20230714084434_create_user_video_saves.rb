class CreateUserVideoSaves < ActiveRecord::Migration[7.0]
  def change
    create_table :user_video_saves do |t|
      t.integer :id_video
      t.integer :id_user

      t.timestamps
    end
  end
end
