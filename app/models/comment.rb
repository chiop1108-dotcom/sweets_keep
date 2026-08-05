class Comment < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :post

  # バリデーション
  validates :content, presence: true, length: { maximum: 500 } #500文字以内であることを検証

end
