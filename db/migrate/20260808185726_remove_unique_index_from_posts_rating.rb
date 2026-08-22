class RemoveUniqueIndexFromPostsRating < ActiveRecord::Migration[8.0]
  def change
    remove_index :posts, :rating
    add_index :posts, :rating
  end
end
