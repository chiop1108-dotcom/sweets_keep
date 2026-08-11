class HomesController < ApplicationController
  allow_unauthenticated_access
  def top
    # 投稿を新着順にして、最新の投稿3つを取得する
    # created_at: :desc(降順)
    @new_posts = Post.order(created_at: :desc).limit(3)
  end

  def about
  end
end
