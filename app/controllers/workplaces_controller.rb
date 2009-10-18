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
      flash[:notice] = t(:workplace_successfully_created)
      respond_to do |format|
        format.html { redirect_to workplaces_url }
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:workplace_could_not_be_created)
      respond_to do |format|
        format.html { render :action => 'new', :layout => !request.xhr? }
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def edit
    render :layout => !request.xhr?
  end

  def update
    if @workplace.update_attributes(params[:workplace])
      @workplace.workplace_requirements.reject!(&:marked_for_destruction?) # ugh - wtf?!

      flash[:notice] = t(:workplace_successfully_updated)
      respond_to do |format|
        format.html { redirect_to workplaces_url }
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:workplace_could_not_be_updated)
      respond_to do |format|
        format.html { render :action => 'edit', :layout => !request.xhr? }
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def destroy
    @workplace.destroy
    flash[:notice] = t(:workplace_successfully_deleted)
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