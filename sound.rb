class Sound
  def initialize(freq, delay=1000)
    @pwm = PWM.new(ESP32::GPIO_NUM_2, freq: freq)
    @delay = delay
  end

  def start
    @pwm.duty(50)
  end

  def stop
    @pwm.duty(0)
  end

  def play
    self.start
    ESP32::System.delay(@delay)
    self.stop
  end
end
