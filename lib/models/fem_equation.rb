class FemEquation
  def initialize(framework)
    @stiff_matrix = StiffMatrix.new(framework).values
    @force = framework.force_vector
  end

  def solve
    Solver.new(@stiff_matrix, @force).solve
  end
end