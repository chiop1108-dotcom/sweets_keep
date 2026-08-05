class User < ApplicationRecord
  # パスワード暗号化
  has_secure_password
  has_many :sessions, dependent: :destroy

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :role, presence: true, inclusion: { in: %w[user admin] } # "user" または "admin"しか許可しない

  normalizes :email_address, with: ->(e) { e.strip.downcase }

   # ActiveStorage 画像を付けたいmodel
  class List < ApplicationRecord
    has_one_attached :image
  end
  
end
