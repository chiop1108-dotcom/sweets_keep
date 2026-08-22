class Tag < ApplicationRecord

  # アソシエーション
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags # 多：多の関係を定義

  # バリデーション
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 } #50文字以内であることを検証
  
end
