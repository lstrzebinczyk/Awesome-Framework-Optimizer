module FrameworkMultigrid
  def select_new_points
    dividing_polygon = polygons.max_by{|poly| poly.energy(self.stiff)}

    @new_points << Line.new(dividing_polygon.p1, dividing_polygon.p2).midpoint
    @new_points << Line.new(dividing_polygon.p1, dividing_polygon.p3).midpoint
    @new_points << Line.new(dividing_polygon.p2, dividing_polygon.p3).midpoint

    @points += @new_points
    @points.each_index do |i|
      @points[i].id = i
    end

    return dividing_polygon.energy(self.stiff) > self.constants.energy_limit
  end
end