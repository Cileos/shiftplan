class Array
  def join_safe(separator = '')
    unsafe = !!detect { |e| !e.respond_to?(:html_safe?) || !e.html_safe? }
    result = join(ERB::Util.h(separator))
    unsafe ? result : result.html_safe
  end
end
