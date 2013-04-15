class Polygon
  class Field
    def initialize(x1, y1, x2, y2, x3, y3)
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
      @x3 = x3
      @y3 = y3
    end

    def to_f
      0.5 * (@x1*@y2 + @x2*@y3 + @x3*@y1 - @x3*@y2 - @x1*@y3 - @x2*@y1).abs
    end
  end
end