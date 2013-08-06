# encoding: utf-8
module Volksplaner
  autoload :Currents, 'volksplaner/currents'
  autoload :Responder, 'volksplaner/responder'
  autoload :FormButtons, 'volksplaner/form_buttons'
  autoload :FormFields, 'volksplaner/form_fields'
  autoload :PlanRedirector, 'volksplaner/plan_redirector'
  autoload :IconCompiler, 'volksplaner/icon_compiler'
  autoload :Formatter, 'volksplaner/formatter'
  autoload :CaseInsensitiveEmailAttribute, 'volksplaner/case_insensitive_email_attribute'

  HumanNameRegEx = /\A[\p{Letter}][\p{Letter}\d .-]*\z/
  NameRegEx = /\A[\p{Letter}][\p{Letter}\d .§&()-]*\z/

  def self.staging?
    @staging ||= `hostname` =~ /plock/
  end

  def self.hostname
    @hostname ||= staging?? 'staging.clockwork.io' : 'app.clockwork.io'
  end

  def self.icons
    @icons ||= YAML.load_file(Rails.root.join('config/icons.yml')).with_indifferent_access
  end
end

VP = Volksplaner
