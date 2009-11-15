Dir[File.dirname(__FILE__) +  '/**/*_spec.rb'].each do |filename|
  require filename
end
