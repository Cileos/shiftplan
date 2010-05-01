ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)

require 'rspec'
require 'rspec/autorun'
require 'rspec/rails'

require 'no_peeping_toms'
require 'machinist/active_record'
require 'faker'
require 'sham'
require File.expand_path(File.dirname(__FILE__) + '/blueprints')

ActiveRecord::Observer.disable_observers

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
          object.save(:validate => false)
          duplicate = object.class.new(_attribute_ => object.attributes[_attribute_])
          !duplicate.valid? && duplicate.errors[_attribute_].any?
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

Rspec.configure do |c|
  c.before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    Sham.reset(:before_all)
  end

  c.before(:each) do
    DatabaseCleaner.start
    Sham.reset(:before_each)
  end

  c.after(:each) do
    DatabaseCleaner.clean
  end

  c.mock_with(:rspec)
  c.include(Rspec::Matchers)
end
