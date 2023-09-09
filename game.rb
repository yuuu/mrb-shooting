class Game
  def initialize
    @scheduler = Scheduler.new
    @matrix = Matrix.new
    @joy_stick = JoyStick.new
    @sound = Sound.new(330)
    @score = 0
    @hit = false
    next_target
  end

  def start
    @matrix.clear
    @matrix.display

    Sound.new(262).play
  end

  def judge
    @sound.stop if @hit

    x, y = @joy_stick.read

    @hit = @target.shot(x, y)
    if @hit
      @sound.start
      next_target
      @score += 1
    end

    @matrix.clear
    @matrix.update_rectangle(x, y, x + 1, y + 1)
  end

  def finish
    @matrix.clear
    @matrix.display

    Sound.new(494).play
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
