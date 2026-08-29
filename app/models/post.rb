class Post < ApplicationRecord
  # アソシエーション
  belongs_to :user

   # ActiveStorage 画像を付けたいmodel
  has_one_attached :image

  # アソシエーション
  has_many :post_tags, dependent: :destroy
  # throughを使うアソシエーションは、元となるアソシエーションの下に書くのがRailsのルール
  has_many :tags, through: :post_tags # 多：多の関係を定義
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  # バリデーション
  validates :user_id, presence: true
  validates :product_name, presence: true, length: { maximum: 100 } #100文字以内であることを検証
  validates :shop_name, presence: true, length: { maximum: 100 } #100文字以内であることを検証
  validates :description, presence: true, length: { maximum: 1000 } #1000文字以内であることを検証
  validates :rating, presence: true, inclusion: { in: 1..5 } # 1から5の範囲で評価
  validates :starage_temperature, presence: true
  validates :shelf_life, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :area, presence: true
  # 必須チェック ＋ 0以上の整数のみ許可（マイナスを禁止）
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :carrying_time, presence: true
  # ジャンルの必須チェックと、決められた選択肢のみ許可する設定
  validates :genre, presence: true, inclusion: { in: ["洋菓子", "和菓子", "和洋菓子", "その他"] }

  # 保存温度の enum 定義
  # キー名（英語）と DBに保存する数値（0, 1, 2...）をペアにする
  enum :starage_temperature, {
    room_temperature: 0, # 常温
    cool_dark_place: 1,  # 冷暗所
    refrigerated: 2,     # 冷蔵
    frozen: 3            # 冷凍
  }, prefix: true

  def favorited_by?(user)
    # user が nil（未ログイン）の場合は、エラーを出さずに false（いいねしていない）を返す
    return false if user.nil?

    favorites.exists?(user_id: user.id)
  end

  def tag_names
    tags.pluck(:name).join(', ')
  end

  # フォームから渡されたタグ文字列を受け取り、保存・紐付けを行う処理
  def save_tags(tag_list_string)
   return if tag_list_string.blank?

    # カンマやスペースで区切って文字の配列にする（例: ["いちご", "ケーキ"]）
    tag_names = tag_list_string.to_s.tr('，、 ', ',,, ').split(',').map(&:strip).uniq.reject(&:empty?)

    # タグを探す、無ければ category に "未分類" をセットして新しく作る
    new_tags = tag_names.map do |name|
      Tag.find_or_create_by(name: name)
    end

    # PostTag（中間テーブル）を紐付け 新しいタグ一覧で更新（古くなったアソシエーションは自動削除される）
    self.tags = new_tags
  end

end
