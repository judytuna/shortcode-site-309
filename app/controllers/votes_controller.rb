class VotesController < ApplicationController
  before_filter :authenticate
  
  def create
    @entry = Entry.find(params[:vote][:entry_id])
    current_user.cast_vote!(@entry, params[:weight].to_i)
    respond_to do |format|
      format.html {redirect_to @entry}
      format.js
    end
  end
  
  def destroy
    @entry = Vote.find(params[:id]).entry
    current_user.unvote!(@entry)
    respond_to do |format|
      format.html {redirect_to @entry}
      format.js
    end
  end
end
