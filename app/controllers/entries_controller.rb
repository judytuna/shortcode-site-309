class EntriesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  
  def new # page that allows for creation of a new entry!!!
    @entry = Entry.new if signed_in?
    @title = "New entry"
  end

  def create
    @entry = current_user.entries.build(params[:entry])
    if @entry.save
      flash[:success] = "Entry created."
      redirect_to current_user
    else
      render 'entries/new'
    end
  end
  
  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(params[:entry])
      flash[:success] = "Entry updated."
      redirect_to current_user
    else
      render 'entries/edit'
    end
  end
  
  def edit
    @entry = Entry.find(params[:id])
    @title = "Edit Entry"
  end
  
  def destroy
    Entry.find(params[:id]).destroy
    flash[:success] = "Entry deleted."
    redirect_to current_user
  end
end
