class Second
  include Extension

  def default_translations
    [
      [/^a/, -> (_) { ["second-1"] }],
      [/^b/, -> (_) { ["second-2"] }]
    ]
  end

  def handlers
    []
  end
end
