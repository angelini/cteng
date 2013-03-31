require "eventmachine"
require "cteng/translator"
require "cteng/extension"

class Main < EM::Connection
  def initialize(folder)
    @event_queue = EM::Queue.new
    @extensions = Extension.loadFolder(folder)
    @translator = Translator.new
  end

  def post_init
    puts "Client connected"
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
