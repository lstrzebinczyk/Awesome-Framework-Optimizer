require 'spec_helper'

describe Force do
  describe "for horizontal setting" do
    def force
      Force.new(Point.new(0, 0), Point.new(0, 1), 1)
    end

    describe "include?" do
      it "returns true for values on edges" do
        force.include?(Point.new(0, 0)).should == true
        force.include?(Point.new(0, 1)).should == true
      end

      it "returns true for value in the middle" do
        force.include?(Point.new(0, 0.67)).should == true
      end

      it "returns false for far away point" do
        force.include?(Point.new(10, 6)).should == false
      end

      it "returns true for value on line, but outside boundaries" do
        force.include?(Point.new(0, -1)).should == false
      end
    end
  end

  describe "for vertical setting" do
    def force
      Force.new(Point.new(0, 0), Point.new(1, 0), 1)
    end

    describe "include?" do
      it "returns true for values on edges" do
        force.include?(Point.new(0, 0)).should == true
        force.include?(Point.new(1, 0)).should == true
      end

      it "returns true for value in the middle" do
        force.include?(Point.new(0.67, 0)).should == true
      end

      it "returns false for far away point" do
        force.include?(Point.new(10, 6)).should == false
      end

      it "returns true for value on line, but outside boundaries" do
        force.include?(Point.new(-1, 0)).should == false
      end
    end
  end
end
