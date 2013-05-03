class OrganizationDecorator < TabularizedRecordDecorator

  def respond
    super
    update_organization_menu_items if errors.empty?
  end

  private

    def selector_for(name, record=nil, extra=nil)
      case name
      when :organization_menu
        "ul.organization-dropdown"
      else
        super
      end
    end

    def update_organization_menu_items
      select(:organization_menu).refresh_html organization_menu_items
    end

    def organization_menu_items
      h.render('organizations/menu_items',
               organizations: h.current_account.organizations)
    end
end
