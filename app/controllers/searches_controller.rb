class SearchesController < ApplicationController
  # 未ログインでも閲覧可能な画面
  allow_unauthenticated_access only: [:search]
  # 未ログイン許可アクションでも、ログイン中なら Current.user を復元する
  before_action :resume_session, only: [:search]

  def search
    # ベース：新しい投稿順 ＋ 画像やコメントの重さを防ぐ事前読み込み
    # comments,user,tagsを事前読み込み
    @posts = Post.includes(:comments, :user, :tags).order(created_at: :desc)

    # タグ検索　(tag_idが送られてきた場合)
    if params[:tag_id].present?
      @tag = Tag.find_by(id: params[:tag_id])
      @posts = @tag ? @tag.posts.includes(:comments, :user, :tags) : Post.none
    end

    # キーワード検索（商品名 OR エリア OR 店名 OR 持ち歩き可能時間 OR 日持ち OR ジャンル OR 紹介文 OR 投稿者名 OR タグ名 OR タグカテゴリー）
    if params[:keyword].present?
      kw = "%#{params[:keyword]}%"
      @posts = @posts.left_outer_joins(:user, post_tags: :tag).where(
        "posts.product_name LIKE ? OR " \
        "posts.area LIKE ? OR " \
        "posts.shop_name LIKE ? OR " \
        "posts.carrying_time LIKE ? OR " \
        "posts.shelf_life LIKE ? OR " \
        "posts.genre LIKE ? OR " \
        "posts.description LIKE ? OR " \
        "users.user_name LIKE ? OR " \
        "tags.name LIKE ? ",
        kw, kw, kw, kw, kw, kw, kw, kw, kw
      ).distinct # タグが複数登録された際、同じ投稿が重複して一覧に表示されるのを防ぐ
    end

    # 保管温度（starage_temperature）での絞り込み
    if params[:starage_temperature].present?
      @posts = @posts.where(starage_temperature: params[:starage_temperature])
    end

    # 価格（price）での絞り込み（例：指定した金額以下）
    if params[:price].present?
      @posts = @posts.where("price <= ?", params[:price])
    end

    # 評価（rating）での絞り込み（例：指定した星の数以上）
    if params[:rating].present?
      @posts = @posts.where("rating >= ?", params[:rating])
    end

    # ジャンル（genre）での絞り込み
    if params[:genre].present?
      @posts = @posts.where(genre: params[:genre])
    end

    # 持ち歩き時間（carrying_time）での絞り込み
    if params[:carrying_time].present?
      if params[:carrying_time] == "free"
        @posts = @posts.where(carrying_time: "free")
      else
        @posts = @posts.where("carrying_time <= ?", params[:carrying_time])
      end
    end

    # 賞味期限・日持ち（shelf_life）での絞り込み
    if params[:shelf_life].present?
      @posts = @posts.where("shelf_life >= ?", params[:shelf_life])
    end
  end
end
