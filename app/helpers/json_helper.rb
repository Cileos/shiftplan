module JsonHelper
  def object
    instance_variable_get(:"@#{@object_name}")
  end

  def json_errors_for(object)
    return unless object.errors.present?

    ''.tap do |json|
      json << "'#{object.class.to_s.underscore}': { "
      object.errors.each do |type, errors|
        json << "'#{escape_javascript(type.to_s)}': ["
        json << Array(errors).map { |error| "'#{escape_javascript(error)}'" }.join(",\n")
        json << "],\n"
      end
      json << " }"
    end
  end

  # def map_json_fields(object, fields)
  #   fields.split(',').map(&:strip).select { |field| object.respond_to?(field.to_sym) }.collect do |field|
  #     "'#{escape_javascript(field)}': '#{escape_javascript(object.send(field.to_sym).to_s)}'"
  #   end
  # end
end