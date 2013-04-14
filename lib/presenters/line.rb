class Line
  class Presenter
    def initialize(line)
      @line = line
    end

    def draw
      draw_line_framework(@line.p1.x + @line.p1.dx, @line.p1.y + @line.p1.dy,
                          @line.p2.x + @line.p2.dx, @line.p2.y + @line.p2.dy)
    end

    private

    def draw_line_framework(p1_x, p1_y, p2_x, p2_y)
      configuration.window.draw_line(
        configuration.translate + p1_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p1_y * configuration.scale), 0xff000000, 
        configuration.translate + p2_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p2_y * configuration.scale), 0xff000000
        )
    end

    def configuration
      @config ||= Configuration.global
    end
  end
end