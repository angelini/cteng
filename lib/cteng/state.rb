require "cteng/cursor"
require "cteng/buffer"
require "cteng/window"

class State
  attr_accessor :mode, :cursor, :windows, :buffers

  def initialize
    @mode = 'default'

    buffer = Buffer.new
    window = Window.new buffer, 0, 0

    @buffers = [buffer]
    @windows = [window]
    @cursor = Cursor.new
  end

  def window
    windows[cursor.window_index]
  end

  def buffer
    window.buffer
  end
end
