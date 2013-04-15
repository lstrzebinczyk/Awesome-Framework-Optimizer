class Polygon
  class Energy
    def initialize(polygon, stiff)
      @stiff = stiff
      @p1 = polygon.p1
      @p2 = polygon.p2
      @p3 = polygon.p3
    end

    def to_f
      matrix = [[0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0]]

      length = Math.sqrt((@p1.x - @p2.x)**2 + (@p1.y - @p2.y)**2)
      cos = (@p2.x - @p1.x) / length
      sin = (@p2.y - @p1.y) / length

      matrix[0][0] +=  @stiff * cos * cos / length
      matrix[0][1] +=  @stiff * cos * sin / length
      matrix[0][2] += -@stiff * cos * cos / length
      matrix[0][3] += -@stiff * cos * sin / length

      matrix[1][0] +=  @stiff * cos * sin / length
      matrix[1][1] +=  @stiff * sin * sin / length
      matrix[1][2] += -@stiff * cos * sin / length
      matrix[1][3] += -@stiff * sin * sin / length

      matrix[2][0] += -@stiff * cos * cos / length
      matrix[2][1] += -@stiff * cos * sin / length
      matrix[2][2] +=  @stiff * cos * cos / length
      matrix[2][3] +=  @stiff * cos * sin / length

      matrix[3][0] += -@stiff * cos * sin / length
      matrix[3][1] += -@stiff * sin * sin / length
      matrix[3][2] +=  @stiff * cos * sin / length
      matrix[3][3] +=  @stiff * sin * sin / length

      
      length = Math.sqrt((@p1.x - @p3.x)**2 + (@p1.y - @p3.y)**2)
      cos = (@p3.x - @p1.x) / length
      sin = (@p3.y - @p1.y) / length

      matrix[0][0] +=  @stiff * cos * cos / length
      matrix[0][1] +=  @stiff * cos * sin / length
      matrix[0][4] += -@stiff * cos * cos / length
      matrix[0][5] += -@stiff * cos * sin / length

      matrix[1][0] +=  @stiff * cos * sin / length
      matrix[1][1] +=  @stiff * sin * sin / length
      matrix[1][4] += -@stiff * cos * sin / length
      matrix[1][5] += -@stiff * sin * sin / length

      matrix[4][0] += -@stiff * cos * cos / length
      matrix[4][1] += -@stiff * cos * sin / length
      matrix[4][4] +=  @stiff * cos * cos / length
      matrix[4][5] +=  @stiff * cos * sin / length

      matrix[5][0] += -@stiff * cos * sin / length
      matrix[5][1] += -@stiff * sin * sin / length
      matrix[5][4] +=  @stiff * cos * sin / length
      matrix[5][5] +=  @stiff * sin * sin / length

      length = Math.sqrt((@p2.x - @p3.x)**2 + (@p2.y - @p3.y)**2)
      cos = (@p3.x - @p2.x) / length
      sin = (@p3.y - @p2.y) / length

      matrix[2][2] +=  @stiff * cos * cos / length
      matrix[2][3] +=  @stiff * cos * sin / length
      matrix[2][4] += -@stiff * cos * cos / length
      matrix[2][5] += -@stiff * cos * sin / length

      matrix[3][2] +=  @stiff * cos * sin / length
      matrix[3][3] +=  @stiff * sin * sin / length
      matrix[3][4] += -@stiff * cos * sin / length
      matrix[3][5] += -@stiff * sin * sin / length

      matrix[4][2] += -@stiff * cos * cos / length
      matrix[4][3] += -@stiff * cos * sin / length
      matrix[4][4] +=  @stiff * cos * cos / length
      matrix[4][5] +=  @stiff * cos * sin / length

      matrix[5][2] += -@stiff * cos * sin / length
      matrix[5][3] += -@stiff * sin * sin / length
      matrix[5][4] +=  @stiff * cos * sin / length
      matrix[5][5] +=  @stiff * sin * sin / length

      dv = [@p1.dx, @p1.dy, @p2.dx, @p2.dy, @p3.dx, @p3.dy]
      helper_vector = [scalar_sum(dv, matrix[0]),
                       scalar_sum(dv, matrix[1]),
                       scalar_sum(dv, matrix[2]),
                       scalar_sum(dv, matrix[3]),
                       scalar_sum(dv, matrix[4]),
                       scalar_sum(dv, matrix[5])]

      @energy = 0.5 * scalar_sum(dv, helper_vector)
    end

    private

    def scalar_sum(v1, v2)
      sum = 0
        v1.each_index do |i|
          sum += v1[i]*v2[i]
        end
      sum
    end
  end
end