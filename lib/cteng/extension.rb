class Extension
  attr_reader :translations, :handlers

  def self.loadFolder(folder)
    if !File.directory? folder
      raise "Extension folder not found: #{folder}"
    end

    Dir["#{folder}/*/main.rb"].map do |f|
      load(f)
      Extension.new translations(), handlers()
    end
  end

  def initialize(translations, handlers)
    @translations = translations
    @handlers = handlers
  end
end
