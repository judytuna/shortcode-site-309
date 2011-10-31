class ContestsController < ApplicationController
  before_filter :authenticate, :except => :show
  before_filter :admin_user, :except => :show
  
  def show
    @contest = Contest.find(params[:id])
    @title = @contest.title
  end
  
  def index
    @title = "Contests"
    @contests = Contest.paginate(:page => params[:page])
  end
  
  def new # page that allows for creation of a new contest!!!
    @contest = Contest.new if signed_in?
    @title = "New Contest"
  end
  
  def create
    @contest = Contest.new(params[:contest])
    if @contest.save
      flash[:success] = "Contest created."
      redirect_to @contest
    else
      render 'contests/new'
    end
  end
  
  def edit
    @contest = Contest.find(params[:id])
    @title = "Edit Contest"
  end
  
  def update
    @contest = Contest.find(params[:id])
    if @contest.update_attributes(params[:contest])
      flash[:success] = "Contest updated."
      redirect_to @contest
    else
      render 'contests/edit'
    end
  end
  
  def destroy
    Contest.find(params[:id]).destroy
    flash[:success] = "Contest deleted."
    redirect_to contests_path
  end
  
  def admin_user
    current_user.admin?
  end
end

