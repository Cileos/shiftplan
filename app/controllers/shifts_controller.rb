class ShiftsController < ApplicationController
  before_filter :set_shift, :only => [:update, :destroy]

  def create
    @shift = Shift.new(params[:shift])

    if @shift.save
      flash[:notice] = t(:shift_successfully_created)

      respond_to do |format|
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:shift_could_not_be_created)

      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def update
    if @shift.update_attributes(params[:shift])
      flash[:notice] = t(:shift_successfully_updated)

      respond_to do |format|
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:shift_could_not_be_pdated)

      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def destroy
    @shift.destroy
    flash[:notice] = t(:shift_successfully_deleted)

    respond_to do |format|
      format.json { render :status => 200 }
    end
  end

  protected

    def set_shift
      @shift = Shift.find(params[:id])
    end
end
