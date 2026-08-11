class AddGenreToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :genre, :string, null: false, default: "その他"
  end
end
