require "narray"

module FrameworkTriangulation

  #Bowyer-Watson Algorithm
  def basic_triangulation
    self.add_big_triangle

    points.each do |point|
      triangulate_point(point) unless point.temporary
    end

    self.remove_big_triangle

    #TODO Change way of using holes so it may use any holes anywhere
    lines.delete_if{|line| line.midpoint.x > 8 and line.midpoint.x < 22 and line.midpoint.y > 10 and line.midpoint.y < 14}
    polygons.delete_if{|polygon| polygon.midpoint.x > 8 and polygon.midpoint.x < 22 and polygon.midpoint.y > 10 and polygon.midpoint.y < 14}
  end

  def triangulate_new_points
    @new_points.each do |point|
      triangulate_point(point)
    end

    @new_points =  []

    lines.delete_if{|line| line.midpoint.x > 8 and line.midpoint.x < 22 and line.midpoint.y > 10 and line.midpoint.y < 14}
    polygons.delete_if{|polygon| polygon.midpoint.x > 8 and polygon.midpoint.x < 22 and polygon.midpoint.y > 10 and polygon.midpoint.y < 14}
  end

  def ruppert_refinement
    while true
      max_angle_cos = constants.max_angle_cos
      polygon_array = []

      polygons.each do |poly|
        polygon_array << poly if poly.good_for_refining?(max_angle_cos, constants.min_field, constants.max_field)
      end

      polygon_to_divide = polygon_array.max_by{|poly| poly.cosine}

      unless polygon_to_divide.nil?
        potential_new_point = polygon_to_divide.mid_of_circle
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

        # self.draw if debug
    end
  end

  def line_circle_contain_any_point(line)
    points.each do |point|
      if point != line.p1 and point != line.p2
        if line.inside_circle?(point)
          return true
          break
        end
      end
    end

    return false
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

    if answer == true and point.x > 8 and point.x < 22 and point.y > 10 and point.y < 14
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
      list_of_polygons << polygon if polygon.inside_circumcircle?(point)
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
      list_of_points.sort_by! {|pt| angle(pt, point)}
    rescue Exception => e
      puts e.message
      puts "[ERROR] Error in ccw sort"
      puts "[ERROR] #{list_of_points}"
    end
  end

  #returns angle between vector |p2 p1| and x axis
  def angle(p1, p2)
    l = Math.sqrt((p1.x - p2.x)**2 + (p1.y - p2.y)**2)

    if p2.x >= p1.x
      return Math.acos((p2.y - p1.y)/l)
    else
      return Math::PI + Math.acos((p1.y - p2.y)/l)
    end
  end

  def ccw_points?(p1, p2, p3)
    (p2.x - p1.x)*(p3.y - p1.y) - (p3.x - p1.x)*(p2.y - p1.y) > -0.001
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


  def remove_big_triangle
    lines.delete_if {|line| line.p1.temporary or line.p2.temporary}
    polygons.delete_if{|polygon| polygon.p1.temporary or polygon.p2.temporary or polygon.p3.temporary}
    points.delete_if {|pt| pt.temporary}
  end

  def add_big_triangle
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
  end
end