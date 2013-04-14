class Polygon
  class Presenter
    def initialize(polygon, framework)
      @polygon = polygon
      @framework = framework #oh god, why...
    end

    def draw_more_complicated
      draw(more_complicated_color)
    end

    def draw_less_complicated
      draw(less_complicated_color)
    end

    private

    def draw(color)
      draw_triangle_framework(@polygon.p1.x + @polygon.p1.dx, @polygon.p1.y + @polygon.p1.dy, 
                              @polygon.p2.x + @polygon.p2.dx, @polygon.p2.y + @polygon.p2.dy,
                              @polygon.p3.x + @polygon.p3.dx, @polygon.p3.y + @polygon.p3.dy, color)
    end

    def draw_triangle_framework(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, color)
      configuration.window.draw_triangle( configuration.translate + p1_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p1_y * configuration.scale), color, 
                                          configuration.translate + p2_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p2_y * configuration.scale), color,
                                          configuration.translate + p3_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p3_y * configuration.scale), color,
                                          0)
    end

    def more_complicated_color
      if @framework.max_energy > 1
        color = Gosu::Color.argb(255, 
        255 * @polygon.energy(@framework.stiff)/@framework.max_energy,
        255 * (1 - @polygon.energy(@framework.stiff)/@framework.max_energy), 0)
      elsif @framework.max_energy < 1 and @framework.max_energy > 0.1
        color = Gosu::Color.argb(255, 
        255 * @polygon.energy(@framework.stiff),
        255 * (1 - @polygon.energy(@framework.stiff)), 0)
      else
        color = Gosu::Color.argb(255, 
        2550 * @polygon.energy(@framework.stiff),
        255 * (1 - 10 * @polygon.energy(@framework.stiff)), 0)
      end
    end

    def less_complicated_color
      if @framework.max_goal > 1
        color = Gosu::Color.argb(255, 
        255 * (@polygon.deletion_goal(@framework.stiff)/@framework.max_goal),
        255 * (1 - @polygon.deletion_goal(@framework.stiff)/@framework.max_goal), 0)
      else
        color = Gosu::Color.argb(255, 
        255 * (@polygon.deletion_goal(@framework.stiff)),
        255 * (1 - @polygon.deletion_goal(@framework.stiff)), 0)
      end
    end

    def configuration
      @config ||= Configuration.global
    end
  end
end