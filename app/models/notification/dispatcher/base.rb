class Notification::Dispatcher::Base
  attr_reader :origin

  def initialize(origin)
    @origin = origin
  end
end
