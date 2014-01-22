module Volksplaner
  module Undo::ControllerHelpers
    UndoSessionKey = 'undo'

    def self.included(controller)
      controller.class_eval do
        helper_method :has_undo?
        helper_method :last_undo
      end
    end

    def has_undo?
      last_undo.present?
    end

    def store_undo(tracts)
      session[UndoSessionKey] = Undo::Step.build tracts.merge(default_undo_options)
    end

    def last_undo
      @last_undo ||= load_undo
    end

    def clear_undo
      @last_undo = nil
      session.delete(UndoSessionKey)
    end

    private

    def load_undo
      session[UndoSessionKey]
    end

    def default_undo_options
      {
        flash: flash.to_hash,
        flash_message: generate_flash_message(:undo)
      }
    end
  end
end
