class ChangeColumnToBigint < ActiveRecord::Migration[8.0]

  def change
    change_column :comments, :post_id, :bigint
    change_column :comments, :user_id, :bigint
    change_column :favorites, :post_id, :bigint
    change_column :favorites, :user_id, :bigint
    change_column :post_tags, :post_id, :bigint
    change_column :post_tags, :tag_id, :bigint
    change_column :posts, :user_id, :bigint
    change_column :sessions, :user_id, :bigint
  end
end
