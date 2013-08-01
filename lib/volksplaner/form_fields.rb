module Volksplaner
  module FormFields

    # password field that should not be prefilled by browser or its password manager
    # http://stackoverflow.com/questions/8163467/disable-firefox-password-manager-for-some-password-input-fields
    def uncompleted_password(field, opts={})
      @template.concat password_field(field, class: 'anti-autocomplete', style: 'display: none')
      input(field, opts)
    end
  end
end
