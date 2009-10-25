class QualificationsController < ApplicationController
  before_filter :set_qualifications, :only => :index
  before_filter :set_qualification, :only => [:show, :edit, :update, :destroy]

  def index
    render :layout => !request.xhr?
  end

  def show
  end

  def new
    @qualification = current_account.qualification.build
    render :layout => !request.xhr?
  end

  def create
    @qualification = current_account.qualifications.build(params[:qualification])

    if @qualification.save
      flash[:notice] = t(:qualification_successfully_created)
      respond_to do |format|
        # htmlunit does not seem to send any accept header set through xhr objects, 2.7. should fix this
        # http://sourceforge.net/tracker/?func=detail&aid=2862553&group_id=47038&atid=448266
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:qualification_could_not_be_created)
      respond_to do |format|
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
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:qualification_could_not_be_updated)
      respond_to do |format|
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
    @qualifications = current_account.qualifications
  end

  def set_qualification
    @qualification = current_account.qualifications.find(params[:id])
  end
end
