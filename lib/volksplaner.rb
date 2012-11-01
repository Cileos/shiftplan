module Volksplaner
  autoload :Currents, 'volksplaner/currents'
  autoload :Responder, 'volksplaner/responder'

  def self.staging?
    @staging = `hostname` =~ /FTD001/
  end

  def self.hostname
    @hostname ||= staging?? 'staging.clockwork.io' : 'app.clockwork.io'
  end
end

