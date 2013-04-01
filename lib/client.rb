require "curses"
require "eventmachine"

class Client < EM::Connection
  def initialize(q)
    @queue = q

    cb = Proc.new do |key|
      send_data(key)
      q.pop(&cb)
    end

    q.pop(&cb)
  end

  def receive_data(data)
    puts "Received from Cteng: #{data}"
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

  win = Curses::Window.new Curses.lines, Curses.cols, 0, 0

  win.box "|", "-"
  win.setpos 1, 1
  win.refresh

  win
end

EM.run {
  setup_screen

  q = EM::Queue.new
  EM.connect('localhost', 9000, Client, q)
  EM.open_keyboard(KeyboardHandler, q)
}
