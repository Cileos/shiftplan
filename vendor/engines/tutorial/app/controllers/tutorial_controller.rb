class TutorialController < ActionController::Base
  layout 'ember'

  def index
    @chapters ||= collection
  end

  def collection
    translations[I18n.locale.to_sym][:tutorial][:chapters]
  rescue
    []
  end

private

  # Initialize and return translations
  def translations
    raise "i18n has no load_path(s)" if ::I18n.load_path.empty?
    ::I18n.backend.instance_eval do
      init_translations unless initialized?
      translations
    end
  end
end
