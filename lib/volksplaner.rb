module Volksplaner
  autoload :Currents, 'volksplaner/currents'
  autoload :Responder, 'volksplaner/responder'
  autoload :FormButtons, 'volksplaner/form_buttons'
  autoload :PlanRedirector, 'volksplaner/plan_redirector'

  def self.staging?
    @staging = `hostname` =~ /plock/
  end

  def self.hostname
    @hostname ||= staging?? 'staging.clockwork.io' : 'app.clockwork.io'
  end
end

VP = Volksplaner
