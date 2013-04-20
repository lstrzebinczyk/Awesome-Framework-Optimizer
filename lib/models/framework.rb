class Framework
  attr_accessor :stiff, :mesh

  def stiff_matrix
    FemEquation::StiffMatrix.new(@mesh).tap do |matrix|
      matrix.block_ids(points_to_block_ids)
    end
  end

  def config
    Configuration.global
  end

  def draw_empty
    Presenter.new(self).draw_empty
  end

  def draw_status_1
    Presenter.new(self).draw_status_1
  end

  def draw_status_2
    Presenter.new(self).draw_status_2
  end

  def optimize
    poly = @mesh.polygons.max_by{|polygon| polygon.deletion_goal(self.stiff)}
    @mesh.remove_polygon(poly)

    deltas = FemEquation::Solver.new(self.stiff_matrix, self.force_vector).solve
    @mesh.update_points_with_deltas(deltas)

    return self.goal
  end

  def points_size
    @mesh.points.size
  end

  def initialize
    @mesh = Mesh.new
    @force = Boundary.new(Point.new(10, 30), Point.new(15, 30), config.force)
    @x_blocks = [Boundary.new(Point.new(10, 0), Point.new(15, 0)), Boundary.new(Point.new(15, 0), Point.new(15, 30))]
    @y_blocks = [Boundary.new(Point.new(10, 0), Point.new(15, 0))]

    @stiff = config.stiff
  end

  def max_energy
    @mesh.max_energy
  end

  def points_to_block_ids
    ids = []

    @mesh.points.each do |point|
      ids << @mesh.index_of(point) * 2     if @x_blocks.any?{|boundary| boundary.include?(point) }
      ids << @mesh.index_of(point) * 2 + 1 if @y_blocks.any?{|boundary| boundary.include?(point) }
    end

    ids
  end

  def force_vector
    affected_points_count = @mesh.points.count{|pt| @force.include?(pt) }
    @mesh.points.map{|pt| @force.include?(pt) ? [0, @force.value/affected_points_count] : [0, 0] }.flatten
  end

  def make_denser
    @mesh.perform_triangulation

    deltas = FemEquation::Solver.new(self.stiff_matrix, self.force_vector).solve
    @mesh.update_points_with_deltas(deltas)

    @mesh.select_new_points
  end
            
  def goal
    @mesh.field * displacement
  end

  def displacement
    (self.points.min_by{|pt| pt.dy}).dy.abs
  end
end