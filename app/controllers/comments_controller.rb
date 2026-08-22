class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = Current.user.comments.new(comment_params)
    comment.post_id = post.id
    comment.save
    redirect_to post_path(post)
  end

  def destroy
    # Current.userのコメントの中から探すことで、本人のコメントしか削除できないようにする
    # params[:id]は「削除したいコメント」のID。コメントを特定して削除（Comment.find）するために使う
    comment = Current.user.comments.find(params[:id])
    
    if comment
      # コメントを削除
      comment.destroy
      flash[:notice] = "コメントを削除しました"
    else
      flash[:alert] = "権限がありません"
    end
    # params[:post_id]は「親である投稿」のID。コメント削除後に「コメントしていた元の投稿詳細画面（post_path）」へ戻る（リダイレクトする）ために使う
    redirect_to post_path(params[:post_id]), notice: "コメントを削除しました"
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end
