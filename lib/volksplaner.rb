module Volksplaner
  autoload :Currents, 'volksplaner/currents'
  autoload :Responder, 'volksplaner/responder'
  autoload :FormButtons, 'volksplaner/form_buttons'

  def self.staging?
    @staging = `hostname` =~ /FTD001/
  end

  def self.hostname
    @hostname ||= staging?? 'staging.clockwork.io' : 'app.clockwork.io'
  end
end


SimpleForm::FormBuilder.send :include, Volksplaner::FormButtons
