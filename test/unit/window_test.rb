require "minitest/autorun"
require "cteng/window"

class WindowTest < MiniTest::Unit::TestCase
  attr_reader :window

  def setup
    @window = Window.new Buffer.new, 150, 150
  end

  def test_current_line_empty_buffer
    assert_equal "", window.current_line(0)
  end

  def test_current_line
    buffer = Buffer.new
    buffer.lines = [
      "hello world",
      "second line"
    ]

    window.buffer = buffer
    assert_equal "hello world", window.current_line(0)
    assert_equal "second line", window.current_line(1)

    window.y += 1
    assert_equal "second line", window.current_line(0)
  end

  def test_init_with_x_and_y
    win = Window.new Buffer.new, 150, 150, 10, 5

    assert_equal 10, win.x
    assert_equal 5, win.y

    assert_equal 0, window.x
    assert_equal 0, window.y
  end
end
