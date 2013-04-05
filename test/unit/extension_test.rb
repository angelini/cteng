require "minitest/autorun"
require "cteng/extension"
require "cteng/state"
require "cteng/cursor"
require "cteng/window"
require "cteng/buffer"

require_relative "../fixtures/extensions/first/main.rb"
require_relative "../fixtures/extensions/second/main.rb"

class ExtensionTest < MiniTest::Unit::TestCase
  def test_extensions_stores_classes
    assert_equal 2, Extension.classes.length
    assert_includes Extension.classes, First
    assert_includes Extension.classes, Second
  end

  def test_loading_sets_properties
    state = State.new
    first = First.new

    first.load state
    assert_instance_of Cursor, first.cursor
    assert_instance_of Buffer, first.buffers[0]
    assert_equal state.cursor, first.cursor
  end

  def test_loading_translation_modes
    state = State.new
    first = First.new

    translations, _ = first.load state

    assert_equal 2, translations.length
    assert_equal 2, translations[:default].length
    assert_equal 0, translations[:other].length

    assert_instance_of Regexp, translations[:default][0][0]
    assert_instance_of Proc, translations[:default][0][1]
  end

  def test_loading_handlers
    state = State.new
    first = First.new

    _, handlers = first.load state
    assert_equal 1, handlers.length
    assert_instance_of String, handlers[0][0]
    assert_instance_of Proc, handlers[0][1]
  end
end
