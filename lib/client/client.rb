require "thread"
require "eventmachine"
require "client/screen"

class Client < EM::Connection
  attr_accessor :q, :screen

  def initialize(q, screen)
    @queue = q
    @screen = screen

    cb = Proc.new do |key|
      send_data(key)
      q.pop(&cb)
    end

    q.pop(&cb)
  end

  def receive_data(data)
    data = Marshal.load(data)
    screen.render data[:windows], data[:cursor]
  end
end

EM.run {
  q = EM::Queue.new
  screen = Screen.new

  q.push("\\cinit-window #{screen.width} #{screen.height}")

  EM.connect('localhost', 9000, Client, q, screen)

  Thread.new do
    while true
      q.push screen.getchar
    end
  end
}
