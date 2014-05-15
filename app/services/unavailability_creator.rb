class UnavailabilityCreator < Struct.new(:controller)
  attr_reader :created_records

  def call(attrs={})
    @created_records = []

    account_ids = attrs.delete(:account_ids) || []
    current_user = controller.current_user

    # will NOT be saved, only used to build the real records
    dummy = klass.new attrs

    if !dummy.employee
      if account_ids.blank?
        # selected "all accounts", which sends no ids
        account_ids = current_user.employees.map(&:account_id)
      end

      account_ids.each do |account_id|
        create_una attrs.merge(employee: current_user.employee_for_account(account_id))
      end
    else
      create_una attrs.merge(employee: dummy.employee)
    end
  end

  def to_s
    %Q~<#{self.class} (#{controller.class})>~
  end

private
  def klass
    Unavailability
  end

  def create_una(attrs={})
    resource = klass.new(attrs)
    resource.valid?
    controller.authorize! :create, resource
    resource.save!
    @created_records << resource
  end
end
