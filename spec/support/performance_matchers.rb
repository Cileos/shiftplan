RSpec::Matchers.define :take_less_than do |n|
  chain :seconds do; end

  match do |block|
    require 'benchmark'
    Rails.logger.debug { '==================== Benchmark start ============' }
    @elapsed = Benchmark.realtime do
      block.call
    end
    Rails.logger.debug { '==================== Benchmark end ============' }
    @elapsed <= n
  end

  failure_message_for_should do |actual|
    "expected that it runs in less than #{n} seconds, but it took #{@elapsed} (#{(@elapsed/n).round(2)} times as long)"
  end
end
