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
    interactify_element(n, 'path[id^=tutorial_]', 'interactive-path', bindings: { 'tutorial_step' => 'chapter' })
    n.to_html
  end

private
  def interactify_element(document, selector, component_name, options={})
    document.css(selector).each do |elem|

      attrs = elem.attributes.map do |k,a|
        %Q~#{k}="#{a}"~
      end.join(" ")
      Rails.logger.debug { "attrs: #{elem.attributes.keys.join(' ')}" }
      binds = binds_for(elem, options[:bindings])
      int = %Q~{{#{component_name} #{attrs} #{binds} }}~
      elem.parent.add_child int

      elem.remove
    end
  end

  def binds_for(element, binds)
    return '' unless binds.present?

    binds.map do |id_prefix, prefix|
      signi = element['id'].sub(id_prefix + '_', '')

      %Q~#{prefix}=#{prefix}_#{signi}~
    end.join(' ')
  end

end
