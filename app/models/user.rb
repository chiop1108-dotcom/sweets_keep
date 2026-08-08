class User < ApplicationRecord
  # パスワード暗号化
  has_secure_password
  has_many :sessions, dependent: :destroy

   # ActiveStorage 画像を付けたいmodel
  has_one_attached :profile_image

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # DB内の「0」を general（一般ユーザー）、「1」を admin（管理者）として扱う定義
  enum :role, { general: 0, admin: 1 }

  # デフォルト値の設定（バリデーション実行前に動作させる）
  before_validation :set_default_role, on: :create

  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :role, presence: true, inclusion: { in: roles.keys } # "user" または "admin"しか許可しない
  
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  
  def set_default_role
    self.role ||= :general
  end
  
end
