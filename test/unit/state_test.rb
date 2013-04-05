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
    assert_equal :default, state.mode
  end

  def test_buffers_contains_a_buffer
    assert_equal 1, state.buffers.length
    assert_instance_of Buffer, state.buffers[0]
  end

  def test_windows_defaults_to_empty
    assert_equal 0, state.windows.length
  end

  def test_creating_window
    state.create_window 150, 150

    assert_equal 1, state.windows.length
    assert_instance_of Window, state.windows[0]
  end

  def test_accessing_created_window
    state.create_window 150, 150
    assert_instance_of Window, state.window
  end

  def test_cursor_indices
    state.create_window 150, 150
    assert_instance_of Window, state.windows[0]


    state.create_window 150, 150
    assert_instance_of Window, state.windows[1]

    window_1 = state.window
    state.cursor.window_index += 1
    window_2 = state.window

    assert window_1 != window_2
  end
end
