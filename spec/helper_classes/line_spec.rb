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

  def inside_point
    Point.new(0, 4).tap do |point|
      point.id = 3
    end
  end

  def outside_point
    Point.new(-1, 0).tap do |point|
      point.id = 3
    end
  end

  describe "new" do
    it "sets points in provided order if first point has bigger id" do
      line = Line.new(point_1, point_2)
      line.p1.should == point_1
      line.p2.should == point_2
    end

    it "sets points in reversed order if first point has lower id" do
      line = Line.new(point_2, point_1)
      line.p1.should == point_1
      line.p2.should == point_2
    end
  end

  describe 'inside_circle?' do
    it "returns true if lines midpoint is closer to point than to it's end" do
      line.inside_circle?(inside_point).should == true
    end

    it "returns false if lines midpoint is further to point than to it's end" do
      line.inside_circle?(outside_point).should == false
    end
  end

  describe 'midpoint' do
    it 'returns point between lines edges' do
      line.midpoint.x.should == 1
      line.midpoint.y.should == 5
      line.midpoint.id.should == 0
    end
  end

  describe 'length' do
    it 'returns carthesian lengths of line' do
      line.length.should == 10.198039027185569
    end
  end

  describe 'draw' do
    it 'creates a Presenter object and calls draw on it' do
      Line::Presenter.any_instance.should_receive(:draw)
      line.draw
    end
  end
end
