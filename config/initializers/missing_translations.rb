Shiftplan::Application.configure do
  require 'i18n/missing_translations'
  config.app_middleware.use(I18n::MissingTranslations) if Rails.env.development?
end

