require_relative 'index'

task = Task::Triangulation.new(Framework.new, GameWindow.new)
task.begin

# window = GameWindow.new
# window.show
