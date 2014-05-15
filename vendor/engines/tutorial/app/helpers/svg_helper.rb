module SvgHelper
  Root = Pathname.new(__FILE__).join('../../assets/images')
  def inline_svg(name, opts={})
    path = Root.join(name + '.svg')
    interactify( File.read(path) ).html_safe
  end

  def interactify(xml)
    ret = xml
    n = Nokogiri::XML(xml)
    n.css('path[id^=tutorial_]').each do |elem|

      attrs = elem.attributes.map do |k,a|
        %Q~#{k}="#{a}"~
      end.join(" ")
      int = %Q~{{interactive-path #{attrs}}}~
      elem.parent.add_child int

      elem.remove
    end
    n.to_html
  end
end
