# encoding: utf-8
module Volksplaner
  autoload :Currents, 'volksplaner/currents'
  autoload :ControllerCaching, 'volksplaner/controller_caching'
  autoload :Responder, 'volksplaner/responder'
  autoload :FormButtons, 'volksplaner/form_buttons'
  autoload :FormFields, 'volksplaner/form_fields'
  autoload :PlanRedirector, 'volksplaner/plan_redirector'
  autoload :IconCompiler, 'volksplaner/icon_compiler'
  autoload :Formatter, 'volksplaner/formatter'
  autoload :CaseInsensitiveEmailAttribute, 'volksplaner/case_insensitive_email_attribute'
  autoload :ShortcutAttribute, 'volksplaner/shortcut_attribute'

  HumanNameRegEx = /\A[\p{Letter}][\p{Letter}\d .-]*\z/
  NameRegEx = /\A[\p{Letter}][\p{Letter}\d .§&()-]*\z/


  # staging and CI are on the same machine
  def self.staging?
    @staging ||= `hostname` =~ /plock/ && ENV['USER'] != 'jenkins'
  end

  def self.hostname
    @hostname ||= staging?? 'staging.clockwork.io' : 'app.clockwork.io'
  end

  def self.icons
    @icons ||= YAML.load_file(Rails.root.join('config/icons.yml')).with_indifferent_access
  end

  #################################################
  #  Dependency Injection Hub                     #
  #                                               #
  #  returned handlers should respond to #call    #
  #################################################

  # Generates a random, type/url-friendly string of 20 chars
  def self.token_generator_20
    Devise.method(:friendly_token)
  end

  def self.notification_creator
    lambda do |notifiable|
      NotificationCreator.new(notifiable).delay.create!
    end
  end

  def self.notification_destroyer
    lambda { |notifiable| Notification.delay.destroy_for(notifiable)}
  end

  def self.notification_klass_finder
    Notification::KlassFinder.new.method(:find)
  end

  def self.notification_recipients_finder
    Notification::RecipientsFinder.new.method(:find)
  end
end

VP = Volksplaner
