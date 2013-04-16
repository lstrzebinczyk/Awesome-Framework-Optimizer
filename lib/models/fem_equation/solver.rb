class FemEquation
  class Solver
    def initialize(stiff_matrix, force)
      @stiff_matrix = stiff_matrix
      @force = Vector[force]

      @size = @stiff_matrix.length
      @precondition_vector = stiff_matrix.precondition_vector
    end

    #This method actially solves system of linear equations
    #using conjugate gradient method
    def solve
      answer_vector    = Vector.float(@size)
      current_residuum = @force.clone
      current_z_vector = @force.clone.mul! @precondition_vector
      p_vector         = @force.clone.mul! @precondition_vector

      while current_residuum.max_by{|n| n.abs}.abs > 0.001
        last_residuum = current_residuum.clone
        last_z_vector = current_z_vector.clone
        product_of_stiff_matrix_and_p_vector = @stiff_matrix.product(p_vector)
        alpha_val = last_residuum * last_z_vector / (p_vector * product_of_stiff_matrix_and_p_vector)
        answer_vector += alpha_val * p_vector
        current_residuum = last_residuum - alpha_val * product_of_stiff_matrix_and_p_vector
        #loop can be broken here if residuum is small enough
        current_z_vector = current_residuum.clone.mul! @precondition_vector
        p_vector = current_z_vector + p_vector * (current_z_vector * current_residuum / (last_z_vector * last_residuum))
      end

      return answer_vector
    end
  end
end