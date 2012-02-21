RSpec::Matchers.define :parse_successfully do
  match do |string|
    quickie = Quickie.parse(string)
    quickie != nil
  end
end

RSpec::Matchers.define :fill_in do |attr, val|
  def target
    @target ||= OpenStruct.new
  end

  match do |string|
    if quickie = Quickie.parse(string)
      quickie.fill( target )
      target.send(attr) == val
    else
      false # not event parsable
    end
  end

  failure_message_for_should do |actual|
    "excpected that it fills in #{attr} with #{val}, but was #{target.send(attr)}"
  end
end

RSpec::Matchers.define :serialize_to do |serialized|
  def parse_and_serialize(string)
    Quickie.parse(string).to_s
  end
  match do |source|
    parse_and_serialize(source) == serialized
  end

  failure_message_for_should do |actual|
    "expected #{actual.inspect} to re-serialize to #{serialized.inspect}, but did to #{parse_and_serialize(actual).inspect}"
  end
end

