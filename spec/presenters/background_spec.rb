require 'spec_helper'

describe Background::Presenter do
  def drawed_quad
    @drawed ||= Configuration.global.window.quads.last
  end

  describe "draw" do
    it "passes correct params to window via #draw_quad" do
      Background::Presenter.new.draw

      drawed_quad.x1.should == 0
      drawed_quad.y1.should == 0
      drawed_quad.c1.should == 4294967295
      drawed_quad.x2.should == 1200
      drawed_quad.y2.should == 0
      drawed_quad.c2.should == 4294967295
      drawed_quad.x3.should == 1200
      drawed_quad.y3.should == 600
      drawed_quad.c3.should == 4294967295
      drawed_quad.x4.should == 0
      drawed_quad.y4.should == 600
      drawed_quad.c4.should == 4294967295
    end
  end
end