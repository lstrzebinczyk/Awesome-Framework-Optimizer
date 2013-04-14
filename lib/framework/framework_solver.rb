module FrameworkSolver

  def preprocessor
    @fem = FemEquation.new(self)
  end

  def processor
    @deltas = @fem.solve
  end

  def postprocessor
    points.each_with_index do |point, i|
      point.change_delta(@deltas[2 * i], @deltas[2 * i + 1])
    end
  end
end