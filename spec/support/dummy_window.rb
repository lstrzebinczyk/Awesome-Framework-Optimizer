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

class DummyQuad
  attr_reader :x1, :y1, :c1, :x2, :y2, :c2, :x3, :y3, :c3, :x4, :y4, :c4

  def initialize(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4)
    @x1 = x1
    @y1 = y1
    @c1 = c1
    @x2 = x2
    @y2 = y2
    @c2 = c2
    @x3 = x3
    @y3 = y3
    @c3 = c3
    @x4 = x4
    @y4 = y4
    @c4 = c4
  end
end

class DummyWindow
  def draw_line(x1, y1, c1, x2, y2, c2)
    lines << DummyLine.new(x1, y1, c1, x2, y2, c2)
  end

  def draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4)
    quads << DummyQuad.new(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4)
  end

  def quads
    @quads ||= []
  end

  def lines
    @lines ||= []
  end
end