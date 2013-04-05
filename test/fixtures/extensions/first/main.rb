class First
  include Extension

  def default_translations
    [
      [/^c/, -> (_) { ["first-1"] }],
      [/^b/, -> (_) { ["first-2"] }]
    ]
  end

  def other_translations
    []
  end

  def handlers
    [
      [
        'matched-event', -> () do
          cursor.x += 1
        end
      ]
    ]
  end
end
