class ShiftsController < ApplicationController
  before_filter :set_plan
  before_filter :parse_times, :only => [:create, :update]
  before_filter :set_shift

  def create
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
    respond_to do |format|
      format.json { render :status => :ok }
    end
  end

  protected

    def set_plan
      @plan = Plan.find(params[:plan_id])
    end

    def set_shift
      @shift = params[:id] ? @plan.shifts.find(params[:id]) : @plan.shifts.build(params[:shift])
    end

    def parse_times
      day          = Date.strptime(params[:shift].delete(:day), '%Y%m%d')
      start        = @plan.start_time_in_minutes + params[:shift].delete(:start).to_i
      duration     = params[:shift].delete(:duration).to_i

      params[:shift][:start] = day + start.minutes
      params[:shift][:end]   = params[:shift][:start] + duration.minutes
    end
end
