module Volksplaner
  module Undo::ControllerHelpers
    UndoSessionKey = 'undo'

    def self.included(controller)
      controller.class_eval do
        helper_method :has_undo?
        helper_method :last_undo
        after_action :store_undo, if: ->(c) { request.format.html? && c.has_undo? }
      end
    end

    def has_undo?
      last_undo.present?
    end

    def create_undo(tracts)
      @last_undo = Undo::Step.build( tracts.merge(default_undo_options) )
      store_undo
    end

    def store_undo
      if u = last_undo
        session[UndoSessionKey] = u.to_json
      end
    end

    def last_undo
      @last_undo ||= load_undo_once
    end

    def clear_undo
      @last_undo = nil
      forget_undo
    end

    def forget_undo
      session.delete(UndoSessionKey)
    end

    private

    def load_undo
      Undo::Step.load(session[UndoSessionKey])
    end

    def load_undo_once
      if u = load_undo
        if u.shown?
          clear_undo
          nil
        else
          u
        end
      end
    end

    def default_undo_options
      {
        flash: flash.to_hash,
        flash_message: generate_flash_message(:undo)
      }
    end
  end
end
