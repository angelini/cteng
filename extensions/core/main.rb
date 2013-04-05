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
      [/w$/, -> (_) { ["init-window", 100, 10] }]
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
            [buffer.length - 1, cursor.y + y].min
          else
            [0, cursor.y + y].max
          end

          cursor.y = y < 0 ? 0 : y
          line = window.current_line cursor.y

          x = if x >= 0
            [line.length - 1, cursor.x + x].min
          else
            [0, cursor.x + x].max
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
