require 'spec_helper'

describe Polygon::Circle do
  def circle
    @circle ||= begin
      point_1 = Point.new(0, 0)
      point_2 = Point.new(0, 2)
      point_3 = Point.new(2, 0)
      polygon = Polygon.new(point_1, point_2, point_3)
      Polygon::Circle.new(polygon)
    end
  end

  describe 'new' do
    it 'sets the midpoint and radius right' do
      circle.middle.x.should == 1
      circle.middle.y.should == 1
      circle.radius.should == Math.sqrt(2)
    end
  end

  describe 'include?' do
    it 'returns true if point is inside circle' do
      circle.include?(Point.new(0.5, 0.5)).should == true
    end

    it 'returns true for boundary values' do
      circle.include?(Point.new(0, 0)).should == true
      circle.include?(Point.new(0, 2)).should == true
      circle.include?(Point.new(2, 0)).should == true
      circle.include?(Point.new(2, 2)).should == true
    end

    it 'returns false for points outside circle' do
      circle.include?(Point.new(-0.5, -0.5)).should == false
    end
  end
end