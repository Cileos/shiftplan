class StringyDateInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('stringy_date')
  end

  # iso-date is then used by jQuery.rails_datepick
  def input_html_options
    value = object.public_send(column.name)
    super.merge({ data: { 'iso-date' => value.present? ? value.iso8601 : '' } })
  end
end
