require 'spec_helper'

describe Line do
  def point_1
    @point_1 ||= Point.new(0, 0).tap do |point|
      point.id = 2
    end
  end

  def point_2
    @point_2 ||= Point.new(2, 10).tap do |point|
      point.id = 1
    end
  end

  def line
    @line ||= Line.new(point_1, point_2)
  end

  def drawed_line
    @drawed ||= Configuration.global.window.lines.last
  end

  describe "draw" do
    it "passes correct params to window via #draw_line" do
      line.draw

      drawed_line.x1.should == 60.0
      drawed_line.y1.should == 540.0
      drawed_line.c1.should == 4278190080
      drawed_line.x2.should == 90.0
      drawed_line.y2.should == 390.0
      drawed_line.c2.should == 4278190080
    end
  end
end