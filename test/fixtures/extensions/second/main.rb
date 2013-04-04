def translations
  {
    "default" =>
    [
      [/^a/, lambda { |_| ["second-1"] }],
      [/^b/, lambda { |_| ["second-2"] }]
    ]
  }
end

def handlers
  []
end
