class PostTag < ApplicationRecord
  # アソシエーション
  belongs_to :post
  belongs_to :tag

  # バリデーション
  validates :post_id, presence: true
  validates :tag_id, presence: true, uniqueness: { scope: :post_id } # post_idとtag_idの組み合わせが一意であることを検証
end
