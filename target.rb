class Target
  def initialize(x, y)
    @x = x
    @y = y
    @on = true
  end

  def blink
    @on = !@on
    [@x, @y, @on]
  end

  def shot(x, y)
    if (@x == x || @x == (x + 1)) && (@y == y || @y == (y + 1))
      @on = false
      true
    else
      false
    end
  end
end
