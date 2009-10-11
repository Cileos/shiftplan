class QualificationsController < ApplicationController
  before_filter :set_qualifications, :only => :index
  before_filter :set_qualification, :only => [:show, :edit, :update, :destroy]

  def index
    render :layout => !request.xhr?
  end

  def show
  end

  def new
    @qualification = Qualification.new
    render :layout => !request.xhr?
  end

  def create
    @qualification = Qualification.new(params[:qualification])

    if @qualification.save
      flash[:notice] = t(:qualification_successfully_created)
      respond_to do |format|
        format.html { redirect_to qualifications_url }
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:qualification_could_not_be_created)
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
    if @qualification.update_attributes(params[:qualification])
      flash[:notice] = t(:qualification_successfully_updated)
      respond_to do |format|
        format.html { redirect_to qualifications_url }
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:qualification_could_not_be_updated)
      respond_to do |format|
        format.html { render :action => 'edit', :layout => !request.xhr? }
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def destroy
    @qualification.destroy
    flash[:notice] = t(:qualification_successfully_deleted)
    redirect_to qualifications_url
  end

  private
  def set_qualifications
    @qualifications = Qualification.all
  end

  def set_qualification
    @qualification = Qualification.find(params[:id])
  end
end
