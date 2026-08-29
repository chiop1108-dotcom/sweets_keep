class ChangeStarageTemperatureOnPosts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :posts, :starage_temperature, true
    change_column_default :posts, :starage_temperature, from: 0, to: nil
  end
end
