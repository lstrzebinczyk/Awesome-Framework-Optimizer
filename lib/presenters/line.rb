class Line
  class Presenter < Presenter
    def initialize(line)
      @line = line
    end

    def draw
      draw_line(@line.p1.moved_x, @line.p1.moved_y,
                @line.p2.moved_x, @line.p2.moved_y)
    end
  end
end