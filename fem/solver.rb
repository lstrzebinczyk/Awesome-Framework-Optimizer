#!/usr/bin/env ruby

require 'narray'

module Solver

  #This method actially solves system of linear equations
  #using conjugate gradient method
  def solve
    l = lol_matrix.length
    precondition_matrix = NVector.float(l)

    (0...l).each do |i|
      precondition_matrix[i] = 1.0 / middle(self.lol_matrix, i)
    end

    answer_vector = NVector.float(l)
    current_residuum = NVector[self.force]
    current_z_vector = NVector[self.force].mul! precondition_matrix
    p_vector = NVector[self.force].mul! precondition_matrix

    answer_vector.flatten!
    current_residuum.flatten!
    current_z_vector.flatten!
    p_vector.flatten!

    iteration = 0

    while true
      iteration += 1

      last_residuum = current_residuum.clone
      last_z_vector = current_z_vector.clone

      alpha_val = pre_alpha(last_residuum, last_z_vector, p_vector, self.lol_matrix)

      answer_vector += alpha_val * p_vector

      helper_vector = NVector.float(l)
      (0...l).each do |i|
        helper_vector[i] = product(self.lol_matrix[i], p_vector)
      end

      current_residuum = last_residuum - alpha_val * helper_vector

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

  def pre_alpha(r, z, pv, a)
    helper1 = r * z
    helper2 = NVector.float(pv.length)
      (0...pv.length).each do |i|
        helper2[i] = product(a[i], pv)
      end
    helper3 = pv * helper2

    return helper1/helper3
  end

  def middle(lol, index)
    lol[index].each do |elem|
      if elem[0] == index
        return elem[1]
      end
    end
  end

  def product(lol_list, vector)
    sum = 0
      lol_list.each do |elem|
        sum += elem[1] * vector[elem[0]]
      end
    sum
  end
end