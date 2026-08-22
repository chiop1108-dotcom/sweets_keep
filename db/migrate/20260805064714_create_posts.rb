class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :product_name,null: false
      t.string :shop_name,null: false
      t.text :description,null: false
      # INDEX 同じ商品名の評価は2度と登録させない
      # DEFAULT 数値の初期値（例: 0: 評価なし、1: ★、2: ★★、3: ★★★、4: ★★★★、5: ★★★★★）
      t.integer :rating,null: false,index: { unique: true },default: 0
      # DEFAULT 数字の初期値（0: 常温、1: 冷暗所、2: 冷蔵、3：冷凍）
      t.integer :starage_temperature, null: false,default: 0

      t.timestamps
    end
  end
end
