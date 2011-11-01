class VotesController < ApplicationController
  before_filter :authenticate
  before_filter :check_entry_contest, :only => [:create]
  before_filter :check_time_window
  
  def create
    @entry = Entry.find(params[:vote][:entry_id])
    contest = Contest.current_contest
    vote = current_user.cast_vote!(contest, @entry, params[:weight].to_i)
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
  
  private
  
  def check_time_window
    contest = Contest.current_contest
    return (contest and contest.voting_window?)
  end
  
  def check_entry_contest
    @entry = Entry.find(params[:vote][:entry_id])
    contest = Contest.current_contest
    if contest and contest == @entry.contest
	  return true
	end
	return false
  end
end
