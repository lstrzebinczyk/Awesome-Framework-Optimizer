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
require_relative 'task/triangulation'
require_relative 'task/optimization'
require_relative 'task/idle'

class GameWindow < Gosu::Window
  def initialize
    @configuration = Configuration.global(self)
    @framework = Framework.new(@configuration)
    @statistics = Statistics.new(@framework)
    @task = Task::Triangulation.new(@framework, @statistics)

    super(@configuration.window_x, @configuration.window_y, false)
  end

  def update
    @task = @task.update
  end

  def draw
    background.draw
    @task.draw
  end

  private
  
  def background
    @background ||= Background.new
  end
end

window = GameWindow.new
window.show
