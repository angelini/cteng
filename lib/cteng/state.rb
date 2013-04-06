require "cteng/cursor"
require "cteng/buffer"
require "cteng/window"

class State
  attr_accessor :mode, :cursor, :windows, :buffers

  def initialize
    @mode = :default
    @cursor = Cursor.new

    buffer = Buffer.new

    @buffers = [buffer]
    @windows = []
  end

  def window
    windows[cursor.window_index]
  end

  def buffer
    window.buffer
  end

  def create_window(width, height, x = 0, y = 0)
    buffer = Buffer.new
    buffers << buffer
    windows << Window.new(buffer, width, height, x, y)
  end
end
