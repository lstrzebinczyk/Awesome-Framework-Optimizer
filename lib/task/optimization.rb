module Task
  class Optimization
    def initialize(framework, statistics)
      @framework = framework
      @statistics = statistics
    end

    def update
      @goal = @framework.optimize
      @statistics.update!(@goal)

      if @statistics.good_enough?
        return Idle.new(@framework, @statistics)
      end

      return self
    end

    def draw
      @statistics.draw_status_2
      @framework.draw_empty

      window.translate(280, 0) do 
        @framework.draw_status_2
      end
    end

    private

    def window
      Configuration.global.window
    end
  end
end