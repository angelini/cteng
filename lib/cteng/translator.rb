class Translator
  attr_reader :buffer

  def initialize
    @buffer = ""
  end

  def add_key(key)
    @buffer = key + @buffer
    @buffer.slice! 10..-1
  end

  def generate_events(translations)
    translations.inject([]) do |events, trans|
      matches = @buffer.scan(trans[0])
      events << trans[1].call(matches) if matches.length > 0
      events
    end
  end
end
