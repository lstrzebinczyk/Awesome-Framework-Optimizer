class Polygon
  class Presenter < Presenter
    def initialize(polygon)
      @polygon = polygon
    end

    def draw_more_complicated
      draw_triangle(@polygon.p1.moved_x, @polygon.p1.moved_y, 
                    @polygon.p2.moved_x, @polygon.p2.moved_y,
                    @polygon.p3.moved_x, @polygon.p3.moved_y, more_complicated_color)
    end

    def draw_less_complicated
      draw_triangle(@polygon.p1.moved_x, @polygon.p1.moved_y, 
                    @polygon.p2.moved_x, @polygon.p2.moved_y,
                    @polygon.p3.moved_x, @polygon.p3.moved_y, less_complicated_color)
    end

    private

    def more_complicated_color
      num = scale(@polygon.energy(configuration.stiff))
      Gosu::Color.argb(255, 255 * num, 255 * (1 - num), 0)
    end

    def less_complicated_color
      num = scale(@polygon.deletion_goal(configuration.stiff))
      Gosu::Color.argb(255, 255 * num, 255 * (1 - num), 0)
    end

    private

    def scale(number)
      number**0.5
    end
  end
end