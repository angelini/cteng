def generate_movement(match, xmult, ymult)
  count = match[0][0..-2]
  count = count.length > 0 ? Integer(count) : 1

  ["cursor-move", xmult * count, ymult * count]
end

def translations
  {
    "default" =>
    [
      [/\d*j$/, lambda { |m| generate_movement m, 0, 1 }],
      [/\d*k$/, lambda { |m| generate_movement m, 0, -1 }],
      [/\d*h$/, lambda { |m| generate_movement m, -1, 0 }],
      [/\d*l$/, lambda { |m| generate_movement m, 1, 0 }],
      [/i$/, lambda { |_| ["change-mode", "insert"] }],
      [/e$/, lambda { |_| ["load-file", "/Users/alexangelini/Local/cteng/Gemfile"] }]
    ],

      'insert' =>
    [
      [/[a-zA-Z]$/, lambda { |m| ["insert-string", m[0]] }]
    ]
  }
end

def handlers
  [
    [
      'cursor-move',
      lambda do |state, x, y|
        cursor = state.cursor
        buffer = state.window.buffer

        if y >= 0
          y = [buffer.length - 1, cursor.y + y].min
        else
          y = [0, cursor.y + y].max
        end

        cursor.y = y < 0 ? 0 : y
        line = state.window.current_line cursor.y

        if x >= 0
          x = [line.length - 1, cursor.x + x].min
        else
          x = [0, cursor.x + x].max
        end

        cursor.x = x < 0 ? 0 : x
      end
    ],

    [
      'init-window',
      lambda do |state, width, height|
        state.create_window width, height
      end
    ],

    [
      'change-mode',
      lambda do |state, mode|
        state.mode = mode
      end
    ],

    [
      'load-file',
      lambda do |state, path|
        File.open(path, 'r') do |f|
          while (line = f.gets)
            state.buffer.lines << line.chomp
          end
        end
      end
    ],

    [
      'insert-string',
      lambda do |state, str|
        state.buffer.lines[state.cursor.y].insert state.cursor.x, str
        state.cursor.x += 1
      end
    ]
  ]
end
