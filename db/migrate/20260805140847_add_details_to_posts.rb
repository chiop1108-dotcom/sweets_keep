class AddDetailsToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :shelf_life, :string
    add_column :posts, :area, :string
    add_column :posts, :price, :integer
  end
end

# あとでビューに書く
# <% if post.price.present? %>
#   <%= number_to_currency(post.price, unit: "円", format: "%n%u") %>
# <% else %>
#   価格不明（または未設定）
# <% end %>