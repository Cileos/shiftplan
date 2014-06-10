require 'spec_helper'

describe Tutorial::ChapterSerializer do

  context 'for chapter' do
    let(:chapter) { Tutorial::Chapter.new } # doubles don't have #read_attribute_for_serialization

    matcher :serialize_attribute do |attr, val|
      match do |serializer|
        @json = serializer.to_json(root: false)
        parsed = JSON.parse(@json)

        @actual = parsed[attr]
        @actual == val
      end
      failure_message_for_should do |serializer|
        "expected to serialize #{attr} to #{val.inspect}, but did to #{@actual.inspect}\nJSON: #{@json}"
      end
    end

    subject { described_class.new(chapter) }

    it 'serializes id' do
      chapter.id = 'one'
      should serialize_attribute('id', 'one')
    end

    it 'serializes done? to isDone' do
      chapter.stub done?: true
      should serialize_attribute('isDone', true)
    end

  end

end
