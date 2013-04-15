class Polygon
  attr_accessor :p1, :p2, :p3, :cosine, :energy, :deletion_goal, :circle, :midpoint, :field

  def draw_more_complicated(framework)
    Presenter.new(self, framework).draw_more_complicated
  end

  def draw_less_complicated(framework)
    Presenter.new(self, framework).draw_less_complicated
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

    @cosine = self.smallest_angle_cos
    @energy = nil
    @deletion_goal = nil
    @midpoint = Point.new((p1.x + p2.x + p3.x)/3.0, (p1.y + p2.y + p3.y)/3.0)
    @field = Field.new(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y).to_f

    @circle = Circle.new(self)
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
    [self.p1, self.p2, self.p3].include?(pt1) and [self.p1, self.p2, self.p3].include?(pt2)
  end

  def ccw_points?(p1, p2, p3)
    (p2.x - p1.x)*(p3.y - p1.y) - (p3.x - p1.x)*(p2.y - p1.y)  > -0.0001
  end

  def mid_of_longest_side
    side_1 = Math.sqrt((p1.x - p2.x)**2 + (p1.y - p2.y)**2)
    side_2 = Math.sqrt((p1.x - p3.x)**2 + (p1.y - p3.y)**2)
    side_3 = Math.sqrt((p3.x - p2.x)**2 + (p3.y - p2.y)**2)

    if side_1 > side_2
      if side_1 > side_3
        return Point.new(0.5 * (p1.x + p2.x), 0.5 * (p1.y + p2.y))
      else
        return Point.new(0.5 * (p3.x + p2.x), 0.5 * (p3.y + p2.y))
      end
    else
      if side_2 > side_3
        return Point.new(0.5 * (p3.x + p1.x), 0.5 * (p3.y + p1.y))
      else
        return Point.new(0.5 * (p3.x + p2.x), 0.5 * (p3.y + p2.y))
      end
    end
  end

  def tension
    (1.0 - moved_field/field).abs
  end

  def deletion_goal(stiff)
    @deletion_goal ||= self.field / (1 + self.energy(stiff))
  end

  def good_for_refining?(max_cosine, min_field, max_field)
    c = self.cosine
    field = self.field

    if (c > max_cosine and field > min_field) or field > max_field
      return true
    else
      return false
    end
  end

  def energy(stiff)
    if @energy.nil?
      matrix = [[0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0]]

      p1 = self.p1
      p2 = self.p2
      p3 = self.p3

      length = Math.sqrt((p1.x - p2.x)**2 + (p1.y - p2.y)**2)
      cos = (p2.x - p1.x) / length
      sin = (p2.y - p1.y) / length

      matrix[0][0] +=  stiff * cos * cos / length
      matrix[0][1] +=  stiff * cos * sin / length
      matrix[0][2] += -stiff * cos * cos / length
      matrix[0][3] += -stiff * cos * sin / length

      matrix[1][0] +=  stiff * cos * sin / length
      matrix[1][1] +=  stiff * sin * sin / length
      matrix[1][2] += -stiff * cos * sin / length
      matrix[1][3] += -stiff * sin * sin / length

      matrix[2][0] += -stiff * cos * cos / length
      matrix[2][1] += -stiff * cos * sin / length
      matrix[2][2] +=  stiff * cos * cos / length
      matrix[2][3] +=  stiff * cos * sin / length

      matrix[3][0] += -stiff * cos * sin / length
      matrix[3][1] += -stiff * sin * sin / length
      matrix[3][2] +=  stiff * cos * sin / length
      matrix[3][3] +=  stiff * sin * sin / length

      
      length = Math.sqrt((p1.x - p3.x)**2 + (p1.y - p3.y)**2)
      cos = (p3.x - p1.x) / length
      sin = (p3.y - p1.y) / length

      matrix[0][0] +=  stiff * cos * cos / length
      matrix[0][1] +=  stiff * cos * sin / length
      matrix[0][4] += -stiff * cos * cos / length
      matrix[0][5] += -stiff * cos * sin / length

      matrix[1][0] +=  stiff * cos * sin / length
      matrix[1][1] +=  stiff * sin * sin / length
      matrix[1][4] += -stiff * cos * sin / length
      matrix[1][5] += -stiff * sin * sin / length

      matrix[4][0] += -stiff * cos * cos / length
      matrix[4][1] += -stiff * cos * sin / length
      matrix[4][4] +=  stiff * cos * cos / length
      matrix[4][5] +=  stiff * cos * sin / length

      matrix[5][0] += -stiff * cos * sin / length
      matrix[5][1] += -stiff * sin * sin / length
      matrix[5][4] +=  stiff * cos * sin / length
      matrix[5][5] +=  stiff * sin * sin / length

      length = Math.sqrt((p2.x - p3.x)**2 + (p2.y - p3.y)**2)
      cos = (p3.x - p2.x) / length
      sin = (p3.y - p2.y) / length

      matrix[2][2] +=  stiff * cos * cos / length
      matrix[2][3] +=  stiff * cos * sin / length
      matrix[2][4] += -stiff * cos * cos / length
      matrix[2][5] += -stiff * cos * sin / length

      matrix[3][2] +=  stiff * cos * sin / length
      matrix[3][3] +=  stiff * sin * sin / length
      matrix[3][4] += -stiff * cos * sin / length
      matrix[3][5] += -stiff * sin * sin / length

      matrix[4][2] += -stiff * cos * cos / length
      matrix[4][3] += -stiff * cos * sin / length
      matrix[4][4] +=  stiff * cos * cos / length
      matrix[4][5] +=  stiff * cos * sin / length

      matrix[5][2] += -stiff * cos * sin / length
      matrix[5][3] += -stiff * sin * sin / length
      matrix[5][4] +=  stiff * cos * sin / length
      matrix[5][5] +=  stiff * sin * sin / length

      dv = [p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy]
      helper_vector = [scalar_sum(dv, matrix[0]),
                       scalar_sum(dv, matrix[1]),
                       scalar_sum(dv, matrix[2]),
                       scalar_sum(dv, matrix[3]),
                       scalar_sum(dv, matrix[4]),
                       scalar_sum(dv, matrix[5])]

      @energy = 0.5 * scalar_sum(dv, helper_vector)
      return @energy
    else
      return @energy
    end
  end

  def scalar_sum(v1, v2)
    sum = 0
      v1.each_index do |i|
        sum += v1[i]*v2[i]
      end
    sum
  end

  private

  def moved_field
    Field.new(p1.moved_x, p1.moved_y, p2.moved_x, p2.moved_y, p3.moved_x, p3.moved_y).to_f
  end
end