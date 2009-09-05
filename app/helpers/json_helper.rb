module JsonHelper
  def object
    instance_variable_get(:"@#{@object_name}")
  end

  def json_errors_for(object)
    return unless object.errors.present?

    returning('') do |json|
      json << "'#{object.class.to_s.underscore}': {"
      json << object.errors.collect do |field, errors|
        "'#{escape_javascript(field)}': ['#{Array(errors).map { |error| escape_javascript(error) }.join("',\n'")}']"
      end.join(",\n")
      json << "}"
    end
  end

  def map_json_fields(object, fields)
    fields.split(',').map(&:strip).select { |field| object.respond_to?(field.to_sym) }.collect do |field|
      "'#{escape_javascript(field)}': '#{escape_javascript(object.send(field.to_sym).to_s)}'"
    end
  end
end