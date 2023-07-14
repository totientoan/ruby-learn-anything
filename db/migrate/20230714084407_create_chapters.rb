class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.string :name
      t.text :description
      t.integer :id_course

      t.timestamps
    end
  end
end
