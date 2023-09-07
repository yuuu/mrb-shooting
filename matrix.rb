class Matrix
  def initialize
    spi.write([0x0c, 0x01])
    spi.write([0x09, 0x00])
    spi.write([0x0a, 0x0f])
    spi.write([0x0b, 0x07])

    @pre_dots = [
      0b11111111,
      0b11111111,
      0b11111111,
      0b11111111,
      0b11111111,
      0b11111111,
      0b11111111,
      0b11111111,
    ]
    @dots = [
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
    ]
  end

  def update_rectangle(x1, y1, x2, y2)
    value = ((0b1 << y1) | (0b1 << y2)) & 0b11111111
    @dots[x1] = value
    @dots[x2] = value
  end

  def update_point(x, y, on)
    value = on ? (@dots[x] | (0b1 << y)) : (@dots[x] & ~(0b1 << y))
    @dots[x] = (value & 0b11111111)
  end

  def clear
    @dots = [
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
      0b00000000,
    ]
  end

  def display_result(score)
    clear
    score.times do |s|
      x = s / 8
      y = s % 8
      @dots[x] = @dots[x] | (0b1 << y)
    end
    display
  end

  def display
    @dots.each_with_index do |val, i|
      next if @pre_dots[i] == val

      spi.write([i + 1, val])
      @pre_dots[i] = val
    end
  end

  def spi
    @spi ||= SPI.new(frequency: 10_000_000)
  end
end
