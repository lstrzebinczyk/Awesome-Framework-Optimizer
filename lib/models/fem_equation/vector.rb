class FemEquation
  class Vector < NVector
    include Enumerable
    
    def self.[](array)
      super(array).flatten
    end
  end
end