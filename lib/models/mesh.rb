class Mesh
  attr_accessor :points, :lines, :polygons, :max_energy

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

    @new_points = []
  end

  def index_of(point)
    @points.index(point)
  end

  def update_points_with_deltas(deltas)
    @points.each_with_index do |point, i|
      point.change_delta(deltas[2 * i], deltas[2 * i + 1])
    end
  end

  def select_new_points
    dividing_polygon = @polygons.max_by{|poly| poly.energy(config.stiff)}
    @max_energy = dividing_polygon.energy(config.stiff)
    @new_points += dividing_polygon.dividing_points
    @points += @new_points

    return dividing_polygon.energy(config.stiff) > config.energy_limit
  end

  def perform_triangulation
    if @new_points.empty?
      #performs basic delaunay triangulation using Bowyer-Watson Algorithm
      in_big_triangle do
        @points.each do |point|
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
    @lines.delete_if{|line| in_forbidden_area?(line.midpoint)}
    @polygons.delete_if{|polygon| in_forbidden_area?(polygon.midpoint)}

    #performs mesh refinement using ruppert algorith
    loop do
      max_angle_cos = config.max_angle_cos
      polygon_array = []

      @polygons.each do |poly|
        polygon_array << poly if poly.good_for_refining?(max_angle_cos, config.min_field, config.max_field)
      end

      polygon_to_divide = polygon_array.max_by{|poly| poly.cosine}

      unless polygon_to_divide.nil?
        potential_new_point = polygon_to_divide.circle.middle
          # self.draw
          if include?(potential_new_point)
            new_point = potential_new_point
          elsif include?(polygon_to_divide.mid_of_longest_side)
            new_point = polygon_to_divide.mid_of_longest_side
          end

          unless new_point == nil
            @points << new_point
            triangulate_point(new_point)
          end
      else
        break
      end
    end
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

  def field
    @polygons.map(&:field).inject(:+)
  end
  
  private

  def delete_point?(point)
    polygons.none?{|poly| poly.has_point?(point)}
  end

  def delete_line?(p1, p2)
    polygons.none?{|poly| poly.has_line?(p1, p2)}
  end

  def delete_line(p1, p2)
    lines.delete_if{|line| line == Line.new(p1, p2)}
  end

  def delete_point(p1)
    points.delete p1
  end

  def include?(point)
    @polygons.any?{|poly| poly.include?(point) } and not in_forbidden_area?(point)
  end

  def config
    Configuration.global
  end

  def in_forbidden_area?(point)
    point.x > 8 and point.x <= 15 and point.y > 10 and point.y < 14
  end
  
  #list_of_points should be translate(wypukły) and counterclockwise
  def create_polygons(list_of_points, point)
    list_of_points.each_index do |i|
      p1 = list_of_points[i]
      p2 = list_of_points[(i+1) % list_of_points.length]

      new_polygon = Polygon.new(p1, p2, point)
      
      if new_polygon.field > 0.0001
        @polygons << new_polygon
        @lines << Line.new(p1, p2)
      end
      
      @lines << Line.new(p2, point)
    end
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
      list_of_lines_to_delete << polygon.line_1
      list_of_lines_to_delete << polygon.line_2
      list_of_lines_to_delete << polygon.line_3
    end

    list_of_lines_to_delete.uniq!

    @lines.delete_if {|elem| list_of_lines_to_delete.include?(elem) }
    @polygons.delete_if {|elem| list_of_polygons.include?(elem)}

    return list_of_points
  end

  def triangulate_point(point)
    list_of_polygons = @polygons.find_all{|poly| poly.circle.include?(point) }
    list_of_points = delete_polygons(list_of_polygons)
    ccw_sort(list_of_points, point)
    create_polygons(list_of_points, point)
  end

  def in_big_triangle
    #ADDING TRIANGLE BIG ENOUGH TO CONTAIN ALL THE WORLD

    #find rectangle enclosing points
    max_x = @points[0].x
    min_x = @points[0].x
    max_y = @points[0].y
    min_y = @points[0].y

    @points.each do |pt|
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

    @points << pt1
    @points << pt2
    @points << pt3

    @lines << Line.new(pt1, pt2)
    @lines << Line.new(pt2, pt3)
    @lines << Line.new(pt3, pt1)

    @polygons << Polygon.new(pt1, pt2, pt3)

    yield

    #REMOVING THE BIG TRIANGLE
    @points.delete_if {|pt| pt.temporary? }
    @lines.delete_if {|line| line.temporary? }
    @polygons.delete_if{|polygon| polygon.temporary? }
  end
end