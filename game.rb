class Game
  def initialize
    @scheduler = Scheduler.new
    @matrix = Matrix.new
    @joy_stick = JoyStick.new
    @score = 0
    next_target
  end

  def next_target
    x = ESP32::Timer.get_time.to_i % 8
    y = (ESP32::Timer.get_time.to_i / 10) % 8
    @target = Target.new(x, y)
  end

  def play
    @scheduler.add_task(20) do
      @matrix.display
    end
    @scheduler.add_task(40) do
      x, y = @joy_stick.read

      if @target.shot(x, y)
        next_target
        @score += 1
      end

      @matrix.clear
      @matrix.update_rectangle(x, y, x + 1, y + 1)
    end
    @scheduler.add_task(100) do
      x, y, on = @target.blink
      @matrix.update_point(x, y, on)
    end
    @scheduler.add_task(20000) do
      @matrix.display_result(@score)
      @scheduler.resume
    end
    @scheduler.run
  end
end

game = Game.new
game.play
