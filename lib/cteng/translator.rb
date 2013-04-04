class Translator
  attr_reader :buffer

  def initialize
    @buffer = ""
  end

  def command?(data)
    data.slice(0..1) == "\\c"
  end

  def command_events(data)
    command = data.slice(2..-1).split " "

    command = command.map do |arg|
      arg =~ /^[0-9]+$/ ? Integer(arg) : arg
    end

    [command]
  end

  def add_key(key)
    @buffer = key + @buffer
    @buffer.slice! 10..-1
  end

  def translate(translations)
    translations.inject([]) do |events, trans|
      matches = @buffer.scan(trans[0])
      events << trans[1].call(matches) if matches.length > 0
      events
    end
  end

  def generate_events(key, translations)
    return command_events key if command? key
    add_key key
    translate translations
  end
end
