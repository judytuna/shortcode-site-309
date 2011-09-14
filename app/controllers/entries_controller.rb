class EntriesController < ApplicationController
  
  def new # page that allows for creation of a new entry!!!
    @entry = Entry.new if signed_in?
    @title = "New entry"
  end

  def create
    @entry  = current_user.entries.build(params[:entry])
    if @entry.save
      flash[:success] = "Entry created!"
      redirect_to current_user
    else
      render 'entries/new'
    end
  end
  
end
