class Favorite < ApplicationRecord
  #アソシエーション
  belongs_to :user
  belongs_to :post

  # バリデーション
  validates :user_id, presence: true
  validates :post_id, presence: true, uniqueness: { scope: :user_id }  # user_idとpost_idの組み合わせが一意であることを検証
end
