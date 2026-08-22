class AddCarryingTimeToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :carrying_time, :integer
  end
end
