# make the RJS helper proxy `page` available in Draper's Decorators

# in your .js.rjs templates, you can call #decorate on the magic page object
# and then use RJS-powered methods from within your Decorator
#
#    page.decorate User.first do |user|
#      user.blink
#    end
#
#    class UserDecorator < ApplicationDecorator
#      def blink
#        page[ "user_#{model.id}" ].animate 'blink'
#      end
#    end

module Draper::RJS
  def self.included(base)
    base.class_eval do
      alias_method_chain :initialize, :rjs
      attr_accessor :page
      attr_accessor :options
    end
  end

  def initialize_with_rjs(input, options={})
    self.page    = options[:page]
    self.options = options # for re-decoration
    # Draper asserts valid keys in options
    initialize_without_rjs(input, options.except(:page))
  end

  def page?
    !!page
  end
end

Draper::Decorator.class_eval do
  include Draper::RJS
end

module VersatileRJS::Draper
  def decorate(resource, options={})
    yield resource.decorate(options.merge(:page => self))
  end
end

VersatileRJS::Page.class_eval do
  include VersatileRJS::Draper
end

