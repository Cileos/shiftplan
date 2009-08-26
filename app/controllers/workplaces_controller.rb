class WorkplacesController < ApplicationController
  before_filter :set_workplaces, :only => :index
  before_filter :set_workplace, :only => [:show, :edit, :update, :destroy]

  def index
    render :layout => !request.xhr?
  end

  def show
  end

  def new
    @workplace = Workplace.new
    render :layout => !request.xhr?
  end

  def create
    @workplace = Workplace.new(params[:workplace])

    if @workplace.save
      flash[:notice] = "Workplace successfully created."
      redirect_to workplaces_url
    else
      flash[:error] = "Workplace could not be created."
      render :action => 'new', :layout => !request.xhr?
    end
  end

  def edit
    render :layout => !request.xhr?
  end

  def update
    if @workplace.update_attributes(params[:workplace])
      flash[:notice] = "Workplace successfully updated."
      redirect_to workplaces_url
    else
      flash[:error] = "Workplace could not be updated."
      render :action => 'edit', :layout => !request.xhr?
    end
  end

  def destroy
    @workplace.destroy
    flash[:notice] = "Workplace successfully deleted."
    redirect_to workplaces_url
  end

  private
  def set_workplaces
    @workplaces = Workplace.all
  end

  def set_workplace
    @workplace = Workplace.find(params[:id])
  end
end