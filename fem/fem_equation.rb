#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + "/lol_stiff_matrix.rb")
require File.expand_path(File.dirname(__FILE__) + "/solver.rb")

class FemEquation
  attr_accessor :lol_matrix, :force, :size

  include LolStiffMatrix
  include Solver

  def initialize(framework)
    @size = framework.points.length * 2
    @lol_matrix = stiff_matrix_from(framework)
    @force = force_vector_from(framework)
    self
  end
end