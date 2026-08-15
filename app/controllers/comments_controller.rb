class CommentsController < ApplicationController

  def create
    post_image = PostImage.find(params[:post_image_id])
    comment = Current.user.post_comments.new(post_comment_params)
    comment.post_image_id = post_image.id
    comment.save
    redirect_to post_image_path(post_image)
  end

  def destroy
    
  end

end
