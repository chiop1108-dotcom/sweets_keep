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
  enum :role, { general: 0, admin: 1 }, prefix: true

  # デフォルト値の設定（バリデーション実行前に動作させる）
  before_validation :set_default_role, on: :create

  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :user_name, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: roles.keys } # "user" または "admin"しか許可しない
  
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  
  def set_default_role
    self.role ||= :general
  end

  # 画像が存在しない場合はデフォルト画像（no_image.jpg等）を返すメソッド
  def get_profile_image(width, height)
    unless profile_image.attached?
      # assets/images/no_image.jpg などを配置しておく必要があります
      file_path = Rails.root.join('app/assets/images/logo.png')
      profile_image.attach(io: File.open(file_path), filename: 'default-logo.png', content_type: 'image/png')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

end
