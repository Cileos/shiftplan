class StringyDateInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('stringy_date')
  end
end
