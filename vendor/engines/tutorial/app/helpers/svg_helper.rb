module SvgHelper
  Root = Pathname.new(__FILE__).join('../../assets/images')
  def inline_svg(name, opts={})
    path = Root.join(name + '.svg')
    File.read(path).html_safe
  end
end
