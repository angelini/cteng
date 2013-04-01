def translations
  [
    [/^j/, lambda { |_| ["cursor-down", 1] }],
    [/^k/, lambda { |_| ["cursor-up", 1] }],
    [/^e/, lambda { |_| ["load-file", "/Users/alexangelini/Local/cteng/Gemfile"] }]
  ]
end

def handlers
  [
    [
      'cursor-up',
      lambda do |state, count|
        puts "Moving cursor up by #{count}"
      end
    ],

    [
      'cursor-down',
      lambda do |state, count|
        puts "Moving cursor down by #{count}"
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
