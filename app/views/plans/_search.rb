class Plans::Search < Minimal::Template
  def content
    [:employee, :workplace, :qualification].each do |type|
      div :id => "#{type}_search", :class => 'search_box' do
        image_tag 'icons/close.png', :alt => 'Close', :class => 'close'
        h3 t(:"#{type}_search")
        text_field_tag :id => "#{type}_search_query", :type => 'text'

        link_to t(:select_all), '#', :class => 'select_all'
        self << '|'
        link_to t(:deselect_all), '#', :class => 'deselect_all'

        table do
          tbody do
            render :partial => "plans/search/#{type.to_s}", :collection => type.to_s.classify.constantize.active
          end
        end
      end
    end
  end
end
