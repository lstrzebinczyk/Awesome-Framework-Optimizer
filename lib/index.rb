require 'gosu'
require 'narray'

require_relative 'helper_classes/line'
require_relative 'helper_classes/point'
require_relative 'helper_classes/polygon'
require_relative 'helper_classes/background'
require_relative 'framework/framework_multigrid'
require_relative 'framework/framework_optimize'
require_relative 'framework/framework_solver'
require_relative 'framework/framework_triangulation'
require_relative 'framework/framework'
require_relative 'fem/lol_stiff_matrix'
require_relative 'fem/solver'
require_relative 'fem/fem_equation'
require_relative 'configuration'
require_relative 'statistics'
require_relative 'presenters/line'
require_relative 'presenters/background'
require_relative 'presenters/polygon'
require_relative 'presenters/framework'
require_relative 'presenters/statistics'

class GameWindow < Gosu::Window
  def configuration
    @config ||= Configuration.global(self)
  end

  def background
    @background ||= Background.new
  end

  def initialize
    @fr = Framework.new(configuration)
    @statistics = Statistics.new(@fr)
    @status = 1

    super(configuration.window_x, configuration.window_y, false)
  end

  def status_1_update
    keep_working = @fr.make_denser
    @statistics.update!

    unless keep_working
      @fr.perform_triangulation
      @statistics.goals << @fr.goal
      @status += 1
    end
  end

  def status_2_update
    @goal = @fr.optimize
    @statistics.update!(@goal)

    if @statistics.good_enough?
      @status += 1
    end
  end

  def update
    case @status
    when 1
      status_1_update
    when 2
      status_2_update
    when 3
      exit
    end
  end

  def status_1_draw
    @statistics.draw_status_1

    background.draw
            
    @fr.draw_empty

    translate(280, 0) do 
      @fr.draw_status_1
    end
  end

  def status_2_draw
    @statistics.draw_status_2

    background.draw
            
    @fr.draw_empty

    translate(280, 0) do 
      @fr.draw_status_2
    end
  end
  
  def draw
    case @status 
    when 1
      status_1_draw
    when 2
      status_2_draw
    when 3
      status_2_draw
    end
  end
end

window = GameWindow.new
window.show
