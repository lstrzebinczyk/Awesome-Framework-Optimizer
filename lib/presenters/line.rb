class Line
  class Presenter
    def initialize(line)
      @line = line
    end

    def draw
      draw_line_framework(@line.p1.moved_x, @line.p1.moved_y,
                          @line.p2.moved_x, @line.p2.moved_y)
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