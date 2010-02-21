class TagsController < ApplicationController
  before_filter :set_tags, :only => :index
  before_filter :set_tag, :only => [:show, :edit, :update, :destroy]

  def index
    render :layout => !request.xhr?
  end

  def show
  end

  def new
    @tag = current_account.tag.build
    render :layout => !request.xhr?
  end

  def create
    @tag = current_account.tags.build(params[:tag])

    if @tag.save
      flash[:notice] = t(:tag_successfully_created)
      respond_to do |format|
        # htmlunit does not seem to send any accept header set through xhr objects, 2.7. should fix this
        # http://sourceforge.net/tracker/?func=detail&aid=2862553&group_id=47038&atid=448266
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:tag_could_not_be_created)
      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def edit
    render :layout => !request.xhr?
  end

  def update
    if @tag.update_attributes(params[:tag])
      flash[:notice] = t(:tag_successfully_updated)
      respond_to do |format|
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:tag_could_not_be_updated)
      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def destroy
    @tag.destroy
    flash[:notice] = t(:tag_successfully_deleted)

    respond_to do |format|
      format.json { render :status => 200 }
    end
  end

  private

    def set_tags
      @tags = current_account.tags
    end

    def set_tag
      @tag = current_account.tags.find(params[:id])
    end
end
