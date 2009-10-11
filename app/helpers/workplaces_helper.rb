module WorkplacesHelper
  def requirement_list(workplace, options={})
    options.symbolize_keys!
    options[:truncate] = true unless options.key?(:truncate)
    options[:length] ||= 20

    text = workplace.workplace_requirements.map { |wr| "#{wr.quantity}x #{wr.qualification.name}" }.join(', ')
    text = truncate(text, :length => options[:length]) if options[:truncate]
    text
  end

  def form_values_for(workplace)
    qualifications = Qualification.all.collect { |qualification| "'#{qualification.id}'" if workplace.needs_qualification?(qualification) }.compact.join(', ')
    json = <<-json
      {
        name: '#{escape_javascript(workplace.name)}',
        active: #{workplace.active?},
        default_shift_length: #{workplace.default_shift_length || 0},
        qualifications: [#{qualifications}]
      }
    json
    json.gsub("\n", ' ').strip
  end
end