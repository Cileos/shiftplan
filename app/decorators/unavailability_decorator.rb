class UnavailabilityDecorator < RecordDecorator
  include SchedulableDecoratorHelper

  def reason_text
    if reason
      I18n.t("activerecord.values.unavailability.reasons.#{reason}")
    end
  end
end
