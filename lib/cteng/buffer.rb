class Buffer
  attr_accessor :lines

  def initialize
    @lines = []
  end

  def print
    lines.each { |l| puts l }
  end
end
