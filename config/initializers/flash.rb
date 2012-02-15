Rails.configuration.after_initialize do
  InheritedResources.flash_keys = [:info, :alert]
end

