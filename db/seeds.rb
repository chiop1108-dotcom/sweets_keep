# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "seedの実行を開始"

# 管理者ユーザー(管理者花子)の作成
hanako = User.find_or_create_by!(email_address: "hanako@example.com", user_name: "Hanako") do |user|
  user.name = "管理者花子"
  user.name_kana = "カンリシャハナコ"
  user.user_name = "Hanako"
  user.password = ENV["ADMIN_HANAKO_PASSWORD"] # ← 環境変数
  user.telephone_number = "04012356789"
  user.role = "admin"
  user.is_deleted = false
  user.profile_text = "管理者アカウントです。"
end

# 管理者ユーザー（管理者律子）の作成
ritsuko = User.find_or_create_by!(email_address: "ritsuko@example.com", user_name: "ritsuko") do |user|
  user.name = "管理者律子"
  user.name_kana = "カンリシャリツコ"
  user.user_name = "ritsuko"
  user.password = ENV["ADMIN_RITSUKO_PASSWORD"] # ← 環境変数を参照
  user.telephone_number = "05012346789"
  user.role = "admin"
  user.is_deleted = false
  user.profile_text = "管理者アカウントです。"
end

# ユーザー情報（山田太郎）の作成
taro = User.find_or_create_by!(email_address: "taro@example.com", user_name: "Taro") do |user|
  user.name = "山田太郎"
  user.name_kana = "ヤマダタロウ"
  user.user_name = "Taro"
  user.password = "password" # 任意のテスト用パスワード
  user.telephone_number = "01023456789"
  user.role = "general"
  user.is_deleted = false
  user.profile_text = nil
end

# ユーザー情報（鈴木次郎）の作成
jiro = User.find_or_create_by!(email_address: "jiro@example.com", user_name: "jiro") do |user|
  user.name = "鈴木次郎"
  user.name_kana = "スズキジロウ"
  user.user_name = "jiro"
  user.password = "password" # 任意のテスト用パスワード
  user.telephone_number = "02013456789"
  user.role = "general"
  user.is_deleted = false
  user.profile_text = nil
end

# 投稿情報の作成
Post.find_or_create_by!(product_name: "どらやき", shop_name: "和菓子屋どら") do |post|
  post.user = jiro
  post.description = "はちみつの香りが優しいです。餡もゆるくて暖かい味です。"
  post.rating = 5
  post.starage_temperature = 0
  post.carrying_time = "常温OK"
  post.shelf_life = 3
  post.area = "東京都中央区"
  post.price = 350
  post.genre = "和菓子"

  post.image = ActiveStorage::Blob.create_and_upload!(
    io: File.open("#{Rails.root}/db/fixtures/dorayaki1.jpg"),
    filename: "dorayaki1.jpg"
  )
end

# 投稿情報の作成
Post.find_or_create_by!(product_name: "X'mas ショートケーキ", shop_name: "YOUGASHI") do |post|
  post.user = hanako
  post.description = "いちごがたっぷりで甘さ控えめの美味しいケーキです。"
  post.rating = 5
  post.starage_temperature = 2
  post.carrying_time = "2時間以内"
  post.shelf_life = 1
  post.area = "東京都渋谷区"
  post.price = 4000
  post.genre = "洋菓子"

  post.image = ActiveStorage::Blob.create_and_upload!(
    io: File.open("#{Rails.root}/db/fixtures/cake_xmas.jpg"),
    filename: "cake_xmas.jpg"
  )
end

# 投稿情報の作成
Post.find_or_create_by!(product_name: "マドレーヌ ショコラ", shop_name: "YOUGASHI") do |post|
  post.user = hanako
  post.description = "チョコチップが入っていて、チョコを堪能できます。"
  post.rating = 4
  post.starage_temperature = 0
  post.carrying_time = "常温OK"
  post.shelf_life = 7
  post.area = "東京都渋谷区"
  post.price = 450
  post.genre = "洋菓子"

  post.image = ActiveStorage::Blob.create_and_upload!(
    io: File.open("#{Rails.root}/db/fixtures/madeleine_chocolat.jpg"),
    filename: "madeleine_chocolat.jpg"
  )
end

# 投稿情報の作成
Post.find_or_create_by!(product_name: "どら焼き", shop_name: "WAGASHI") do |post|
  post.user = taro
  post.description = "スタンダードなどら焼き。どこか懐かしさを感じます。"
  post.rating = 5
  post.starage_temperature = 0
  post.carrying_time = "常温OK"
  post.shelf_life = 3
  post.area = "京都府京都市左京区"
  post.price = 350
  post.genre = "和菓子"

  post.image = ActiveStorage::Blob.create_and_upload!(
    io: File.open("#{Rails.root}/db/fixtures/dorayaki2.jpg"),
    filename: "dorayaki2.jpg"
  )
end

# 投稿情報の作成
Post.find_or_create_by!(product_name: "どら焼き マスカルポーネ", shop_name: "和洋kashi") do |post|
  post.user = taro
  post.description = "生クリームほど重くならず、食べやすいです。すぐに食べ終わってしまいました。"
  post.rating = 5
  post.starage_temperature = 2
  post.carrying_time = "1時間以内"
  post.shelf_life = 1
  post.area = "東京都台東区"
  post.price = 480
  post.genre = "和洋菓子"

  post.image = ActiveStorage::Blob.create_and_upload!(
    io: File.open("#{Rails.root}/db/fixtures/dorayaki_mascar.jpg"),
    filename: "dorayaki_mascar.jpg"
  )
end

# 投稿情報の作成
Post.find_or_create_by!(product_name: "どらパンケーキ", shop_name: "Cafe DORA") do |post|
  post.user = ritsuko
  post.description = "新感覚！甘じょっぱくておいしいです。"
  post.rating = 4
  post.starage_temperature = 1
  post.carrying_time = "1時間以内"
  post.shelf_life = 1
  post.area = "東京都渋谷区"
  post.price = 1100
  post.genre = "その他"

  post.image = ActiveStorage::Blob.create_and_upload!(
    io: File.open("#{Rails.root}/db/fixtures/dorayaki_pancake.jpg"),
    filename: "dorayaki_pancake.jpg"
  )
end

# 投稿情報の作成
Post.find_or_create_by!(product_name: "卵サンどらやき", shop_name: "Cafe DORA") do |post|
  post.user = ritsuko
  post.description = "お惣菜感覚のお菓子です。"
  post.rating = 3
  post.starage_temperature = 2
  post.carrying_time = "1時間以内"
  post.shelf_life = 1
  post.area = "東京都渋谷区"
  post.price = 390
  post.genre = "その他"

  post.image = ActiveStorage::Blob.create_and_upload!(
    io: File.open("#{Rails.root}/db/fixtures/dorayaki_egg_sand.jpg"),
    filename: "dorayaki_egg_sand.jpg"
  )
end

# 投稿情報の作成
Post.find_or_create_by!(product_name: "どら焼き 抹茶ティラミス", shop_name: "和洋kashi") do |post|
  post.user = jiro
  post.description = "抹茶好き必見の一品。海外のお客さんも多かったです。"
  post.rating = 5
  post.starage_temperature = 2
  post.carrying_time = "1時間以内"
  post.shelf_life = 1
  post.area = "東京都台東区"
  post.price = 610
  post.genre = "和洋菓子"

  post.image = ActiveStorage::Blob.create_and_upload!(
    io: File.open("#{Rails.root}/db/fixtures/dorayaki_matcha_tiramisu.jpg"),
    filename: "dorayaki_matcha_tiramisu.jpg"
  )
end

puts "seedの実行が完了しました"