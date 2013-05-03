# Our default testing environment is german, with @en features as an exception
Before '@en' do
  @old_default_locale = I18n.default_locale
  I18n.default_locale = :en
end

After '@en' do
  I18n.default_locale = @old_default_locale
  @old_default_locale = nil
end
