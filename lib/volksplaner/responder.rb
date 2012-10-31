module Volksplaner
  # Rails/i_h will render a 204 (no content) after successful PUT and skip setting flash messages.
  # Instead we will render 200 with JSON representation of the resource and full headers to evaluate these in Ember.
  module JsonResponder
    protected

    # simply render the resource even on POST instead of redirecting for ajax
    def api_behavior(error)
      if post?
        display resource, :status => :created
      # render resource instead of 204 no content
      elsif put?
        display resource, :status => :ok
      else
        super
      end
    end
  end
  class Responder < InheritedResources::Responder
    include Volksplaner::JsonResponder
  end
end

