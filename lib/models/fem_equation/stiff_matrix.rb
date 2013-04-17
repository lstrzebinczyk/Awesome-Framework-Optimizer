class FemEquation
  class StiffMatrix
    attr_reader :values, :size

    def initialize(framework)
      @size = framework.points.size * 2
      @values = Array.new(@size){[]}

      framework.lines.each do |line|
        insert_line(@values, line, framework.stiff)
      end

      apply_boundaries(@values, framework.points)
    end

    def precondition_vector
      Vector.float(@size).tap do |v|
        (0...@size).each do |i|
          v[i] = 1.0/self[i, i]
        end
      end
    end

    def product(vector)
      raise 'Incoming object has to be of class FemEquation::Vector' unless vector.is_a?(FemEquation::Vector)

      returned_vector = Vector.float(size)

      (0...size).each do |i|
        returned_vector[i] = helper_product(@values[i], vector)
      end

      returned_vector
    end

    private

    def [](key1, key2)
      @values[key1].each do |elem|
        if elem[0] == key2
          return elem[1]
        end
      end
    end

    def helper_product(lol_list, vector)
      sum = 0
        lol_list.each do |elem|
          sum += elem[1] * vector[elem[0]]
        end
      sum
    end

    #lol- list of lists (matrix of FEM coeffs)
    def insert_line(lol, line, stiff)
      x1 = line.p1.id * 2
      x2 = line.p1.id * 2 + 1
      x3 = line.p2.id * 2
      x4 = line.p2.id * 2 + 1

      add_to_line(lol[x1], x1, stiff * line.stiff_matrix[0][0])
      add_to_line(lol[x1], x2, stiff * line.stiff_matrix[0][1])
      add_to_line(lol[x1], x3, stiff * line.stiff_matrix[0][2])
      add_to_line(lol[x1], x4, stiff * line.stiff_matrix[0][3])
      add_to_line(lol[x2], x1, stiff * line.stiff_matrix[1][0])
      add_to_line(lol[x2], x2, stiff * line.stiff_matrix[1][1])
      add_to_line(lol[x2], x3, stiff * line.stiff_matrix[1][2])
      add_to_line(lol[x2], x4, stiff * line.stiff_matrix[1][3])
      add_to_line(lol[x3], x1, stiff * line.stiff_matrix[2][0])
      add_to_line(lol[x3], x2, stiff * line.stiff_matrix[2][1])
      add_to_line(lol[x3], x3, stiff * line.stiff_matrix[2][2])
      add_to_line(lol[x3], x4, stiff * line.stiff_matrix[2][3])
      add_to_line(lol[x4], x1, stiff * line.stiff_matrix[3][0])
      add_to_line(lol[x4], x2, stiff * line.stiff_matrix[3][1])
      add_to_line(lol[x4], x3, stiff * line.stiff_matrix[3][2])
      add_to_line(lol[x4], x4, stiff * line.stiff_matrix[3][3])
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
  end
end