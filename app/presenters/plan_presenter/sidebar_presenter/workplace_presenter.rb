class PlanPresenter
  module SidebarPresenter
    class WorkplacePresenter < Presenter
      def attributes
        {
          :class => "#{workplace.class.name.underscore} #{dom_id(workplace)} dialog",
          :'data-workplace-id' => id,
          :'data-default-shift-length' => default_shift_length,
          :'data-default-staffing' => default_staffing.to_json
        }
      end

      def render
        li do
          link_to(name, path, attributes)
        end
      end
    end
  end
end
