module UserHelper
  def locales_for_select
    I18n.available_locales.map do |locale|
      name = I18n.with_locale locale do
        I18n.translate('meta.name')
      end
      [name, locale]
    end
  end
end
