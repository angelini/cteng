require "minitest/autorun"
require "cteng/response"

class ResponseTest < MiniTest::Unit::TestCase
  attr_reader :state, :buffer

  def setup
    @state = State.new
    @buffer = [
      'Line 1',
      'Line 2',
      'Hello World',
      '',
      'Line 5'
    ]
  end

  def test_output_is_string
    assert_instance_of String, Response.generate(state)
  end

  def test_cursor
    state.cursor.x = 10
    state.cursor.y = 15

    res = Marshal.load Response.generate(state)
    assert_equal 10, res[:cursor][:x]
    assert_equal 15, res[:cursor][:y]
  end

  def test_no_windows
    res = Marshal.load Response.generate(state)
    assert_equal 0, res[:windows].length
  end

  def test_window_at_top_left
    state.create_window 100, 100
    state.buffer.lines = buffer

    res = Marshal.load Response.generate(state)
    assert_equal buffer[0], res[:windows][0][:lines][0]
  end
end
