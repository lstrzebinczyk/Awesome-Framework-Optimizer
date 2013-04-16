class FemEquation
  class Solver
    def initialize(stiff_matrix, force)
      @stiff_matrix = stiff_matrix
      @force = force

      @size = @stiff_matrix.length
    end

    #This method actially solves system of linear equations
    #using conjugate gradient method
    def solve
      answer_vector = Vector.float(@size)
      current_residuum = Vector[@force]
      current_z_vector = Vector[@force].mul! precondition_matrix
      p_vector = Vector[@force].mul! precondition_matrix

      answer_vector.flatten!
      current_residuum.flatten!
      current_z_vector.flatten!
      p_vector.flatten!

      while true
        last_residuum = current_residuum.clone
        last_z_vector = current_z_vector.clone

        helper1 = last_residuum * last_z_vector
        helper2 = @stiff_matrix.product(p_vector)
        helper3 = p_vector * helper2
        alpha_val = helper1 / helper3

        answer_vector += alpha_val * p_vector

        current_residuum = last_residuum - alpha_val * @stiff_matrix.product(p_vector)

        break if current_residuum.max.abs < 0.001

        current_z_vector = current_residuum.clone
        current_z_vector.mul! precondition_matrix

        beta1 = current_z_vector * current_residuum
        beta2 = last_z_vector * last_residuum

        beta = beta1 / beta2

        p_vector = current_z_vector + beta * p_vector
      end

      return answer_vector
    end

    private

    def precondition_matrix
      @precondition_matrix ||= begin
        Vector.float(@size).tap do |v|
          (0...@size).each do |i|
            v[i] = 1.0/@stiff_matrix[i, i]
          end
        end
      end
    end
  end
end