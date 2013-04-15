class FemEquation
  attr_accessor :lol_matrix, :force, :size

  def initialize(framework)
    @size = framework.points.length * 2
    @lol_matrix = stiff_matrix_from(framework)
    @force = force_vector_from(framework)
  end

  def stiff_matrix_from(framework)
    stiff_matrix = Array.new(self.size){|i| []}

    framework.lines.each do |line|
      insert_line(stiff_matrix, line, framework.stiff)
    end

    apply_boundaries(stiff_matrix, framework.points)

    stiff_matrix
  end

  def apply_boundaries(matrix, points)
    bounds = []
    points.each do |point|
      bounds << point.id*2 if point.block_x
      bounds << point.id*2 +1 if point.block_y
    end

    bounds.each do |num|
      matrix[num] = [[num, 1]]
    end

    matrix.each_with_index do |row, i|
      unless bounds.include?(i)
        row.delete_if { |pair| bounds.include?(pair[0]) or pair[1].abs < 0.0001}
      end
    end

    #TODO Poprawić
    matrix.delete_if{|elem| elem == []}
  end

  def add_to_line(line, position, value)
    added = false

    line.each do |val|
      if val[0] == position
        val[1] += value
        added = true
        break
      elsif val[0] > position
        break
      end
    end

    if added == false
      line << [position, value]
      added = true
    end

    line.sort!
  end

  #lol- list of lists (matrix of FEM coeffs)
  def insert_line(lol, line, stiff)
    length = line.length
    k = stiff / length
    cos = (line.p1.x - line.p2.x)/length
    sin = (line.p1.y - line.p2.y)/length

    x1 = line.p1.id * 2
    x2 = line.p1.id * 2 + 1
    x3 = line.p2.id * 2
    x4 = line.p2.id * 2 + 1

    add_to_line(lol[x1], x1,  k * cos * cos)
    add_to_line(lol[x1], x2,  k * cos * sin)
    add_to_line(lol[x1], x3, -k * cos * cos)
    add_to_line(lol[x1], x4, -k * cos * sin)
    add_to_line(lol[x2], x1,  k * cos * sin)
    add_to_line(lol[x2], x2,  k * sin * sin)
    add_to_line(lol[x2], x3, -k * cos * sin)
    add_to_line(lol[x2], x4, -k * sin * sin)
    add_to_line(lol[x3], x1, -k * cos * cos)
    add_to_line(lol[x3], x2, -k * cos * sin)
    add_to_line(lol[x3], x3,  k * cos * cos)
    add_to_line(lol[x3], x4,  k * cos * sin)
    add_to_line(lol[x4], x1, -k * cos * sin)
    add_to_line(lol[x4], x2, -k * sin * sin)
    add_to_line(lol[x4], x3,  k * cos * sin)
    add_to_line(lol[x4], x4,  k * sin * sin)
  end

  def force_vector_from(framework)
    points = framework.points

    force_vector = []
    points.each do |pt|
      force_vector << pt.fx
      force_vector << pt.fy
    end

    force_vector
  end

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