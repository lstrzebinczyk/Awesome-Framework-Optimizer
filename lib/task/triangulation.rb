module Task
  class Triangulation
    def initialize(framework, statistics)
      @framework = framework
      @statistics = statistics
    end

    def update
      keep_working = @framework.make_denser
      @statistics.update!

      unless keep_working
        @framework.perform_triangulation
        @statistics.goals << @framework.goal

        return Optimization.new(@framework, @statistics)
      end

      return self
    end

    def draw
      @statistics.draw_status_1
              
      @framework.draw_empty

      window.translate(280, 0) do 
        @framework.draw_status_1
      end
    end

    private

    def window
      Configuration.global.window
    end
  end
end