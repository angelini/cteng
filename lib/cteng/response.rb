class Response
  def self.generate(state)
    windows = state.windows.map do |window|
      lines = []

      window.height.times do |i|
        if i < window.buffer.lines.length
          lines << window.buffer.lines[i]
        else
          lines << ""
        end
      end

      lines
    end

    Marshal.dump({
      :cursor => [state.cursor.x, state.cursor.y],
      :windows => windows
    })
  end
end
