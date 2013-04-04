require "minitest/autorun"
require "cteng/engine"
require "logger"

class EngineTest < MiniTest::Unit::TestCase
  attr_accessor :engine

  def setup
    folder = File.dirname(__FILE__) + "/../fixtures/extensions"
    log = Logger.new "/dev/null"

    output = lambda do |str| end

    @engine = Engine.new [], folder, log, output
  end

  def test_translations_depth
    assert_equal 4, engine.translations.length
    assert_equal 2, engine.translations[0].length
  end

  def test_handlers_depth
    assert_equal 1, engine.handlers.length
    assert_equal 2, engine.handlers[0].length
  end

  def test_input_creates_queue_events
    engine.input 'c'
    assert_equal 1, engine.event_queue.length
    assert_equal "first-1", engine.event_queue.pop[0]
  end

  def test_unmatched_input
    engine.input 'x'
    assert_equal 0, engine.event_queue.length
  end

  def test_event_queueing
    engine.input 'c'
    engine.input 'c'
    engine.input 'c'
    assert_equal 3, engine.event_queue.length
  end

  def test_event_handling
    engine.output = lambda do |str|
      result = Marshal.load str
      assert_equal 1, result[:cursor][0]
    end

    engine.handle_event ["matched-event"]
  end
end
