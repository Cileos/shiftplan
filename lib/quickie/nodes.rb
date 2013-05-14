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
      scheduling.start_time = start_time.text_value
      scheduling.end_time = end_time.text_value
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
