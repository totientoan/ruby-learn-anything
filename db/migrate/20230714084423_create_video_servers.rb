class CreateVideoServers < ActiveRecord::Migration[7.0]
  def change
    create_table :video_servers do |t|
      t.integer :id_video
      t.integer :id_server_provider
      t.string :url

      t.timestamps
    end
  end
end
