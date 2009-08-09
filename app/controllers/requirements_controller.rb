class RequirementsController < ApplicationController
  before_filter :set_requirements, :only => :index
  before_filter :set_requirement, :only => [:show, :new, :edit, :update, :destroy]

  def create
    @requirement = Requirement.new(params[:requirement])

    if @requirement.save
      flash[:notice] = 'Requirement successfully created.'
      redirect_to requirements_url
    else
      flash[:error] = 'Requirement could not be created.'
      render :action => "new"
    end
  end

  def update
    if @requirement.update_attributes(params[:requirement])
      flash[:notice] = 'Requirement successfully updated.'
      redirect_to requirements_url
    else
      flash[:error] = 'Requirement could not be updated.'
      render :action => "edit"
    end
  end

  def destroy
    @requirement.destroy
    flash[:notice] = 'Requirement successfully deleted.'
    redirect_to requirements_url
  end

  private

    def set_requirements
      @requirements = Requirement.all
    end

    def set_requirement
      @requirement = params[:id] ? Requirement.find(params[:id]) : Requirement.new
    end
end