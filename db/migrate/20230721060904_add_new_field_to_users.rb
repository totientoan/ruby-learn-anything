class AddNewFieldToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :rule, :string, default: 'user'
  end
end
