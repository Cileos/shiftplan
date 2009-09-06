module WorkplacesHelper
  def requirement_list(workplace, options={})
    options.symbolize_keys!
    options[:truncate] = true unless options.key?(:truncate)

    text = workplace.workplace_requirements.map { |wr| "#{wr.quantity}x #{wr.qualification.name}" }.join(', ')
    text = truncate(text, :length => 20) if options[:truncate]
    text
  end
end