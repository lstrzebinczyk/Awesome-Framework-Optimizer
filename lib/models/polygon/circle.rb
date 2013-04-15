class Polygon
  class Circle
    attr_accessor :middle, :radius

    # Middle of circumcircle of a triangle is given in such point (Dx, Dy), that
    # [a, b]   [Dx]    [e]
    # [c, d] * [Dy] == [f]
    def initialize(polygon)
      a = 2 * (polygon.p2.x - polygon.p1.x)
      b = 2 * (polygon.p2.y - polygon.p1.y)
      c = 2 * (polygon.p2.x - polygon.p3.x)
      d = 2 * (polygon.p2.y - polygon.p3.y)
      e = polygon.p2.x*polygon.p2.x + polygon.p2.y*polygon.p2.y - polygon.p1.x*polygon.p1.x - polygon.p1.y*polygon.p1.y
      f = polygon.p2.x*polygon.p2.x + polygon.p2.y*polygon.p2.y - polygon.p3.x*polygon.p3.x - polygon.p3.y*polygon.p3.y
      
      det = a*d - b*c

      x = (d*e - b*f)/det
      y = (a*f - c*e)/det
      r = Math.sqrt((polygon.p1.x - x)**2 + (polygon.p1.y - y)**2)
      
      @middle = Point.new(x, y)
      @radius = r
    end

    #Method determines if given point is inside a circumcircle of a poligon
    #returns true or false, determined by determinant of matrix
    # | var1 var2 var3 |
    # | var4 var5 var6 |, det > 0 means true, point is inside
    # | var7 var8 var9 |
    def include?(point)
      Math.sqrt((point.x - @middle.x)**2 + (point.y - @middle.y)**2) <= @radius
    end
  end
end