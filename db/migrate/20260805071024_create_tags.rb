class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      # INDEX 同じタグ名は2度と登録させない
      t.string :name,null: false,index: { unique: true }
      t.timestamps
    end
  end
end
