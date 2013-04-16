require 'spec_helper'

describe Point do
  def nonempty_point
    Point.new(1, 1).tap do |point|
      point.dx = 1
      point.dy = 1
      point.fx = 1
      point.fy = 1
      point.block_x = true
      point.block_y = true
    end
  end

  it "initializes with 2 numbers, defaults temporary to false" do
    point = Point.new(1, 2)
    point.id.should == nil
    point.x.should == 1
    point.y.should == 2
    point.dx.should == 0
    point.dy.should == 0
    point.fx.should == 0
    point.fy.should == 0
    point.block_x.should == false
    point.block_y.should == false
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

  describe 'reset' do
    it 'sets @dx, @dy, @fx, @fy to 0 and @block_x, @block_y to false' do
      point = nonempty_point
      point.reset
      point.dx.should == 0
      point.dy.should == 0
      point.fx.should == 0
      point.fy.should == 0
      point.block_x.should == false
      point.block_y.should == false
    end
  end

  describe 'block' do
    it 'sets @block_x and @block_y to true' do
      point = Point.new(0, 0)
      point.block
      point.block_x.should == true
      point.block_y.should == true
    end
  end

  describe 'set_block_x' do
    it 'sets @block_x to true' do
      point = Point.new(0, 0)
      point.set_block_x
      point.block_x.should == true
      point.block_y.should == false
    end
  end

  describe 'force' do
    it 'sets @fx and @fy to provided data' do
      point = Point.new(0, 0)
      point.force(1, 1)
      point.fx.should == 1
      point.fy.should == 1
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
