class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = Current.user.comments.new(comment_params)
    comment.post_id = post.id
    if comment.save
      redirect_to post_path(post), notice: "コメントを投稿しました"
    else
      redirect_to post_path(post), alert: "コメントの投稿に失敗しました"
    end
  end

  def destroy
    # 全コメントの中から該当するコメントを取得 管理者でもコメントを取得できる
    comment = Comment.find(params[:id])

    # 「コメントした本人」または「管理者」であるかチェック
    if comment.user == Current.user || Current.user&.role_admin?
      comment.destroy
      flash[:notice] = "コメントを削除しました"
    else
      flash[:alert] = "削除する権限がありません"
    end

    # 元の投稿詳細画面へリダイレクト
    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end