def translations
  [
    [/^c/, lambda { |_| ["first-1"] }],
    [/^b/, lambda { |_| ["first-2"] }]
  ]
end

def handlers
  []
end
