require "eventmachine"
require "cteng/state"
require "cteng/translator"
require "cteng/extension"
require "cteng/response"

require "pry"

class Engine
  attr_accessor :event_queue, :log, :output,
                :state, :translator,
                :translations, :handlers

  def initialize(q, folder, log, output)
    @event_queue = q
    @log = log
    @output = output
    @state = State.new

    @translations, @handlers = loadExtensions folder, state
    @translator = Translator.new
  end

  def init_queue
    event_queue.pop(&method(:handle_event))
  end

  def loadExtensions(folder, state)
    if !File.directory? folder
      raise "Extension folder not found: #{folder}"
    end

    Dir["#{folder}/*/*.rb"].each { |file| require file }

    translations = {}
    handlers = []
    Extension.classes.each do |ext|
      ext_trans, ext_handl = ext.new.load state
      ext_trans.each { |k, v| translations[k] ||= []; translations[k] += v }
      handlers += ext_handl
    end

    [translations, handlers]
  end

  def input(key)
    log.info key
    events = translator.generate_events key, translations[state.mode]

    events.each do |e|
      log.info e
      event_queue.push e
    end
  end

  def handle_event(event)
    handlers.each do |h|
      h[1].call(*event.slice(1..-1)) if h[0] == event[0]
    end

    output.call Response.generate(state)
    event_queue.pop(&method(:handle_event))
  end
end
