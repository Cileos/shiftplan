class RequirementsController < ApplicationController
  before_filter :set_requirement, :only => [:update, :destroy]

  def create
    @requirement = Requirement.new(params[:requirement])

    if @requirement.save
      flash[:notice] = t(:requirement_successfully_created)

      respond_to do |format|
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:requirement_could_not_be_created)

      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def update
    if @requirement.update_attributes(params[:requirement])
      flash[:notice] = t(:requirement_successfully_updated)

      respond_to do |format|
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:requirement_could_not_be_pdated)

      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def destroy
    @requirement.destroy
    flash[:notice] = t(:requirement_successfully_deleted)

    respond_to do |format|
      format.json { render :status => 200 }
    end
  end

  protected

    def set_requirement
      @requirement = Requirement.find(params[:id])
    end
end
