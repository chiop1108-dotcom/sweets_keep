class AddMoreColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name_kana, :string, null: false
    add_column :users, :user_name, :string, null: false
    add_column :users, :telephone_number, :string, null: false

    add_index :users, :user_name, unique: true
    add_index :users, :telephone_number
  end
end
