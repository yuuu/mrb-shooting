class Scheduler
  PERIOD = 20

  def initialize
    @tasks = []
    @resume = false
  end

  def add_task(period, &block)
    @tasks << Task.new(period, block, ESP32::Timer.get_time)
  end

  def run
    loop do
      if @resume 
        ESP32::System.delay(PERIOD)
        next
      end

      start_time = ESP32::Timer.get_time

      @tasks.each do |task|
        task.run(start_time)
      end
      
      end_time = ESP32::Timer.get_time

      wait(start_time, end_time)
    end
  end

  def resume
    @resume = true
  end

  def wait(start_time, end_time)
    time = (end_time - start_time) / 1000
    return if(time > PERIOD)

    ESP32::System.delay(PERIOD - time)
  end
end
