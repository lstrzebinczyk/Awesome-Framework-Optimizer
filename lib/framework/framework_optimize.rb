module FrameworkOptimize

  def optimize
    poly = find_smelly_polygon
    remove_polygon(poly)
    self.reload
    self.FEM_solve
    return self.goal
  end

  def find_smelly_polygon
    self.polygons.max_by{|polygon| polygon.deletion_goal(self.stiff)}
  end

  def remove_polygon(poly)
    polygons.delete(poly)
    delete_line(poly.p1, poly.p2) if delete_line?(poly.p1, poly.p2)
    delete_line(poly.p3, poly.p2) if delete_line?(poly.p3, poly.p2)
    delete_line(poly.p1, poly.p3) if delete_line?(poly.p1, poly.p3)
    delete_point poly.p1 if delete_point?(poly.p1)
    delete_point poly.p2 if delete_point?(poly.p2)
    delete_point poly.p3 if delete_point?(poly.p3)
  end

  def has_point?(point)
    self.polygons.any? {|poly| poly.has_point?(point)}
  end

  def has_line?(point1, point2)
    self.polygons.any? {|poly| poly.has_line?(point1, point2)}
  end

  def delete_point?(point)
    not has_point? point
  end

  def delete_line?(p1, p2)
    not has_line?(p1, p2)
  end

  def delete_line(p1, p2)
    lines.delete_if{|line| (line.p1 == p1 and line.p2 == p2) or (line.p1 == p2 and line.p2 == p1)}
  end

  def delete_point(p1)
    points.delete p1
  end
end