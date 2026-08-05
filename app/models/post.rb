class Post < ApplicationRecord
  # アソシエーション
  belongs_to :user

  # アソシエーション
  has_many :tags, through: :post_tags # 多：多の関係を定義
  has_many :post_tags, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # バリデーション
  validates :product_name, presence: true, length: { maximum: 100 } #100文字以内であることを検証
  validates :shop_name, presence: true, length: { maximum: 100 } #100文字以内であることを検証
  validates :description, presence: true, length: { maximum: 1000 } #1000文字以内であることを検証
  varidates :rating, presence: true, inclusion: { in: 1..5 } # 1から5の範囲で評価

  # ActiveStorage 画像を付けたいmodel
  class List < ApplicationRecord
    has_one_attached :image
  end

end
