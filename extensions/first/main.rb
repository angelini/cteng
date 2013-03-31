def translations
  [
    [/^j/, lambda { |_| ["cursor-down", 1] }],
    [/^k/, lambda { |_| ["cursor-up", 1] }]
  ]
end

def handlers
  []
end
