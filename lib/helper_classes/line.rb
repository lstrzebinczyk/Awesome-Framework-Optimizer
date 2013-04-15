class Line
  attr_accessor :p1, :p2

  def initialize(p1, p2, helper = false)
    if helper or p1.id > p2.id #whyyyyyy, oh, god, whyyyy
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

  def cos
    @cos ||= (@p2.x - @p1.x) / length
  end

  def sin
    @sin ||= (@p2.y - @p1.y) / length
  end

  def midpoint
    @midpoint ||= (@p1 + @p2).tap do |point|
      point.id = 0
    end
  end

  def length
    @length ||= Math.sqrt((@p1.x - @p2.x)**2 + (@p1.y - @p2.y)**2)
  end

  def draw
    Presenter.new(self).draw
  end
end