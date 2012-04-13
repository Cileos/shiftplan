class InvitationDecorator < ApplicationDecorator
  include EmployeeBaseDecorator
  decorates :invitation
end