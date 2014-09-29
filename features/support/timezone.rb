# detect nasty bugs caused by us ignoring timezones
Zonebie.set_random_timezone


require_dependency 'capybara_time_zone_applier'
Before do
  CapybaraTimeZoneApplier.write
end

After do
  CapybaraTimeZoneApplier.clean
end
