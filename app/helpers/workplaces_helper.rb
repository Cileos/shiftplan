module WorkplacesHelper
  def requirement_list(workplace, options={})
    options.symbolize_keys!
    options[:truncate] = true unless options.key?(:truncate)
    options[:length] ||= 20

    text = workplace.workplace_requirements.map do |requirement| 
      "#{requirement.quantity}x #{requirement.qualification.name}" if requirement.qualification
    end.compact.join(', ')
    text = truncate(text, :length => options[:length]) if options[:truncate]
    text
  end
end
