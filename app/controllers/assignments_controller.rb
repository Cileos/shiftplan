class AssignmentsController < ApplicationController
  before_filter :set_assignment, :only => [:update, :destroy]

  def create
    @assignment = Assignment.new(params[:assignment])

    if @assignment.save
      flash[:notice] = t(:assignment_successfully_created)

      respond_to do |format|
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:assignment_could_not_be_created)

      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def update
    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = t(:assignment_successfully_updated)

      respond_to do |format|
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:assignment_could_not_be_pdated)

      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def destroy
    @assignment.destroy
    flash[:notice] = t(:assignment_successfully_deleted)

    respond_to do |format|
      format.json { render :status => 200 }
    end
  end

  protected

    def set_assignment
      @assignment = Assignment.find(params[:id])
    end
end
