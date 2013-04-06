class Response
  def self.generate(state)
    cursor = state.cursor

    windows = state.windows.map do |window|
      lines = []

      window.height.times do |i|
        if i < window.buffer.lines.length
          lines << window.buffer.lines[i]
        else
          lines << ""
        end
      end

      { :lines => lines,
        :height => window.height,
        :width => window.width,
        :x => window.x,
        :y => window.y }
    end

    p windows
    a = { :x => cursor.x, :y => cursor.y }
    p a
    Marshal.dump({
      :cursor => { :x => cursor.x, :y => cursor.y },
      :windows => windows
    })
  end
end
