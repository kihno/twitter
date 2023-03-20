class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet

  def create
    @comment = @tweet.comments.new(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.turbo_stream
      else
        format.html do
          redirect_to tweet_path(@tweet), alert: "Comment could not be created."
        end
      end
    end
  end

  def destroy
    @comment = @tweet.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to tweet_path(@tweet), alert: "Comment could not be deleted."
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end
end
