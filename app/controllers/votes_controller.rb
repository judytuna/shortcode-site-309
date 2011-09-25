class VotesController < ApplicationController
  before_filter :authenticate
  
  def create
    @entry = Entry.find(params[:vote][:entry_id])
    current_user.vote!(@entry)
    redirect_to @entry
  end
  
  def destroy
    @entry = Vote.find(params[:id]).entry
    current_user.unvote!(@entry)
    redirect_to @entry
  end
end
