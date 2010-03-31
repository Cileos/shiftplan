# ugh - see https://rails.lighthouseapp.com/projects/8994/tickets/3800-arrays-from-i18n-files-and-html_safe
class Array
  def html_safe
    each { |e| e.html_safe unless e.nil? }
  end
end

require 'ruby_ext/array/join_safe'
require 'ruby_ext/array/conversions'
require 'ruby_ext/date/calculations'
require 'ruby_ext/hash/compact'
