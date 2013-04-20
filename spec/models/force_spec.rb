require 'spec_helper'

describe Boundary do
  describe "for horizontal setting" do
    def boundary
      Boundary.new(Point.new(0, 0), Point.new(0, 1), 1)
    end

    describe "include?" do
      it "returns true for values on edges" do
        boundary.include?(Point.new(0, 0)).should == true
        boundary.include?(Point.new(0, 1)).should == true
      end

      it "returns true for value in the middle" do
        boundary.include?(Point.new(0, 0.67)).should == true
      end

      it "returns false for far away point" do
        boundary.include?(Point.new(10, 6)).should == false
      end

      it "returns true for value on line, but outside boundaries" do
        boundary.include?(Point.new(0, -1)).should == false
      end
    end
  end

  describe "for vertical setting" do
    def boundary
      Boundary.new(Point.new(0, 0), Point.new(1, 0), 1)
    end

    describe "include?" do
      it "returns true for values on edges" do
        boundary.include?(Point.new(0, 0)).should == true
        boundary.include?(Point.new(1, 0)).should == true
      end

      it "returns true for value in the middle" do
        boundary.include?(Point.new(0.67, 0)).should == true
      end

      it "returns false for far away point" do
        boundary.include?(Point.new(10, 6)).should == false
      end

      it "returns true for value on line, but outside boundaries" do
        boundary.include?(Point.new(-1, 0)).should == false
      end
    end
  end
end
