class UnavailabilityCreator < Struct.new(:controller)
  attr_reader :created_records

  def call(attrs={})
    @created_records = []

    account_ids = attrs.delete(:account_ids) || []

    # will NOT be saved, only used to build the real records
    dummy = klass.new attrs

    if !dummy.employee
      if account_ids.blank?
        # selected "all accounts", which sends no ids
        account_ids = current_user.employees.map(&:account_id)
      end

      account_ids.each do |account_id|
        create_una_span attrs.merge(
          employee: current_user.employee_for_account(account_id),
          user: current_user
        )
      end
    else
      create_una_span attrs.merge(
        user: dummy.employee.user
      )
    end

    self
  end

  def to_s
    %Q~<#{self.class} (#{controller.class})>~
  end

private

  def current_user
    controller.current_user
  end

  def klass
    Unavailability
  end

  def create_una_span(attrs)
    dummy = klass.new(attrs)
    if dummy.start_day && dummy.end_day && dummy.starts_at < dummy.ends_at
      d = dummy.starts_at
      while d < dummy.ends_at.beginning_of_day
        create_una_by_day d, dummy.ends_at, attrs
        d = d + 1.day
      end
      create_una_by_day d, dummy.ends_at, attrs
    else
      create_una(attrs) # for all day
    end
  end

  def create_una_by_day(starts_at, ends_at, attrs)
    create_una attrs.merge(
      starts_at: starts_at,
      ends_at:   starts_at.beginning_of_day + ends_at.hour.hours + ends_at.min.minutes,
    )
  end

  def create_una(attrs)
    resource = klass.new(attrs)
    resource.valid?
    controller.authorize! :create, resource
    resource.save!
    @created_records << resource
  end
end
