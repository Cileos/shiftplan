class Hash
  def compact
    hash = dup
    hash.each do |key, value|
      case value
      when Hash, Array
        value.compact!
        hash.delete(key) if value.empty?
      when NilClass
        hash.delete(key)
      end
    end
    hash
  end
  
  def compact!
    replace(compact)
  end
end unless Hash.method_defined?(:compact!)