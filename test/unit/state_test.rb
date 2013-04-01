require "minitest/autorun"
require "cteng/state"
require "cteng/buffer"
require "cteng/window"

class StateTest < MiniTest::Unit::TestCase
  attr_reader :state

  def setup
    @state = State.new
  end

  def test_default_mode
    assert_equal 'default', state.mode
  end

  def test_buffers_contains_a_buffer
    assert_equal 1, state.buffers.length
    assert_instance_of Buffer, state.buffers[0]
  end

  def test_windows_contains_a_window
    assert_equal 1, state.windows.length
    assert_instance_of Window, state.windows[0]
  end

  def test_window_advances_with_cursor
    window_1 = state.window
    assert_instance_of Window, window_1

    state.windows << Window.new(state.buffer, 0, 0)
    state.cursor.window_index += 1

    window_2 = state.window
    assert_instance_of Window, window_2

    assert window_1 != window_2
  end
end
