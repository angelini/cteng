def translations
  [
    [/^j/, lambda { |_| ["cursor-move", 0, 1] }],
    [/^k/, lambda { |_| ["cursor-move", 0, -1] }],
    [/^h/, lambda { |_| ["cursor-move", -1, 0] }],
    [/^l/, lambda { |_| ["cursor-move", 1, 0] }],
    [/^e/, lambda { |_| ["load-file", "/Users/alexangelini/Local/cteng/Gemfile"] }]
  ]
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
      'load-file',
      lambda do |state, path|
        File.open(path, 'r') do |f|
          while (line = f.gets)
            state.buffer.lines << line
          end
        end
      end
    ]
  ]
end
