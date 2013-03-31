require "termios"
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

EM.run {
  attributes = Termios.tcgetattr($stdin).dup
  attributes.lflag &= ~Termios::ECHO
  attributes.lflag &= ~Termios::ICANON
  Termios::tcsetattr($stdin, Termios::TCSANOW, attributes)

  q = EM::Queue.new
  EM.connect('localhost', 9000, Client, q)
  EM.open_keyboard(KeyboardHandler, q)
}
