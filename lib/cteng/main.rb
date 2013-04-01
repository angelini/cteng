require "eventmachine"
require "cteng/state"
require "cteng/translator"
require "cteng/extension"
require "cteng/handler"

class Main < EM::Connection
  def initialize(q, folder)
    @event_queue = q
    @extensions = Extension.loadFolder(folder)

    @state = State.new
    @translator = Translator.new
    @handler = Handler.new @state
  end

  def post_init
    puts "Client connected"

    cb = Proc.new do |event|
      handlers.each do |h|
        @handler.handle h[1], event.slice(1..-1) if h[0] == event[0]
      end

      send_data(response_data)
      @event_queue.pop(&cb)
    end

    @event_queue.pop(&cb)
  end

  def unbind
    puts "Client disconnected"
  end

  def translations
    @extensions.map { |e| e.translations }.flatten 1
  end

  def handlers
    @extensions.map { |e| e.handlers }.flatten 1
  end

  def response_data
    windows = @state.windows.map do |window|
      lines = []

      window.height.times do |i|
        if i < window.buffer.lines.length
          lines << window.buffer.lines[i]
        else
          lines << ""
        end
      end

      lines
    end

    Marshal.dump({
      :cursor => [@state.cursor.x, @state.cursor.y],
      :windows => windows
    })
  end

  def receive_data(key)
    events = @translator.generate_events key

    events.each do |e|
      puts "Event: #{e}"
      @event_queue.push e
    end
  end
end
