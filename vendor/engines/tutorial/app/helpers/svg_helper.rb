require_dependency 'svg_interactifier'
module SvgHelper
  Root = Pathname.new(__FILE__).join('../../assets/images')
  def interactive_svg(name, opts={})
    path = Root.join(name + '.svg')
    interactify( File.read(path) ).html_safe
  end

  def interactify(*a)
    SvgInteractifier.new.interactify(*a)
  end
end
