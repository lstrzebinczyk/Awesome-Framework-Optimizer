class Polygon
  class StiffMatrix
    attr_reader :matrix

    def initialize(stiff)
      @stiff = stiff
      @matrix = Vector.new([Vector.new([0, 0, 0, 0, 0, 0]),
                            Vector.new([0, 0, 0, 0, 0, 0]),
                            Vector.new([0, 0, 0, 0, 0, 0]),
                            Vector.new([0, 0, 0, 0, 0, 0]),
                            Vector.new([0, 0, 0, 0, 0, 0]),
                            Vector.new([0, 0, 0, 0, 0, 0])])
    end

    def [](key)
      @matrix[key]
    end

    def scalar(displacement)
      Vector.new(@matrix.map{|v| displacement.scalar(v) }).scalar(displacement)
    end

    def insert(line, address)
      @matrix[address[0]][address[0]] += @stiff * line.stiff_matrix[0][0]
      @matrix[address[0]][address[1]] += @stiff * line.stiff_matrix[0][1]
      @matrix[address[0]][address[2]] += @stiff * line.stiff_matrix[0][2]
      @matrix[address[0]][address[3]] += @stiff * line.stiff_matrix[0][3]
      @matrix[address[1]][address[0]] += @stiff * line.stiff_matrix[1][0]
      @matrix[address[1]][address[1]] += @stiff * line.stiff_matrix[1][1]
      @matrix[address[1]][address[2]] += @stiff * line.stiff_matrix[1][2]
      @matrix[address[1]][address[3]] += @stiff * line.stiff_matrix[1][3]
      @matrix[address[2]][address[0]] += @stiff * line.stiff_matrix[2][0]
      @matrix[address[2]][address[1]] += @stiff * line.stiff_matrix[2][1]
      @matrix[address[2]][address[2]] += @stiff * line.stiff_matrix[2][2]
      @matrix[address[2]][address[3]] += @stiff * line.stiff_matrix[2][3]
      @matrix[address[3]][address[0]] += @stiff * line.stiff_matrix[3][0]
      @matrix[address[3]][address[1]] += @stiff * line.stiff_matrix[3][1]
      @matrix[address[3]][address[2]] += @stiff * line.stiff_matrix[3][2]
      @matrix[address[3]][address[3]] += @stiff * line.stiff_matrix[3][3]
    end
  end
end