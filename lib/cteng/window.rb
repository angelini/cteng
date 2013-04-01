class Window
  attr_accessor :buffer, :x, :y, :width, :height

  def initialize(buffer, x, y)
    @buffer = buffer
    @x = x
    @y = y

    @width = 150
    @height = 150
  end
end
