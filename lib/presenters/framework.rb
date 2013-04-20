class Framework
  class Presenter
    def initialize(framework)
      @framework = framework
    end

    def draw_empty
      draw_lines!
    end

    def draw_status_1
      draw_lines!
      draw_more_complicated_polygons!
    end

    def draw_status_2
      draw_lines!
      drow_less_complicated_polygons!
    end

    private

    def draw_lines!
      @framework.mesh.lines.each{|line| line.draw }
    end

    def draw_more_complicated_polygons!
      @framework.mesh.polygons.each do |poly|
        poly.draw_more_complicated
      end
    end

    def drow_less_complicated_polygons!
      @framework.mesh.polygons.each do |poly|
        poly.draw_less_complicated
      end
    end
  end
end