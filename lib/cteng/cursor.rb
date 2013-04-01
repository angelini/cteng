class Cursor
  attr_accessor :x, :y, :window_index

  def initialize(x = 0, y = 0, window_index = 0)
    @x = x
    @y = y
    @window_index = window_index
  end
end
