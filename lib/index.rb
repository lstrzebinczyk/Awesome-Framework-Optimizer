require 'gosu'
require 'narray'

require_relative 'helper_classes/line'
require_relative 'helper_classes/point'
require_relative 'helper_classes/polygon'
require_relative 'framework/framework_multigrid'
require_relative 'framework/framework_optimize'
require_relative 'framework/framework_solver'
require_relative 'framework/framework_triangulation'
require_relative 'framework/framework'
require_relative 'fem/lol_stiff_matrix'
require_relative 'fem/solver'
require_relative 'fem/fem_equation'
require_relative 'configuration'

class GameWindow < Gosu::Window

  def configuration
    @config ||= Configuration.new
  end

  def initialize
    @fr = Framework.new(configuration)
    @time = Time.now
    @begin_time = Time.now

    @status = 1
    @last_goal = 1000000.0

    @goals_arr = []

    super(configuration.window_x, configuration.window_y, false)
  end

  def status_1_update
    a = Time.now
    keep_working = @fr.make_denser
    @counting_time = Time.now - a
    @time_step = Time.now - @time
    @time = Time.now

    unless keep_working
      @fr.perform_triangulation
      @goals_arr << @fr.goal
      @goal_scale = @goals_arr.last
      @status += 1
    end
  end

  def status_2_update
    a = Time.now
    @goal = @fr.optimize
    @goals_arr << @goal
    @counting_time = Time.now - a
    @time_step = Time.now - @time
    @time = Time.now

    if @goal >= @last_goal * 1.01
      @status += 1
    else
      @last_goal = @goal
      @optimization = @last_goal / @goal_scale
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

  def draw_line_framework(p1_x, p1_y, p2_x, p2_y)
    draw_line(configuration.translate + p1_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p1_y * configuration.scale), 0xff000000, 
              configuration.translate + p2_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p2_y * configuration.scale), 0xff000000)
  end

  def draw_triangle_framework(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, color)
    draw_triangle(configuration.translate + p1_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p1_y * configuration.scale), color, 
                  configuration.translate + p2_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p2_y * configuration.scale), color,
                  configuration.translate + p3_x * configuration.scale, configuration.window_y - 1.0 * (configuration.translate + p3_y * configuration.scale), color,
                  0)
  end

  def write(text, x, y)
    @font.draw(text, x, y, 1, factor_x = 1, factor_y = 1, color = 0xff000000, mode = :default)
  end

  def status_1_draw
    @font = Gosu::Font.new(self, "Times New Roman", 24)

    write("Time together        = #{Time.now - @begin_time}", 600, 80)
    write("Time since last tick = #{@time_step}", 600, 100)
    write("Counting time        = #{@counting_time}", 600, 120)
    write("Number of points     = #{@fr.points.length}", 600, 150)
    write("Max energy           = #{@fr.max_energy}", 600, 170)

    draw_quad(0, 0, 0xffffffff, 
              configuration.window_x, 0, 0xffffffff, 
              configuration.window_x, configuration.window_y, 0xffffffff, 
              0, configuration.window_y, 0xffffffff, 0)
            
    @fr.lines.each do |line|
      draw_line_framework(line.p1.x + line.p1.dx, line.p1.y + line.p1.dy,
                          line.p2.x + line.p2.dx, line.p2.y + line.p2.dy)
    end

    trans = 20

    @fr.lines.each do |line|
      draw_line_framework(line.p1.x + line.p1.dx + trans, line.p1.y + line.p1.dy,
                          line.p2.x + line.p2.dx + trans, line.p2.y + line.p2.dy)
    end

    @fr.polygons.each do |poly|
      if @fr.max_energy > 1
        color = Gosu::Color.argb(255, 
        255 * poly.energy(@fr.stiff)/@fr.max_energy,
        255 * (1 - poly.energy(@fr.stiff)/@fr.max_energy), 0)
      elsif @fr.max_energy < 1 and @fr.max_energy > 0.1
        color = Gosu::Color.argb(255, 
        255 * poly.energy(@fr.stiff),
        255 * (1 - poly.energy(@fr.stiff)), 0)
      else
        color = Gosu::Color.argb(255, 
        2550 * poly.energy(@fr.stiff),
        255 * (1 - 10 * poly.energy(@fr.stiff)), 0)
      end

      draw_triangle_framework(poly.p1.x + poly.p1.dx + trans, poly.p1.y + poly.p1.dy, 
                              poly.p2.x + poly.p2.dx + trans, poly.p2.y + poly.p2.dy,
                              poly.p3.x + poly.p3.dx + trans, poly.p3.y + poly.p3.dy, color)
    end
  end

  def status_2_draw
    @font = Gosu::Font.new(self, "Times New Roman", 24)

    write("Time together        = #{Time.now - @begin_time}", 600, 80)
    write("Time since last tick = #{@time_step}", 600, 100)
    write("Counting time        = #{@counting_time}", 600, 120)
    write("Number of points     = #{@fr.points.length}", 600, 150)
    write("Goal function        = #{@goal}", 600, 170)
    write("Optimization         = #{@optimization}%", 600, 190)

    draw_quad(0, 0, 0xffffffff, 
              configuration.window_x, 0, 0xffffffff, 
              configuration.window_x, configuration.window_y, 0xffffffff, 
              0, configuration.window_y, 0xffffffff, 0)
            
    @fr.lines.each do |line|
      draw_line_framework(line.p1.x + line.p1.dx, line.p1.y + line.p1.dy,
                          line.p2.x + line.p2.dx, line.p2.y + line.p2.dy)
    end

    trans = 20

    @fr.lines.each do |line|
      draw_line_framework(line.p1.x + line.p1.dx + trans, line.p1.y + line.p1.dy,
                          line.p2.x + line.p2.dx + trans, line.p2.y + line.p2.dy)
    end

    @fr.polygons.each do |poly|
      if @fr.max_goal > 1
        color = Gosu::Color.argb(255, 
        255 * (poly.deletion_goal(@fr.stiff)/@fr.max_goal),
        255 * (1 - poly.deletion_goal(@fr.stiff)/@fr.max_goal), 0)
      else
        color = Gosu::Color.argb(255, 
        255 * (poly.deletion_goal(@fr.stiff)),
        255 * (1 - poly.deletion_goal(@fr.stiff)), 0)
      end

      draw_triangle_framework(poly.p1.x + poly.p1.dx + trans, poly.p1.y + poly.p1.dy, 
                              poly.p2.x + poly.p2.dx + trans, poly.p2.y + poly.p2.dy,
                              poly.p3.x + poly.p3.dx + trans, poly.p3.y + poly.p3.dy, color)
    end

    (0...(@goals_arr.length-1)).each do |i|
      # draw_line_framework(550 + 5*i, @goals_arr[i]/@goal_scale, 550 + 10*i, @goals_arr[i+1]/@goal_scale )
      draw_line_framework(40.0 + i/2.0, 20* @goals_arr[i]/@goal_scale, 40.5 + i / 2.0, 20* @goals_arr[i+1]/@goal_scale )
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
