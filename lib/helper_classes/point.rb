class Point
  attr_accessor :id, :x, :y, :dx, :dy, :fx, :fy, :block_x, :block_y, :temporary

  def initialize(x, y, temporary = false)
    @id = nil
    @x = x
    @y = y
    @dx = 0
    @dy = 0
    @fx = 0
    @fy = 0
    @block_x = false
    @block_y = false
    @temporary = temporary
    self
  end

  def between_points(p1, p2, id)
    @id  = id
    @x   = 0.5 * (p1.x + p2.x)
    @y   = 0.5 * (p1.y + p2.y)
    @dx  = 0.5 * (p1.dx + p2.dx)
    @dy  = 0.5 * (p1.dy + p2.dy)
    @fx  = 0.5 * (p1.fx + p2.fx)
    @fy  = 0.5 * (p1.fy + p2.fy)
    @block_x = (p1.block_x and p2.block_x)
    @block_y = (p1.block_y and p2.block_y)
    self
  end

  def reset
    @dx = 0
    @dy = 0
    @fx = 0
    @fy = 0
    @block_x = false
    @block_y = false
  end

  def block
    @block_x = true
    @block_y = true
  end

  def set_block_x
    @block_x = true
  end

  def force(fx, fy)
    @fx = fx
    @fy = fy
  end

  def change_delta(new_dx, new_dy)
    @dx = new_dx
    @dy = new_dy
  end

  def move
    @x += @dx
    @y += @dy
  end

  def draw(picture)
    if self.block_x and self.block_y
      picture.stroke('red')
      picture.stroke_width(0.01)
      picture.fill_opacity(0)
      picture.circle(x, y, x + 0.03, y)
    end
  end
end