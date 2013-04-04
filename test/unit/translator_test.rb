require "minitest/autorun"
require "cteng/translator"

class TranslatorTest < MiniTest::Unit::TestCase
  attr_reader :translator, :translations

  def setup
    @translator = Translator.new

    @translations = [
      [/^j/, lambda { |m| ["event-1"] }],
      [/^kj/, lambda { |m| ["event-2"] }],
      [/^a/, lambda { |m| ["event-3"] }],
      [/^a/, lambda { |m| ["event-4"] }]
    ]
  end

  def test_adding_key
    translator.add_key 'j'
    assert_equal translator.buffer, 'j'
  end

  def test_adding_multiple_keys
    translator.add_key 'j'
    translator.add_key 'k'
    assert_equal translator.buffer, 'kj'
  end

  def test_buffer_length
    12.times { translator.add_key 'j' }
    assert_equal translator.buffer.length, 10
  end

  def test_no_match
    assert_empty translator.generate_events 'x', translations
  end

  def test_translate_single_char
    events = translator.generate_events 'j', translations
    assert_equal ["event-1"], events[0]
  end

  def test_translate_multiple_char
    translator.add_key 'j'
    events = translator.generate_events 'k', translations
    assert_equal ["event-2"], events[0]
  end

  def test_multiple_matches
    events = translator.generate_events 'a', translations

    assert_equal 2, events.length
    assert_includes events, ["event-3"]
    assert_includes events, ["event-4"]
  end

  def test_command_without_args
    events = translator.generate_events '\\cno-args', translations

    assert_equal 1, events.length
    assert_equal 'no-args', events[0][0]
  end

  def test_command_with_args
    events = translator.generate_events '\\cwith-args 1 arg', translations

    assert_equal 1, events.length
    assert_equal 'with-args', events[0][0]
    assert_equal 1, events[0][1]
    assert_equal 'arg', events[0][2]
  end

  def test_command_wont_match_translation
    events = translator.generate_events '\\ca', translations

    assert_equal 1, events.length
    assert events[0][0] != 'event-3'
    assert events[0][0] != 'event-4'
  end
end
