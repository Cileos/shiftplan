module Volksplaner
  autoload :Currents, 'volksplaner/currents'
  autoload :Responder, 'volksplaner/responder'

  def self.staging?
    @staging = `hostname` =~ /FTD001/
  end

  def hostname
    @hostname ||= staging?? 'staging.clockwork.io' : 'clockwork.io'
  end
end

