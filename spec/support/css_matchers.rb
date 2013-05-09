RSpec::Matchers.define :include_scss do |expected|
  def normalize(css)
    css.gsub(/\s{2,}/,' ')
  end
  match do |given|
    normalize(given).include?( normalize(expected) )
  end
end

