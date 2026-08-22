class AddColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :profile_text, :text, null: false
    add_column :users, :role, :integer, default: 0, null: false, comment: "0: user, 1: admin"
    add_column :users, :is_deleted, :boolean, default: false, null: false
  end
end
