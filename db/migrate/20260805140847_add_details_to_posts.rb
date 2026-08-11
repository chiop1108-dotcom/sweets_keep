class AddDetailsToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :shelf_life, :string
    add_column :posts, :area, :string
    add_column :posts, :price, :integer
  end
end