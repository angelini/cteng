require "minitest/autorun"
require "cteng/state"
require "cteng/handler"

class HandlerTest < MiniTest::Unit::TestCase
  attr_reader :handler

  def setup
    state = State.new
    @handler = Handler.new state
  end

  def test_handler_function_called_no_args
    fn = Proc.new do |state|
      assert_instance_of(State, state)
    end

    handler.handle fn, []
  end

  def test_handler_function_called_multi_arg
    fn = Proc.new do |state, a, b, c|
      assert_instance_of(State, state)
      assert_equal 1, a
      assert_equal 2, b
      assert_equal 3, c
    end

    handler.handle fn, [1, 2, 3]
  end
end
