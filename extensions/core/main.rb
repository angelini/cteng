def generate_movement(match, xmult, ymult)
  count = match[0].reverse.slice(0..-2)
  count = Integer(count) rescue 1

  ["cursor-move", xmult * count, ymult * count]
end

def translations
  {
    'default' =>
    [
      [/^j\d*/, lambda { |m| generate_movement m, 0, 1 }],
      [/^k\d*/, lambda { |m| generate_movement m, 0, -1 }],
      [/^h\d*/, lambda { |m| generate_movement m, -1, 0 }],
      [/^l\d*/, lambda { |m| generate_movement m, 1, 0 }],
      [/^i/, lambda { |_| ["change-mode", "insert"] }],
      [/^e/, lambda { |_| ["load-file", "/Users/alexangelini/Local/cteng/Gemfile"] }]
    ],

      'insert' =>
    [
      [/^[a-zA-Z]/, lambda { |m| ["insert-string", m[0]] }]
    ]
  }
end

def handlers
  [
    [
      'cursor-move',
      lambda do |state, x, y|
        state.cursor.x += x
        state.cursor.y += y

        state.cursor.x = 0 if state.cursor.x < 0
        state.cursor.y = 0 if state.cursor.y < 0

        state.cursor.x = state.window.width - 1 if state.cursor.x >= state.window.width
        state.cursor.y = state.window.height - 1 if state.cursor.y >= state.window.height
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
