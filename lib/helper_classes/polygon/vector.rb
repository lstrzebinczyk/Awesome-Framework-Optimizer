class Polygon
  class Vector < Array
    def scalar(other)
      sum = 0
        self.each_index do |i|
          sum += self[i]*other[i]
        end
      sum
    end
  end
end