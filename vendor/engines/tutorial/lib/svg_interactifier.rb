require 'nokogiri'
# We want to interact with the svg created by Inkscape. For this, we convert
# some of the elements to handlebar, which uses Ember's Components to
# dynamically bind properties to the elements.
#
# Caveat:
#   namespaced attributes are ignored because Ember cannot handle them (?)
class SvgInteractifier
  def interactify(xml)
    ret = xml
    n = Nokogiri::XML(xml)
    interactify_element(n, 'path[id^=tutorial_]', 'interactive-path')
    n.to_html
  end

private
  def interactify_element(document, selector, component_name)
    document.css(selector).each do |elem|

      attrs = elem.attributes.map do |k,a|
        %Q~#{k}="#{a}"~
      end.join(" ")
      Rails.logger.debug { "attrs: #{elem.attributes.keys.join(' ')}" }
      int = %Q~{{#{component_name} #{attrs}}}~
      elem.parent.add_child int

      elem.remove
    end

  end
end
