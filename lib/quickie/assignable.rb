# Gives the including model a #quickie attribute that is parsed and distributed
# to #start_* and #end_* attributes.
# FIXME For some reason, this has to be included BEFORE TimeRangeComponentsAccessible
module Quickie
  module Assignable

    def self.included(model)
      model.class_eval do
        before_validation :parse_quickie_and_fill_in
        validates_presence_of :quickie
        attr_writer :quickie

      end
    end

    # we have two ways to clean and re-generate the quickie, parsed#to_s or
    # the attributes based self#to_quickie. We use the latter here
    def quickie
      to_quickie
    end

  private

    def parse_quickie_and_fill_in
      if @quickie.present?
        if parsed = Quickie.parse(@quickie)
          @parsed_quickie = parsed
          parsed.fill(self)
        else
          @parsed_quickie = nil
          errors.add :quickie, :invalid
        end
      end
    end

    # A Quickie was given and it is parsable. Depends on #parse_quickie_and_fill_in to be run in advance.
    def quickie_parsable?
      @quickie.present? && @parsed_quickie.present?
    end

  end
end

