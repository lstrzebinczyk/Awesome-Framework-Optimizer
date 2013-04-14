class Framework
  attr_accessor :points, :lines, :polygons, :stiff, :constants
  attr_accessor :max_goal, :max_energy

  include FrameworkTriangulation
  include FrameworkMultigrid
  include FrameworkSolver
  include FrameworkOptimize

  def draw_lines!
    lines.each{|line| line.draw }
  end

  def initialize(constants)
    @points = []

    @points << Point.new(0, 0)
    @points << Point.new(10, 0)
    @points << Point.new(15, 0)
    @points << Point.new(0, 30)
    @points << Point.new(10, 30)
    @points << Point.new(15, 30)
    @points << Point.new(8, 14)
    @points << Point.new(15, 14)
    @points << Point.new(15, 10)
    @points << Point.new(8, 10)

    @lines = []
    @polygons = []
    @stiff = constants.stiff
    @constants = constants
    @new_points = []
    @max_goal = 0
    @max_energy = 0

    self.reload
    
    self
  end

  def make_denser
    self.perform_triangulation
    self.reload
    self.FEM_solve
    self.count_field_and_energy
    self.perform_multigrid
  end

  def perform_triangulation
    if @new_points.empty?
      #performs basic delaunay triangulation using Bowyer-Watson Algorithm
      basic_triangulation
    else
      triangulate_new_points
    end

    #performs mesh refinement using ruppert algorith
    ruppert_refinement
  end

  #This method actually counts Fem thing and actualizes dx and dy
  def FEM_solve
    #creates and remembers fem equation
    preprocessor

    #solves fem equation
    processor

    #inserts fem result into mesh displacement
    postprocessor
  end

  def perform_multigrid
    select_new_points
  end

  def perform_optimizing
    optimize
  end

  #This method sets lines and polygons to clear arrays
  def reset
    self.lines = []
    self.polygons = []
  end

  #resets data in points
  def reload
    #reset force put to points
    points_to_input_force = []
    points_to_block = []
    points_to_x_block = []

    points.each_index do |i|
      points[i].reset
      points[i].id = i
      points_to_input_force << points[i] if points[i].y == 30 and points[i].x >= 10 and points[i].x <= 20
      points_to_block << points[i] if points[i].y == 0 and points[i].x >= 10 and points[i].x <= 20
      points_to_x_block << points[i] if points[i].x == 15
    end

    force = constants.force / points_to_input_force.length

    points_to_input_force.each do |pt|
      pt.fy = force
    end

    points_to_block.each do |pt|
      pt.block
    end

    points_to_x_block.each do |pt|
      # puts "#{pt.x} + #{pt.y}"
      pt.set_block_x
    end
  end

  def count_field_and_energy
    @max_goal = 0
    @max_energy = 0

    polygons.each do |poly|
      poly.deletion_goal = nil
      poly.energy = nil
      @max_goal = poly.deletion_goal(self.stiff) if poly.deletion_goal(self.stiff) > @max_goal
      @max_energy = poly.energy(self.stiff) if poly.energy(self.stiff) > @max_energy
    end
  end
            
  def goal
    self.field * self.displacement
  end

  def displacement
    (self.points.min_by{|pt| pt.dy}).dy.abs
  end

  def field
    sum = 0
    polygons.each do |poly|
      sum += poly.field
    end
    sum
  end
end