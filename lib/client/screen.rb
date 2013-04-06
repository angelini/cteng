require "curses"

class Screen
  include Curses

  def initialize
    noecho
    cbreak
    nonl
    init_screen
    stdscr.keypad true
  end

  def width
    cols
  end

  def height
    lines
  end

  def getchar
    getch
  end

  def render(windows, cursor)
    windows.each do |win|
      render_window win[:x], win[:y], win[:width], win[:height], win[:lines]
    end

    setpos cursor[:y], cursor[:x]
    refresh
  end

  def render_window(x, y, width, height, lines)
    setpos y, x
    height.times do |h|
      setpos y + h, 0
      width.times do |w|
        addstr lines[h][w] || ""
      end
    end
  end
end
