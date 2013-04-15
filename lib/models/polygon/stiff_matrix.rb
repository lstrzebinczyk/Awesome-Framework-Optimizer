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
      vector = Vector.new(@matrix.map{|v| displacement.scalar(v) })
      vector.scalar(displacement)
    end

    def insert(line, address)
      @matrix[address[0]][address[0]] +=  @stiff * line.cos * line.cos / line.length
      @matrix[address[0]][address[1]] +=  @stiff * line.cos * line.sin / line.length
      @matrix[address[0]][address[2]] += -@stiff * line.cos * line.cos / line.length
      @matrix[address[0]][address[3]] += -@stiff * line.cos * line.sin / line.length
      @matrix[address[1]][address[0]] +=  @stiff * line.cos * line.sin / line.length
      @matrix[address[1]][address[1]] +=  @stiff * line.sin * line.sin / line.length
      @matrix[address[1]][address[2]] += -@stiff * line.cos * line.sin / line.length
      @matrix[address[1]][address[3]] += -@stiff * line.sin * line.sin / line.length
      @matrix[address[2]][address[0]] += -@stiff * line.cos * line.cos / line.length
      @matrix[address[2]][address[1]] += -@stiff * line.cos * line.sin / line.length
      @matrix[address[2]][address[2]] +=  @stiff * line.cos * line.cos / line.length
      @matrix[address[2]][address[3]] +=  @stiff * line.cos * line.sin / line.length
      @matrix[address[3]][address[0]] += -@stiff * line.cos * line.sin / line.length
      @matrix[address[3]][address[1]] += -@stiff * line.sin * line.sin / line.length
      @matrix[address[3]][address[2]] +=  @stiff * line.cos * line.sin / line.length
      @matrix[address[3]][address[3]] +=  @stiff * line.sin * line.sin / line.length
    end
  end
end