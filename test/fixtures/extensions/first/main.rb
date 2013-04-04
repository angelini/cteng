def translations
  {
    'default' =>
    [
      [/^c/, lambda { |_| ["first-1"] }],
      [/^b/, lambda { |_| ["first-2"] }]
    ]
  }
end

def handlers
  [
    [
      'matched-event',
      lambda do |state|
        state.cursor.x += 1
      end
    ]
  ]
end
