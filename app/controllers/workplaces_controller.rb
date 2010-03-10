class WorkplacesController < ApplicationController
  before_filter :set_workplaces, :only => :index
  before_filter :set_workplace, :only => [:show, :edit, :update, :destroy]

  def index
    render :layout => !request.xhr?
  end

  def show
  end

  def new
    @workplace = current_account.workplaces.build
    render :layout => !request.xhr?
  end

  def create
    @workplace = current_account.workplaces.build(params[:workplace])

    if @workplace.save
      flash[:notice] = t(:workplace_successfully_created)
      respond_to do |format|
        # htmlunit does not seem to send any accept header set through xhr objects, 2.7. should fix this
        # http://sourceforge.net/tracker/?func=detail&aid=2862553&group_id=47038&atid=448266
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:workplace_could_not_be_created)
      respond_to do |format|
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
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:workplace_could_not_be_updated)
      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def destroy
    @workplace.destroy
    flash[:notice] = t(:workplace_successfully_deleted)

    respond_to do |format|
      format.json { render :status => 200 }
    end
  end

  private
  def set_workplaces
    @workplaces = current_account.workplaces
  end

  def set_workplace
    @workplace = current_account.workplaces.find(params[:id])
  end
end
