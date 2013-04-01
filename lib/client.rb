require "curses"
require "eventmachine"

class Client < EM::Connection
  def initialize(q, win)
    @queue = q
    @win = win

    cb = Proc.new do |key|
      send_data(key)
      q.pop(&cb)
    end

    q.pop(&cb)
  end

  def receive_data(data)
    data = Marshal.load(data)
    @win.clear

    data[:windows][0].each_with_index do |line, index|
      @win << (line + "\n")
    end

    @win.setpos(data[:cursor][1], data[:cursor][0])
    @win.refresh
  end
end

class KeyboardHandler < EM::Connection
  def initialize(q)
    @queue = q
  end

  def receive_data(key)
    @queue.push key
  end
end

def setup_screen
  Curses.noecho
  Curses.init_screen

  Curses::Window.new Curses.lines, Curses.cols, 0, 0
end

EM.run {
  q = EM::Queue.new
  win = setup_screen

  q.push("\\cinit-window #{win.maxx} #{win.maxy}")

  EM.connect('localhost', 9000, Client, q, win)
  EM.open_keyboard(KeyboardHandler, q)
}
