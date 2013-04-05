module Extension
  attr_accessor :state, :cursor, :windows, :buffers,
                :translations, :handlers

  def self.included(base)
    @classes ||= []
    @classes << base
  end

  def self.classes
    @classes
  end

  def load(state)
    @state = state
    @cursor = state.cursor
    @windows = state.windows
    @buffers = state.buffers

    translations = {}
    public_methods(false).grep(/\S+_translations$/) do |method|
      mode = method.to_s.split("_")[0].to_sym
      translations[mode] = send method
    end

    [translations, send(:handlers)]
  end

  def window
    state.window
  end

  def buffer
    state.buffer
  end
end
