class OrganizationDecorator < TabularizedRecordDecorator

  def respond
    super
    update_organization_menu_items if errors.empty?
  end

  private

    def selector_for(name, record=nil, extra=nil)
      case name
      when :records
        "table#account_#{record.account.id} tbody"
      when :record
        "tr#organization_#{record.id}"
      when :organization_menu_items
        "ul.organization-dropdown"
      else
        super
      end
    end

    def update_organization_menu_items
      select(:organization_menu_items).refresh_html organization_menu_items
    end

    def organization_menu_items
      h.render('accounts/organization_menu_items',
        accounts: h.current_user.accounts.default_sorting)
    end

    def update_records
      select(:records, record).refresh_html table_rows
    end

    def table_rows
      h.render('accounts/organization_rows', organizations: records)
    end

    def records
      h.current_user.organizations_for(record.account).default_sorting
    end
end
