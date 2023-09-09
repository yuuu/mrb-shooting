class Game
  def initialize
    @scheduler = Scheduler.new
    @matrix = Matrix.new
    @joy_stick = JoyStick.new
    @score = 0
    @pwm = PWM.new(ESP32::GPIO_NUM_2, freq: 262)
    next_target
    @hit = false
  end

  def start
    @matrix.clear
    @matrix.display

    @pwm.duty(50)
    ESP32::System.delay(1000)
    @pwm.duty(0)
    @pwm = PWM.new(ESP32::GPIO_NUM_2, freq: 330)
  end

  def judge
    @pwm.duty(0) if @hit

    x, y = @joy_stick.read

    @hit = @target.shot(x, y)
    if @hit
      @pwm.duty(50)
      next_target
      @score += 1
    end

    @matrix.clear
    @matrix.update_rectangle(x, y, x + 1, y + 1)
  end

  def finish
    @matrix.clear
    @matrix.display

    @pwm = PWM.new(ESP32::GPIO_NUM_2, freq: 494)
    @pwm.duty(50)
    ESP32::System.delay(1000)
    @pwm.duty(0)
    ESP32::System.delay(500)

    @matrix.display_result(@score)
    @scheduler.resume
  end

  def next_target
    x = ESP32::Timer.get_time.to_i % 8
    y = (ESP32::Timer.get_time.to_i / 10) % 8
    @target = Target.new(x, y)
  end

  def play
    start

    @scheduler.add_task(25) do
      @matrix.display
    end
    @scheduler.add_task(50) do
      judge
    end
    @scheduler.add_task(100) do
      x, y, on = @target.blink
      @matrix.update_point(x, y, on)
    end
    @scheduler.add_task(20000) do
      finish
    end
    @scheduler.run
  end
end

game = Game.new
game.play
