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
end