RSpec::Matchers.define(:have_many) do |association|
  match do |object|
    object.class.reflect_on_all_associations(:has_many).find { |a| a.name == association }
  end
end

RSpec::Matchers.define(:have_one) do |association|
  match do |object|
    object.class.reflect_on_all_associations(:has_one).find { |a| a.name == association }
  end
end

RSpec::Matchers.define(:have_and_belong_to_many) do |association|
  match do |object|
    object.class.reflect_on_all_associations(:has_and_belongs_to_many).find { |a| a.name == association }
  end
end

RSpec::Matchers.define(:belong_to) do |association|
  match do |object|
    object.class.reflect_on_all_associations(:belongs_to).find { |a| a.name == association }
  end
end

RSpec::Matchers.define(:validate_presence_of) do |attribute|
  match do |object|
    object.send(:"#{attribute}=", nil)
    !object.valid? && object.errors[attribute].any?
  end
end

RSpec::Matchers.define(:validate_uniqueness_of) do |attribute|
  match do |object|
    object.save(:validate => false)
    duplicate = object.class.new(attribute => object.attributes[attribute])
    !duplicate.valid? && duplicate.errors[attribute].any?
  end
end

Rspec::Matchers.define(:validate_confirmation_of) do |attribute|
  match do |object|
    object.send(:"#{attribute}_confirmation=", 'asdf')
    !object.valid? && object.errors[attribute].any?
  end
end
