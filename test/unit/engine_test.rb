require "minitest/autorun"
require "cteng/engine"
require "logger"

class EngineTest < MiniTest::Unit::TestCase
  attr_accessor :engine, :folder, :state

  def setup
    @state = State.new
    @folder = File.dirname(__FILE__) + "/../fixtures/extensions"
    log = Logger.new "/dev/null"

    output = lambda do |str| end

    @engine = Engine.new [], folder, log, output
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

  def test_load_non_existant_folder
    assert_raises(RuntimeError) { engine.loadExtensions 'does_no_exist', state }
  end

  def test_load_extensions
    translations, handlers = engine.loadExtensions folder, state

    assert_equal 4, translations[:default].length
    assert_equal 1, handlers.length
  end
end
