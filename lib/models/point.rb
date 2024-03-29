class Point
  attr_accessor :x, :y, :dx, :dy

  def initialize(x, y, temporary = false)
    @x = x
    @y = y
    @dx = 0
    @dy = 0
    @temporary = temporary
  end

  def temporary?
    @temporary
  end

  def +(other)
    Point.new(0.5 * (@x + other.x), 0.5 * (@y + other.y))
  end

  #returns angle between vector |self other| and x axis
  def angle(other)
    l = Math.sqrt((@x - other.x)**2 + (@y - other.y)**2)

    if other.x >= @x
      return Math.acos((other.y - @y)/l)
    else
      return Math::PI + Math.acos((@y - other.y)/l)
    end
  end

  def moved_x
    @x + @dx
  end

  def moved_y
    @y + @dy
  end

  def change_delta(new_dx, new_dy)
    @dx = new_dx
    @dy = new_dy
  end

  def move
    @x += @dx
    @y += @dy
  end
end