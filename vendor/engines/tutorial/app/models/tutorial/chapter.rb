require 'active_attr'
module Tutorial
  class Chapter
    class_attribute :conditions
    self.conditions = {}
    # TODO use activemodel 4's ActiveModel::Model
    include ActiveAttr::Model
    include ActiveAttr::TypecastedAttributes
    include ActiveAttr::AttributeDefaults

    attribute :id
    attribute :hint
    attribute :title
    attribute :motivation
    attribute :instructions
    attribute :examples

    def self.all(user=nil)
      translations_for_locale.map do |trans|
        new(trans).tap do |chapter|
          chapter.visit(user) if user
        end
      end
    end

    def self.define(id, &condition)
      raise(ArgumentError, "cannot define chapter #{id.inspect} twice") if lookup_condition(id)
      conditions[id] = condition
    end

    def visit(user)
      if condition = self.class.lookup_condition(id)
        @done = !condition[user]
      end
    end

    def done?
      !!@done
    end

  private
    # consider these class methods private

    def self.lookup_condition(id)
      conditions[id]
    end

    # Initialize and return translations
    def self.translations
      raise "i18n has no load_path(s)" if ::I18n.load_path.empty?
      ::I18n.backend.instance_eval do
        init_translations unless initialized?
        translations
      end
    end

    def self.translations_for_locale(locale=I18n.locale)
      translations[locale.to_sym][:tutorial][:chapters]
    end
  end
end
