class FixPostColumns < ActiveRecord::Migration[8.0]
  def change
    change_column :posts, :carrying_time, :string
    change_column :posts, :shelf_life, :integer
    change_column_null :posts, :carrying_time, false, "1"
    change_column_null :posts, :shelf_life, false, 1
    change_column_null :posts, :area, false, "未設定"
    change_column_null :posts, :price, false, 0
  end
end
