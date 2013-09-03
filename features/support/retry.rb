module RetrySupport
  def retrying_once(exception)
    retried = false
    begin
      yield
    rescue exception => e
      if not retried
        retried = true
        retry
      end
    end
  end
end

World(RetrySupport)
