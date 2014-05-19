class LocalesController < ApplicationController
  respond_to :json
  skip_before_filter :authenticate_user!
  skip_authorization_check

  def show
    @translations = build_translation(params[:id])

    render json: @translations
  end


private

  def build_translation(name)
    translations[name.to_sym]
  end

  # Initialize and return translations
  def translations
    raise "i18n has no load_path(s)" if ::I18n.load_path.empty?
    ::I18n.backend.instance_eval do
      init_translations unless initialized?
      translations
    end
  end

end

