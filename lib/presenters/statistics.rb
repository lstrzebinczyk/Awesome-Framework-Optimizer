class Statistics
  class Presenter < Presenter
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

      (1...(@statistics.goals.length-1)).each do |i|
        draw_line(40.0 + i/2.0, 20* @statistics.goals[i]/@statistics.goals.first, 40.5 + i / 2.0, 20* @statistics.goals[i+1]/@statistics.goals.first )
      end
    end

    private

    def write(text, x, y)
      font.draw(text, x, y, 1, factor_x = 1, factor_y = 1, color = 0xff000000, mode = :default)
    end

    def font
      @font ||= Gosu::Font.new(config.window, "Times New Roman", 24)
    end
  end
end