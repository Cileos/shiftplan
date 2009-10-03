module WorkplacesHelper
  def requirement_list(workplace, options={})
    options.symbolize_keys!
    options[:truncate] = true unless options.key?(:truncate)
    options[:length] ||= 20

    text = workplace.workplace_requirements.map { |wr| "#{wr.quantity}x #{wr.qualification.name}" }.join(', ')
    text = truncate(text, :length => options[:length]) if options[:truncate]
    text
  end
end