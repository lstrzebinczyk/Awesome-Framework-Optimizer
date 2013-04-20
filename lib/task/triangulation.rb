module Task
  class Triangulation
    def initialize(framework, window)
      @framework = framework
      @statistics = Statistics.new(@framework)
      @window = window
    end

    def update
      keep_working = @framework.make_denser
      @statistics.update!

      unless keep_working
        @framework.mesh.perform_triangulation
        @statistics.goals << @framework.goal

        return Optimization.new(@framework, @statistics)
      end

      return self
    end

    def draw
      @statistics.draw_status_1
              
      @framework.draw_empty

      @window.translate(280, 0) do 
        @framework.draw_status_1
      end
    end

    def begin
      @window.task = self
      Configuration.global.window = @window
      @window.show
    end
  end
end