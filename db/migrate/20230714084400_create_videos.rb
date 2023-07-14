class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :name
      t.text :description
      t.integer :duration
      t.integer :id_chapter
      t.integer :id_user

      t.timestamps
    end
  end
end
