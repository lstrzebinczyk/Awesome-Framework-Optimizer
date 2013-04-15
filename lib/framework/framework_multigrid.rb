module FrameworkMultigrid
  def select_new_points
    dividing_polygon = polygons.max_by{|poly| poly.energy(self.stiff)}

    @new_points += dividing_polygon.dividing_points

    @points += @new_points

    @points.each_index do |i|
      @points[i].id = i
    end

    return dividing_polygon.energy(self.stiff) > self.constants.energy_limit
  end
end