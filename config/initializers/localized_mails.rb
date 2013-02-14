ActionMailer::Base.class_eval do

  def mail_with_locale(headers={}, &block)
    mail_without_locale(headers.merge(template_name: "#{action_name}_#{I18n.locale}", &block))
  end
  alias_method_chain :mail, :locale
end
