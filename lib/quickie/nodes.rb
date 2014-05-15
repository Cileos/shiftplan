module Quickie
  module Serializable
    def to_s
      text_value.strip.gsub(/\s{2,}/, ' ')
    end
  end

  module MessageNode
    include Serializable
    def fill(target)
      elements.each do |child|
        if child.respond_to?(:fill)
          child.fill(target)
        end
      end
    end
  end

  class BaseNode < Treetop::Runtime::SyntaxNode
    include Serializable
  end

  class HourRangeNode < BaseNode
    def fill(target)
      if target.respond_to?(:start_time=)
        target.start_time = start_time.text_value
      end
      if target.respond_to?(:end_time=)
        target.end_time = end_time.text_value
      end
    end
  end

  class TeamNameNode < BaseNode
    def fill(target)
      if target.respond_to?(:team_name)
        target.team_name = to_s
      end
    end
  end

  class TeamShortcutNode < BaseNode
    def fill(target)
      if target.respond_to?(:team_shortcut)
        target.team_shortcut = shortcut.text_value
      end
    end
  end
end
