class Polygon
  class Presenter
    def initialize(polygon)
      @polygon = polygon
    end

    def draw_more_complicated
      draw(more_complicated_color)
    end

    def draw_less_complicated
      draw(less_complicated_color)
    end

    private

    def draw(color)
      draw_triangle_framework(@polygon.p1.moved_x, @polygon.p1.moved_y, 
                              @polygon.p2.moved_x, @polygon.p2.moved_y,
                              @polygon.p3.moved_x, @polygon.p3.moved_y, color)
    end

    def draw_triangle_framework(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, color)
      configuration.window.draw_triangle( configuration.translate + p1_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p1_y * configuration.scale), color, 
                                          configuration.translate + p2_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p2_y * configuration.scale), color,
                                          configuration.translate + p3_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p3_y * configuration.scale), color,
                                          0)
    end

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

    def configuration
      @config ||= Configuration.global
    end
  end
end