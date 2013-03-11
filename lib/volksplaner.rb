# encoding: utf-8
module Volksplaner
  autoload :Currents, 'volksplaner/currents'
  autoload :Responder, 'volksplaner/responder'
  autoload :FormButtons, 'volksplaner/form_buttons'

  HumanNameRegEx = /\A[\p{Letter}][\p{Letter}\d .]*\z/

  def self.staging?
    @staging = `hostname` =~ /plock/
  end

  def self.hostname
    @hostname ||= staging?? 'staging.clockwork.io' : 'app.clockwork.io'
  end
end
