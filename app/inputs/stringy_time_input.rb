class StringyTimeInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('stringy_time')
  end
end

