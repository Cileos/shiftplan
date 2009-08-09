class AllocationsController < ApplicationController
  before_filter :set_date, :only => :index
  before_filter :set_allocations, :only => :index
  before_filter :set_allocation, :only => [:show, :edit, :destroy]
  before_filter :set_workplaces, :only => :index
  before_filter :set_requirements, :only => :index

  def create
    @allocation = Allocation.new(params[:allocation])

    if @allocation.save
      flash[:notice] = 'Allocation was successfully created.'
      redirect_to(@allocation)
    else
      render :action => "new"
    end
  end

  def update
    if @allocation.update_attributes(params[:allocation])
      flash[:notice] = 'Allocation was successfully updated.'
      redirect_to(@allocation)
    else
      render :action => "edit"
    end
  end

  def destroy
    @allocation.destroy
    redirect_to(allocations_url)
  end

  protected
    def set_date
      @date = Date.civil(*[params[:year], params[:month], params[:day]].compact.map(&:to_i)) if params[:year]
      @week = params[:week] if params[:week]
    end

    def set_allocations
      @allocations = if @week
        Allocation.for_week(@date.year, @week)
      elsif !params[:day].blank?
        Allocation.for_day(@date.year, @date.month, @date.day)
      elsif !params[:month].blank?
        Allocation.for_month(@date.year, @date.month)
      elsif !params[:year].blank?
        Allocation.for_year(@date.year)
      else
        Allocation.all
      end
    end

    def set_allocation
      @allocation = params[:id] ? Allocation.find(params[:id]) : Allocation.new
    end

    def set_workplaces
      @workplaces = Workplace.all
    end

    def set_requirements
      @requirements_by_slot = Requirement.for_day(@date.year, @date.month, @date.day).group_by(&:time_slot)
    end
end
