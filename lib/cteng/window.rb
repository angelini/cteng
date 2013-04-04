class Window
  attr_accessor :buffer, :x, :y, :width, :height

  def initialize(buffer, width, height)
    @x = 0
    @y = 0

    @buffer = buffer
    @width = width
    @height = height
  end

  def current_line(cursor_y)
    buffer.lines[y + cursor_y] || ""
  end
end
