require 'core_ext/array/join_safe'

class PlanPresenter
  class ShiftPresenter < Presenter
    def attributes
      {
        :class => dom_id(workplace),
        :'data-workplace-id' => workplace_id,
        :'data-start' => start_in_minutes,
        :'data-duration' => duration
      }
    end

    def render
      content_tag_for(:li, shift, attributes) do
        # div(:class => 'actions') { link_to('delete', shift_path(shift), :method => :delete, :class => 'delete') } +
        h3(workplace.name) +
        ul(:class => 'requirements') do
          requirements.map { |requirement| presenter_for(requirement, 'plan/requirement').render }.join_safe
        end
      end
    end
  end
end
