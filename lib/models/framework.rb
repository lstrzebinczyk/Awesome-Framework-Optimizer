class Framework
  attr_accessor :points, :lines, :polygons, :stiff, :constants, :max_energy

  def stiff_matrix
    FemEquation::StiffMatrix.new(self)
  end

  def config
    @configuration = Configuration.global
  end

  def draw_empty
    Presenter.new(self).draw_empty
  end

  def draw_status_1
    Presenter.new(self).draw_status_1
  end

  def draw_status_2
    Presenter.new(self).draw_status_2
  end

  def select_new_points
    dividing_polygon = polygons.max_by{|poly| poly.energy(self.stiff)}
    @max_energy = dividing_polygon.energy(self.stiff)
    @new_points += dividing_polygon.dividing_points
    @points += @new_points

    @points.each_index do |i|
      @points[i].id = i
    end

    return dividing_polygon.energy(self.stiff) > self.constants.energy_limit
  end

  def optimize
    poly = polygons.max_by{|polygon| polygon.deletion_goal(self.stiff)}
    remove_polygon(poly)
    self.reload

    deltas = FemEquation::Solver.new(self.stiff_matrix, self.force_vector).solve
    update_points_with_deltas(deltas)

    return self.goal
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

  def delete_point?(point)
    polygons.none?{|poly| poly.has_point?(point)}
  end

  def delete_line?(p1, p2)
    polygons.none?{|poly| poly.has_line?(p1, p2)}
  end

  def delete_line(p1, p2)
    lines.delete_if{|line| (line.p1 == p1 and line.p2 == p2) or (line.p1 == p2 and line.p2 == p1)}
  end

  def delete_point(p1)
    points.delete p1
  end

  def initialize
    @points = []

    @points << Point.new(0, 0)
    @points << Point.new(10, 0)
    @points << Point.new(15, 0)
    @points << Point.new(0, 30)
    @points << Point.new(10, 30)
    @points << Point.new(15, 30)
    @points << Point.new(8, 14)
    @points << Point.new(15, 14)
    @points << Point.new(15, 10)
    @points << Point.new(8, 10)

    @lines = []
    @polygons = []
    @stiff = config.stiff
    @constants = config
    @new_points = []

    @force = Force.new(Point.new(10, 30), Point.new(15, 30), @constants.force)

    self.reload
    
    self
  end

  def force_vector
    affected_points_count = points.count{|pt| @force.include?(pt) }
    points.map{|pt| @force.include?(pt) ? [0, @force.value/affected_points_count] : [0, 0] }.flatten
  end

  def in_forbidden_area?(point)
    point.x > 8 and point.x <= 15 and point.y > 10 and point.y < 14
  end

  def make_denser
    self.perform_triangulation
    self.reload

    deltas = FemEquation::Solver.new(self.stiff_matrix, self.force_vector).solve
    update_points_with_deltas(deltas)

    select_new_points
  end

  def perform_triangulation
    if @new_points.empty?
      #performs basic delaunay triangulation using Bowyer-Watson Algorithm
      in_big_triangle do
        points.each do |point|
          triangulate_point(point) unless point.temporary?
        end
      end
    else
      @new_points.each do |point|
        triangulate_point(point)
      end
      @new_points =  []
    end
    #TODO Change way of using holes so it may use any holes anywhere
    lines.delete_if{|line| in_forbidden_area?(line.midpoint)}
    polygons.delete_if{|polygon| in_forbidden_area?(polygon.midpoint)}

    #performs mesh refinement using ruppert algorith
    loop do
      max_angle_cos = constants.max_angle_cos
      polygon_array = []

      polygons.each do |poly|
        polygon_array << poly if poly.good_for_refining?(max_angle_cos, constants.min_field, constants.max_field)
      end

      polygon_to_divide = polygon_array.max_by{|poly| poly.cosine}

      unless polygon_to_divide.nil?
        potential_new_point = polygon_to_divide.circle.middle
          # self.draw
          if self.includes_point?(potential_new_point)
            new_point = potential_new_point
          elsif self.includes_point?(polygon_to_divide.mid_of_longest_side)
            new_point = polygon_to_divide.mid_of_longest_side
          end

          unless new_point == nil
            new_point.id = points.length
            points << new_point
            triangulate_point(new_point)
          end
      else
        break
      end
    end
  end

  def update_points_with_deltas(deltas)
    points.each_with_index do |point, i|
      point.change_delta(deltas[2 * i], deltas[2 * i + 1])
    end
  end

  #resets data in points
  def reload
    #reset force put to points
    points_to_block = []
    points_to_x_block = []

    points.each_index do |i|
      points[i].reset
      points[i].id = i
      points_to_block << points[i] if points[i].y == 0 and points[i].x >= 10 and points[i].x <= 20
      points_to_x_block << points[i] if points[i].x == 15
    end

    points_to_block.each do |pt|
      pt.block
    end

    points_to_x_block.each do |pt|
      # puts "#{pt.x} + #{pt.y}"
      pt.set_block_x
    end
  end
            
  def goal
    self.field * self.displacement
  end

  def displacement
    (self.points.min_by{|pt| pt.dy}).dy.abs
  end

  def field
    polygons.map(&:field).inject(:+)
  end

  #TODO
  #Poprawić w oparciu o proste brzegowe
  def includes_point?(point)
    answer = false

    polygons.each do |polygon|
      if polygon.include?(point)
        answer = true
        break
      end
    end

    if answer == true and in_forbidden_area?(point)
      answer = false
    end

    return answer
  end

  def triangulate_point(point)
    list_of_polygons = find_all_polygons_including(point)
    list_of_points = delete_polygons(list_of_polygons)
    ccw_sort(list_of_points, point)
    create_polygons(list_of_points, point)
  end

  def find_all_polygons_including(point)
    list_of_polygons = []

    polygons.each do |polygon|
      list_of_polygons << polygon if polygon.circle.include?(point)
    end

    list_of_polygons
  end

  def delete_polygons(list_of_polygons)
    list_of_points = []

    list_of_polygons.each do |polygon|
      list_of_points << polygon.p1
      list_of_points << polygon.p2
      list_of_points << polygon.p3
    end

    list_of_points.uniq!

    list_of_lines_to_delete = []
    list_of_polygons.each do |polygon|
      list_of_lines_to_delete << [polygon.p1, polygon.p2]
      list_of_lines_to_delete << [polygon.p2, polygon.p3]
      list_of_lines_to_delete << [polygon.p3, polygon.p1]
    end

    list_of_lines_to_delete.each do |pair|
      pair[0], pair[1] = pair[1], pair[0] if pair[0].id < pair[1].id
    end

    list_of_lines_to_delete.uniq!

    lines.delete_if {|elem| list_of_lines_to_delete.include?([elem.p1, elem.p2]) }
    polygons.delete_if {|elem| list_of_polygons.include?(elem)}

    return list_of_points
  end

  #counterclockwise sort
  def ccw_sort(list_of_points, point)
    begin
      list_of_points.sort_by! {|pt| pt.angle(point)}
    rescue Exception => e
      puts e.message
      puts "[ERROR] Error in ccw sort"
      puts "[ERROR] #{list_of_points}"
    end
  end

  #list_of_points should be translate(wypukły) and counterclockwise
  def create_polygons(list_of_points, point)
    list_of_points.each_index do |i|
      p1 = list_of_points[i]
      p2 = list_of_points[(i+1) % list_of_points.length]

      new_polygon = Polygon.new(p1, p2, point)
      
      if new_polygon.field > 0.0001
        polygons << new_polygon
        lines << Line.new(p1, p2)
      end
      
      lines << Line.new(p2, point)
    end
  end

  def in_big_triangle
    #ADDING TRIANGLE BIG ENOUGH TO CONTAIN ALL THE WORLD

    #find rectangle enclosing points
    max_x = points[0].x
    min_x = points[0].x
    max_y = points[0].y
    min_y = points[0].y

    points.each do |pt|
      max_x = pt.x if pt.x > max_x
      min_x = pt.x if pt.x < min_x
      max_y = pt.y if pt.y > max_y
      min_y = pt.y if pt.y < min_y
    end

    #find circle enclosing points
    circle_mid_x = 0.5 * (min_x + max_x)
    circle_mid_y = 0.5 * (min_y + max_y)
    #circle = [circle_mid_x, circle_mid_y, min_x, min_y]

    #find triangle enclosing points
    cr = 2 * Math.sqrt((circle_mid_x - min_x)**2 + (circle_mid_y - min_y)**2)
    pt1 = Point.new(circle_mid_x, circle_mid_y + cr + 1, true)
    pt2 = Point.new(circle_mid_x + 0.5*Math.sqrt(3)*cr + 1, circle_mid_y - 0.5 * cr - 1, true)
    pt3 = Point.new(circle_mid_x - 0.5*Math.sqrt(3)*cr - 1, circle_mid_y - 0.5 * cr - 1, true)

    points << pt1
    points << pt2
    points << pt3

    points.each_index do |i|
      points[i].id = i
    end

    lines << Line.new(pt1, pt2)
    lines << Line.new(pt2, pt3)
    lines << Line.new(pt3, pt1)

    polygons << Polygon.new(pt1, pt2, pt3)


    yield

    #REMOVING THE BIG TRIANGLE
    points.delete_if {|pt| pt.temporary? }
    lines.delete_if {|line| line.temporary? }
    polygons.delete_if{|polygon| polygon.temporary? }
  end
end