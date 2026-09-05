class TagsController < ApplicationController
  def search
    # 入力された文字に部分一致するタグ上位5件を取得
    tags = Tag.where("LOWER(name) LIKE LOWER(?)", "%#{params[:q]}%").limit(5).pluck(:name)    render json: tags
  end
end