module WillPaginate
  module ActionView
    def will_paginate(collection = nil, options = {})
      options[:renderer] ||= BootstrapLinkRenderer
      super.try :html_safe
    end

    class BootstrapLinkRenderer < LinkRenderer

      protected

      def url(page)
        @base_url_params ||= begin
          url_params = merge_get_params(default_url_params)
          merge_optional_params(url_params)
        end

        url_params = @base_url_params.dup
        add_current_page_param(url_params, page)

        if custom_link_url = @options[:custom_link_url]
          custom_link_url = [custom_link_url, page_params(url_params)].join('?')
        else
          @template.url_for(url_params)
        end
      end

      def page_params(params)
        params.select {|k,v| [:page, :per_page].include?(k) }.map {|k,v| "#{k}=#{v}"}.join('&')
      end


      def html_container(html)
        tag :div, tag(:ul, html), container_attributes
      end

      def page_number(page)
        tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
      end

      def previous_or_next_page(page, text, classname)
        tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
      end
    end
  end
end

