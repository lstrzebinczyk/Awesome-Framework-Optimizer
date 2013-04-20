require 'spec_helper'

describe Point do
  def nonempty_point
    Point.new(1, 1).tap do |point|
      point.dx = 1
      point.dy = 1
    end
  end

  it "initializes with 2 numbers, defaults temporary to false" do
    point = Point.new(1, 2)
    point.id.should == nil
    point.x.should == 1
    point.y.should == 2
    point.dx.should == 0
    point.dy.should == 0
  end

  describe 'angle' do
    it 'returns angle between points and x axis' do
      Point.new(0, 0).angle(Point.new(1, 1)).should == 0.7853981633974484
      Point.new(0, 0).angle(Point.new(-1, 1)).should == 5.497787143782138
    end
  end

  describe 'temporary?' do
    it 'returns false for regular points' do
      Point.new(0, 0).temporary?.should == false
    end

    it 'returns true for points with 3rd params set to true' do
      Point.new(0, 0, true).temporary?.should == true
    end
  end

  describe "+" do
    it 'creates new point between given two' do
      new_point = Point.new(0, 0) + Point.new(2, 2)
      new_point.x.should == 1
      new_point.y.should == 1
    end
  end

  describe 'moved_x' do
    it 'returns @x + @dx' do
      nonempty_point.moved_x.should == 2
    end
  end

  describe 'moved_y' do
    it 'returns @y + @dy' do
      nonempty_point.moved_y.should == 2
    end
  end

  describe 'change_delta' do
    it 'sets @dx and @dy to provided data' do
      point = Point.new(0, 0)
      point.change_delta(1, 1)
      point.dx.should == 1
      point.dy.should == 1
    end
  end

  describe 'move' do
    it 'adds @dx to x and @dy to y' do
      point = nonempty_point
      point.move
      point.x.should == 2
      point.y.should == 2
    end
  end
end
