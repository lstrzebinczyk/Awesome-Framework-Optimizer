class DummyLine
  attr_reader :x1, :y1, :c1, :x2, :y2, :c2

  def initialize(x1, y1, c1, x2, y2, c2)
    @x1 = x1
    @y1 = y1
    @c1 = c1
    @x2 = x2
    @y2 = y2
    @c2 = c2
  end
end

class DummyWindow
  def draw_line(x1, y1, c1, x2, y2, c2)
    lines << DummyLine.new(x1, y1, c1, x2, y2, c2)
  end

  def lines
    @lines ||= []
  end
end