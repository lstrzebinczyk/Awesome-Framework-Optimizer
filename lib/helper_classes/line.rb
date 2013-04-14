class Line
  attr_accessor :p1, :p2, :to_delete

  def initialize(p1, p2)
    if p1.id > p2.id
      @p1 = p1
      @p2 = p2
      @to_delete = false
    else
      @p1 = p2
      @p2 = p1
      @to_delete = false
    end
  end

  def inside_circle?(point)
    mid = self.midpoint
    mid.id = 0
    return true if Line.new(mid, self.p1).length - Line.new(mid, point).length > -0.0001
  end

  def to_s
    "Line from [#{p1.x}, #{@p1.y}] to [#{p2.x}, #{@p2.y}]"
  end

  def midpoint
    Point.new(0.5 * (p1.x + p2.x), 0.5 * (p1.y + p2.y))
  end

  def length
    Math.sqrt((p1.x - p2.x)**2 + (p1.y - p2.y)**2)
  end

  def draw
    Presenter.new(self).draw
  end
end