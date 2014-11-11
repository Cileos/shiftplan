class StringyWeekInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('stringy_week')
  end

  # iso-date is then used by jQuery.rails_datepick
  def input_html_options
    value = object && object.public_send(attribute_name)
    super.merge({ data: { 'iso-date' => value.present? ? value.iso8601 : '' } })
  end
end

