class CreateServerProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :server_providers do |t|
      t.string :name

      t.timestamps
    end
  end
end
