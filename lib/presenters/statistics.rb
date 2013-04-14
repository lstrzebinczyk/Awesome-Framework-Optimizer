class Statistics
  class Presenter
    def initialize(statistics)
      @statistics = statistics
    end

    def draw_status_1
      write("Time together        = #{@statistics.time_from_start}", 600, 80)
      write("Time since last tick = #{@statistics.time_step}",       600, 100)
      write("Number of points     = #{@statistics.points_size}",     600, 150)
      write("Max energy           = #{@statistics.max_energy}",      600, 170)
    end

    def draw_status_2
      write("Time together        = #{@statistics.time_from_start}", 600, 80)
      write("Time since last tick = #{@statistics.time_step}",       600, 100)
      write("Number of points     = #{@statistics.points_size}",     600, 150)
      write("Goal function        = #{@statistics.goals.last}",      600, 170)
      write("Optimization         = #{@statistics.optimization}%",   600, 190)

      (0...(@statistics.goals.length-1)).each do |i|
        configuration.window.draw_line_framework(40.0 + i/2.0, 20* @statistics.goals[i]/@statistics.goals.first, 40.5 + i / 2.0, 20* @statistics.goals[i+1]/@statistics.goals.first )
      end
    end

    private

    def draw_line_framework(p1_x, p1_y, p2_x, p2_y)
      draw_line(configuration.translate + p1_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p1_y * configuration.scale), 0xff000000, 
                configuration.translate + p2_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p2_y * configuration.scale), 0xff000000)
    end

    def write(text, x, y)
      font.draw(text, x, y, 1, factor_x = 1, factor_y = 1, color = 0xff000000, mode = :default)
    end

    def font
      @font ||= Gosu::Font.new(configuration.window, "Times New Roman", 24)
    end

    def configuration
      @config ||= Configuration.global
    end
  end
end