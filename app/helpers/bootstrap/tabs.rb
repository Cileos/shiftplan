# Renders Bootstrap's tab structure for a given record.
#
# Arguments:
#
#   record:    the ActiveRecord::Base or similar records, gets passed to all partials
#   tab_names: one or more names of tabs.
#   options:   additional tweaks
#   block:     gets passed the current tab name, should return `true` on the active tab
#
# Options:
#
#   well: add class 'well' give the whole group an inset effect.
#
# Assumptions / Conventions
#
#   1) a partial should exist. The given record is passed to it. You may want
#   to reassign this to a more meaningful name in the first line, e.g.
#
#     post ||= record
#
#   2) link_to is patched to use #translate_action, which gets passed each tab name
#
# Example:
#
#     tabs_for post, :intro, :main, :comments do |tab|
#       tab == :main # or whatever your app wants
#     end

module Bootstrap
  class Tabs
    def self.for(*a, &block)
      new(*a, &block).to_html
    end

    def tag(*a, &block)
      view.content_tag(*a, &block)
    end

    attr_accessor :view, :record, :options, :tab_names, :activator
    alias h view

    def initialize(view, record, *args, &block)
      @view      = view
      @record    = record
      @options   = args.extract_options!
      @tab_names = args
      @activator = block
    end

    def to_html
      tag :div, class: "tabbable #{options[:well] && 'well'}", id: view.dom_id(record, 'tabs') do
        nav + content
      end
    end

    def nav
      tag :ul, class: "nav nav-tabs" do
        nav_items.join(' ').html_safe
      end
    end

    def content
      tag :div, class: "tab-content" do
        content_items.join(' ').html_safe
      end
    end

    private

    def nav_items
      tab_names.map do |name|
        tag :li, class: active_class(name) do
          h.link_to name.to_sym, '#' + tab_id(name), data: { toggle: 'tab' }
        end
      end
    end

    def content_items
      tab_names.map do |name|
        tag :div, view.render(name.to_s, record: record), class: "tab-pane #{active_class(name)}", id: tab_id(name)
      end
    end

    def tab_id(name)
      "tab_#{name}_#{record.id}"
    end

    def active_class(name)
      if activator
        activator.call(name)
      else
        tab_names.index(name) == 0
      end && 'active'
    end
  end
end
