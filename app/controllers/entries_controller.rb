
class EntriesController < ApplicationController
  before_filter :authenticate, :except => [:results]
  before_filter :check_editable, :only => [:edit, :update, :destroy]
  # before_filter :admin_user, :only => :voters

  def show
    @entry = Entry.find(params[:id])
    @title = @entry.title
  end
  
  def index
    @title = "All entries"
    @entries = Entry.paginate(:page => params[:page])
  end
  
  def results
    @title = "Results"
    @entries = Entry.paginate(:page => params[:page])
  end

  def new # page that allows for creation of a new entry!!!
    @entry = Entry.new if signed_in?
    @title = "New entry"
  end

  def create
    @entry = current_user.entries.build(params[:entry])
    @entry.contest = Contest.current_contest
    if @entry.save
      flash[:success] = "Entry created. A new render request has been submitted."
      @entry.render_request
      redirect_to current_user
    else
      render 'entries/new'
    end
  end
  
  def update
    @entry = Entry.find(params[:id])
    old_shortcode = @entry.shortcode
    if @entry.update_attributes(params[:entry])
      message = "Entry updated."
      
      if old_shortcode and old_shortcode != @entry.shortcode
        @entry.render_request
    	message += " A new render request has been submitted."
      end

      flash[:success] = message
    
      redirect_to current_user
    else
      render 'entries/edit'
    end
  end
  
  def edit
    @entry = Entry.find(params[:id])
    @title = "Edit Entry"
  end
  
  def renderstatus
    @entry = Entry.find(params[:id])
    @title = "Entry Render Status"
  end

  def destroy
    Entry.find(params[:id]).destroy
    flash[:success] = "Entry deleted."
    redirect_to current_user
  end
  
  def voters
    @title = "Users voting for this entry"
    @entry = Entry.find(params[:id])
    @users = @entry.voters
  end
  
  private
  
  def check_editable
    @entry = Entry.find(params[:id])
    if current_user.admin? or @entry.editable?
      return true
    else
      flash[:error] = "Entry not editable."
      redirect_to current_user
    end
    return false
  end
end

