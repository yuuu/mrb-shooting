class Task
  def initialize(period, block, time)
    @block = block
    @period = period
    @next_time = time + (@period * 1000)
  end

  def run(time)
    return if time < @next_time

    @block.call
    @next_time = time + (@period * 1000)
  end
end
