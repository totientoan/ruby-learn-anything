class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :avatar_url
      t.string :provider
      t.string :email
      t.string :password
      t.string :refresh_token

      t.timestamps
    end
  end
end
