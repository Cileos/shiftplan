module Quickie
  module MessageNode
    def fill(scheduling)
      STDERR.puts
      STDERR.puts inspect
      STDERR.puts
      STDERR.puts elements.map(&:inspect).join("\n---\n")
      elements.each do |child|
        child.fill(scheduling)
      end
    end
  end

  class BaseNode < Treetop::Runtime::SyntaxNode
    def to_s
      text_value.strip
    end
  end

  class HourRangeNode < BaseNode
    def fill(scheduling)
      scheduling.start_hour = start_hour.text_value.to_i
      scheduling.end_hour = end_hour.text_value.to_i
    end
  end
end
