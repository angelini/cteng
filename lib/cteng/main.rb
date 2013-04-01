require "eventmachine"
require "cteng/state"
require "cteng/translator"
require "cteng/extension"
require "cteng/handler"

class Main < EM::Connection
  def initialize(folder)
    @event_queue = EM::Queue.new
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

      puts '--- BUFFER ---'
      @state.window.buffer.print
      puts '--- END ---'

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

  def receive_data(key)
    @translator.add_key key.chomp
    events = @translator.generate_events translations
    events.each do |e|
      puts "Event: #{e}"
      @event_queue.push e
    end
  end
end
