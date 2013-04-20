class Boundary
  attr_reader :value

  def initialize(p1, p2, value = nil)
    @p1 = p1
    @p2 = p2
    @value = value

    @bounding_x = [p1.x, p2.x].sort
    @bounding_y = [p1.y, p2.y].sort
  end

  def include?(point)
    field_is_zero?(point) and inside_box?(point)
  end

  private

  def inside_box?(point)
    point.x >= @bounding_x.first and point.x <= @bounding_x.last and point.y >= @bounding_y.first and point.y <= @bounding_y.last
  end

  def field_is_zero?(point)
    Polygon::Field.new(@p1.x, @p1.y, @p2.x, @p2.y, point.x, point.y).to_f.zero?
  end
end