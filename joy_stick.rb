class JoyStick
  def initialize
    @x = ADC.new(ADC::CHANNEL_0, unit: ADC::UNIT_1)
    @y = ADC.new(ADC::CHANNEL_3, unit: ADC::UNIT_1)
  end

  def read
    x = to_index(4095 - @x.read_raw)
    y = to_index(@y.read_raw)
    [x, y]
  end

  def to_index(value)
    ((value * 6 - (4096 / 2)) / 4096) + 1
  end
end
