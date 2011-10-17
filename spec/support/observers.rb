
require 'no_peeping_toms'

RSpec.configure do |config|
  config.before(:all) do
    ActiveRecord::Observer.disable_observers
  end
end
