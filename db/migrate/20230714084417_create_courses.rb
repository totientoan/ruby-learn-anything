class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :thumbnail
      t.string :tags
      t.integer :level

      t.timestamps
    end
  end
end
