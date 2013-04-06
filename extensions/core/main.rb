class Core
  include Extension

  def generate_movement(match, xmult, ymult)
    count = match[0][0..-2]
    count = count.length > 0 ? Integer(count) : 1

    ["cursor-move", xmult * count, ymult * count]
  end

  def default_translations
    [
      [/\d*j$/, -> (m) { generate_movement m, 0, 1 }],
      [/\d*k$/, -> (m) { generate_movement m, 0, -1 }],
      [/\d*h$/, -> (m) { generate_movement m, -1, 0 }],
      [/\d*l$/, -> (m) { generate_movement m, 1, 0 }],
      [/i$/, -> (_) { ["change-mode", :insert] }],
      [/e$/, -> (_) { ["load-file", "/Users/alexangelini/Local/cteng/Gemfile"] }],
      [/w$/, -> (_) { ["split-window"] }],
      [/s$/, -> (_) { ["move-window"] }]
    ]
  end

  def insert_translations
    [
      [/[a-zA-Z]$/, -> (m) { ["insert-string", m[0]] }]
    ]
  end

  def handlers
    [
      [
        'cursor-move', -> (x, y) do
          y = if y >= 0
            [window.y + buffer.length - 1, cursor.y + y].min
          else
            [window.y, cursor.y + y].max
          end

          cursor.y = y < 0 ? 0 : y
          line = window.current_line cursor.y

          x = if x >= 0
            [line.length - 1, cursor.x + x].min
          else
            [window.x, cursor.x + x].max
          end

          cursor.x = x < 0 ? 0 : x
        end
      ],

      [
        'init-window', -> (width, height) do
          state.create_window width, height
        end
      ],

      [
        'split-window', -> () do
          n_height = window.height / 2
          window.height = n_height

          state.create_window window.width, n_height - 1, 0, n_height
        end
      ],

      [
        'move-window', -> () do
          n_win = windows[cursor.window_index + 1]
          return if n_win == nil

          cursor.window_index += 1
          cursor.y = n_win.y
          cursor.x = n_win.x
        end
      ],

      [
        'change-mode', -> (mode) do
          state.mode = mode
        end
      ],

      [
        'load-file', -> (path) do
          File.open(path, 'r') do |f|
            while (line = f.gets)
              buffer.lines << line.chomp
            end
          end
        end
      ],

      [
        'insert-string', -> (str) do
          window.current_line(cursor.y).insert cursor.x, str
          cursor.x += 1
        end
      ]
    ]
  end
end
