class FemEquation
  class StiffMatrix
    attr_reader :values

    def initialize(framework)
      @size = framework.points.size * 2
      @values = Array.new(@size){[]}

      framework.lines.each do |line|
        insert_line(@values, line, framework.stiff)
      end

      apply_boundaries(@values, framework.points)
    end

    private

    #lol- list of lists (matrix of FEM coeffs)
    def insert_line(lol, line, stiff)
      x1 = line.p1.id * 2
      x2 = line.p1.id * 2 + 1
      x3 = line.p2.id * 2
      x4 = line.p2.id * 2 + 1

      add_to_line(lol[x1], x1,  stiff * line.cos * line.cos / line.length)
      add_to_line(lol[x1], x2,  stiff * line.cos * line.sin / line.length)
      add_to_line(lol[x1], x3, -stiff * line.cos * line.cos / line.length)
      add_to_line(lol[x1], x4, -stiff * line.cos * line.sin / line.length)
      add_to_line(lol[x2], x1,  stiff * line.cos * line.sin / line.length)
      add_to_line(lol[x2], x2,  stiff * line.sin * line.sin / line.length)
      add_to_line(lol[x2], x3, -stiff * line.cos * line.sin / line.length)
      add_to_line(lol[x2], x4, -stiff * line.sin * line.sin / line.length)
      add_to_line(lol[x3], x1, -stiff * line.cos * line.cos / line.length)
      add_to_line(lol[x3], x2, -stiff * line.cos * line.sin / line.length)
      add_to_line(lol[x3], x3,  stiff * line.cos * line.cos / line.length)
      add_to_line(lol[x3], x4,  stiff * line.cos * line.sin / line.length)
      add_to_line(lol[x4], x1, -stiff * line.cos * line.sin / line.length)
      add_to_line(lol[x4], x2, -stiff * line.sin * line.sin / line.length)
      add_to_line(lol[x4], x3,  stiff * line.cos * line.sin / line.length)
      add_to_line(lol[x4], x4,  stiff * line.sin * line.sin / line.length)
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