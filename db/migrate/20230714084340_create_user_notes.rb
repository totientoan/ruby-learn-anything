class CreateUserNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_notes do |t|
      t.integer :id_video
      t.integer :id_user
      t.text :content
      t.datetime :time

      t.timestamps
    end
  end
end
