def translations
  [
    [/^j/, lambda { |_| ["cursor-down", 1] }],
    [/^k/, lambda { |_| ["cursor-up", 1] }]
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
    ]
  ]
end
