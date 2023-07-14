class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.integer :id_video
      t.integer :id_user
      t.text :content

      t.timestamps
    end
  end
end
