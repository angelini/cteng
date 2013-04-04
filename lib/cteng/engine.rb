require "eventmachine"
require "cteng/state"
require "cteng/translator"
require "cteng/extension"
require "cteng/handler"
require "cteng/response"

class Engine
  attr_accessor :event_queue, :extensions, :state, :translator,
                :handler, :log, :output

  def initialize(q, folder, log, output)
    @event_queue = q
    @log = log
    @output = output
    @extensions = Extension.loadFolder(folder)

    @state = State.new
    @translator = Translator.new
    @handler = Handler.new state
  end

  def init_queue
    event_queue.pop(&method(:handle_event))
  end

  def translations
    extensions.map { |e| e.translations[state.mode] }.flatten 1
  end

  def handlers
    extensions.map { |e| e.handlers }.flatten 1
  end

  def input(key)
    log.info key
    events = translator.generate_events key, translations

    events.each do |e|
      log.info e
      event_queue.push e
    end
  end

  def handle_event(event)
    handlers.each do |h|
      handler.handle h[1], event.slice(1..-1) if h[0] == event[0]
    end

    output.call Response.generate(state)
    event_queue.pop(&method(:handle_event))
  end
end
