module Quickie
  module Serializable
    def to_s
      text_value.strip.gsub(/\s{2,}/, ' ')
    end
  end

  module MessageNode
    include Serializable
    def fill(scheduling)
      elements.each do |child|
        if child.respond_to?(:fill)
          child.fill(scheduling)
        end
      end
    end
  end

  class BaseNode < Treetop::Runtime::SyntaxNode
    include Serializable
  end

  class HourRangeNode < BaseNode
    def fill(scheduling)
      scheduling.start_hour = start_hour.text_value.to_i
      scheduling.end_hour = end_hour.text_value.to_i
      # must ignore the leading ':'
      scheduling.start_minute = start_minute.text_value.scan(/\d+/).first.to_i
      scheduling.end_minute = end_minute.text_value.scan(/\d+/).first.to_i
    end
  end

  class TeamNameNode < BaseNode
    def fill(scheduling)
      scheduling.team_name = to_s
    end
  end

  class TeamShortcutNode < BaseNode
    def fill(scheduling)
      scheduling.team_shortcut = shortcut.text_value
    end
  end
end
