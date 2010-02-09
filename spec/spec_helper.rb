ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)

require 'rspec'
require 'rspec/autorun'
require 'rspec/rails'

require 'machinist/active_record'
require 'faker'
require 'sham'
require File.expand_path(File.dirname(__FILE__) + '/blueprints')

# if Account.first
#   ActiveRecord::Base.send(:subclasses).each do |model|
#     connection = model.connection
#     if connection.instance_variable_get(:@config)[:adapter] == 'mysql'
#       connection.execute("TRUNCATE #{model.table_name}")
#     else
#       connection.execute("DELETE FROM #{model.table_name}")
#     end
#   end
# end

module Rspec
  module Matchers
    def belong_to(association)
      Matcher.new(:belong_to, association) do |_association_|
        match do |object|
          object.class.reflect_on_all_associations(:belongs_to).find { |a| a.name == _association_ }
        end
      end
    end

    def have_many(association)
      Matcher.new(:has_many, association) do |_association_|
        match do |object|
          object.class.reflect_on_all_associations(:has_many).find { |a| a.name == _association_ }
        end
      end
    end

    def have_one(association)
      Matcher.new(:has_one, association) do |_association_|
        match do |object|
          object.class.reflect_on_all_associations(:has_one).find { |a| a.name == _association_ }
        end
      end
    end

    def have_and_belong_to_many(association)
      Matcher.new(:have_and_belong_to_many, association) do |_association_|
        match do |object|
          object.class.reflect_on_all_associations(:has_and_belongs_to_many).find { |a| a.name == _association_ }
        end
      end
    end

    def validate_presence_of(attribute)
      Matcher.new(:validate_presence_of, attribute) do |_attribute_|
        match do |object|
          object.send("#{_attribute_}=", nil)
          !object.valid? && object.errors[_attribute_].any?
        end
      end
    end

    def validate_uniqueness_of(attribute)
      Matcher.new(:validate_uniqueness_of, attribute) do |_attribute_|
        match do |object|
          object.class.stub!(:find).and_return(true)
          !object.valid? && object.errors[_attribute_].any?
        end
      end
    end

    def validate_confirmation_of(attribute)
      Matcher.new(:validate_confirmation_of, attribute) do |_attribute_|
        match do |object|
          object.send("#{_attribute_}_confirmation=", 'asdf')
          !object.valid? && object.errors[_attribute_].any?
        end
      end
    end
  end
end

Rspec::Core.configure do |c|
  c.before(:all)  { Sham.reset(:before_all)  }
  c.before(:each) { Sham.reset(:before_each) }

  c.mock_with :rspec
  c.include Rspec::Matchers
end
