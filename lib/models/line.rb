class Line
  attr_accessor :p1, :p2

  def initialize(p1, p2, helper = false)
    @p1 = p1
    @p2 = p2
  end

  def ==(other)
    (@p1 == other.p1 and @p2 == other.p2) or (@p2 == other.p2 and @p1 == other.p1)
  end

  def temporary?
    @p1.temporary? or @p2.temporary?
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
    @midpoint ||= (@p1 + @p2)
  end

  def length
    @length ||= Math.sqrt((@p1.x - @p2.x)**2 + (@p1.y - @p2.y)**2)
  end

  def stiff_matrix
    @stiff_matrix ||= begin
      cc = cos * cos / length
      cs = cos * sin / length
      ss = sin * sin / length

      [ 
        [ cc,  cs, -cc, -cs],
        [ cs,  ss, -cs, -ss],
        [-cc, -cs,  cc,  cs],
        [-cs, -ss,  cs,  ss]
      ]
    end
  end

  def draw
    Presenter.new(self).draw
  end
end