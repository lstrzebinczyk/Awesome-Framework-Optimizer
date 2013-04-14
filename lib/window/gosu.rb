class GameWindow < Gosu::Window
  attr_accessor :task

  def initialize
    super(config.window_x, config.window_y, false)
  end

  def update
    @task = @task.update
  end

  def draw
    background.draw
    @task.draw
  end

  private
  
  def config
    @configuration = Configuration.global
  end

  def background
    @background ||= Background.new
  end
end