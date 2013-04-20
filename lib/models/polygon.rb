class Polygon
  attr_accessor :p1, :p2, :p3, :cosine, :energy, :deletion_goal, :circle, :midpoint, :field, :line_1, :line_2, :line_3

  def draw_more_complicated
    Presenter.new(self).draw_more_complicated
  end

  def draw_less_complicated
    Presenter.new(self).draw_less_complicated
  end

  def initialize(p1, p2, p3)
    #Initialized in such way that points are stored in counterclockwise order

    if ccw_points?(p1, p2, p3)
      @p1 = p1
      @p2 = p2
      @p3 = p3
    else
      @p1 = p1
      @p2 = p3
      @p3 = p2
    end

    @line_1 = Line.new(@p1, @p2, true)
    @line_2 = Line.new(@p1, @p3, true)
    @line_3 = Line.new(@p3, @p2, true)

    @cosine = smallest_angle_cos
    @energy = nil
    @deletion_goal = nil
    @midpoint = Point.new((p1.x + p2.x + p3.x)/3.0, (p1.y + p2.y + p3.y)/3.0)
    @field = Field.new(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y).to_f

    @circle = Circle.new(self)
  end

  def temporary?
    @p1.temporary? or @p2.temporary? or @p3.temporary?
  end

  def dividing_points
    [@p1 + @p2, @p1 + @p3, @p2 + @p3]
  end

  def stiff_matrix(stiff)
    @stiff_matrix ||= begin
      StiffMatrix.new(stiff).tap do |matrix|
        matrix.insert(@line_1, [0, 1, 2, 3])
        matrix.insert(@line_2, [0, 1, 4, 5])
        matrix.insert(@line_3, [2, 3, 4, 5])
      end
    end
  end

  def smallest_angle_cos
    v12 = [p2.x - p1.x, p2.y - p1.y]
    v13 = [p3.x - p1.x, p3.y - p1.y]
    v23 = [p3.x - p2.x, p3.y - p2.y]
    nv12 = Math.sqrt(v12[0]*v12[0] + v12[1]*v12[1])
    nv13 = Math.sqrt(v13[0]*v13[0] + v13[1]*v13[1])
    nv23 = Math.sqrt(v23[0]*v23[0] + v23[1]*v23[1])
    cos_a = (v12[0]*v13[0] + v12[1]*v13[1])/(nv12*nv13)
    cos_b = (-v12[0]*v23[0] - v12[1]*v23[1])/(nv12*nv23)
    cos_c = (v23[0]*v13[0] + v23[1]*v13[1])/(nv23*nv13)

    return [cos_a, cos_b, cos_c].max
  end

  def include?(point)
    ccw_points?(p1, p2, point) and ccw_points?(p2, p3, point) and ccw_points?(p3, p1, point)
  end

  def has_point?(point)
    (p1 == point) or (p2 == point) or (p3 == point)
  end

  def has_line?(pt1, pt2)
    [@p1, @p2, @p3].include?(pt1) and [@p1, @p2, @p3].include?(pt2)
  end

  def ccw_points?(p1, p2, p3)
    (p2.x - p1.x)*(p3.y - p1.y) - (p3.x - p1.x)*(p2.y - p1.y)  > -0.0001
  end

  def mid_of_longest_side
    [@line_1, @line_2, @line_3].max_by{|line| line.length }.midpoint
  end

  def tension
    (1.0 - moved_field/field).abs
  end

  def deletion_goal(stiff)
    @field / (1 + energy(stiff))
  end

  def good_for_refining?(max_cosine, min_field, max_field)
    (@cosine > max_cosine and @field > min_field) or @field > max_field
  end

  def energy(stiff)
    0.5 * stiff_matrix(stiff).scalar(displacement)
  end

  def displacement
    Vector.new([@p1.dx, @p1.dy, @p2.dx, @p2.dy, @p3.dx, @p3.dy])
  end

  private

  def moved_field
    Field.new(p1.moved_x, p1.moved_y, p2.moved_x, p2.moved_y, p3.moved_x, p3.moved_y).to_f
  end
end