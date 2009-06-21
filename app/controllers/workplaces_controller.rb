class WorkplacesController < ApplicationController
  before_filter :set_workplaces, :only => :index
  before_filter :set_workplace, :only => [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @workplace = Workplace.new
  end

  def create
    @workplace = Workplace.new(params[:workplace])

    if @workplace.save
      flash[:notice] = "Workplace successfully created."
      redirect_to workplaces_url
    else
      flash[:error] = "Workplace could not be created."
      render :action => 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def set_workplaces
    @workplaces = Workplace.all
  end

  def set_workplace
    @workplace = Workplace.find(params[:id])
  end
end