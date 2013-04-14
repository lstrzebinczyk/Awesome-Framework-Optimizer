class Line
  attr_accessor :p1, :p2

  def initialize(p1, p2)
    if p1.id > p2.id #whyyyyyy
      @p1 = p1
      @p2 = p2
    else
      @p1 = p2
      @p2 = p1
    end
  end

  def inside_circle?(point)
    Line.new(midpoint, @p1).length > Line.new(midpoint, point).length
  end

  def midpoint
    @midpoint ||= Point.new(0.5 * (p1.x + p2.x), 0.5 * (p1.y + p2.y)).tap do |point|
      point.id = 0
    end
  end

  def length
    Math.sqrt((p1.x - p2.x)**2 + (p1.y - p2.y)**2)
  end

  def draw
    Presenter.new(self).draw
  end
end