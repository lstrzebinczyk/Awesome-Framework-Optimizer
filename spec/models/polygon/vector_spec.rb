require 'spec_helper'

describe Polygon::Vector do
  describe "scalar" do
    it 'counts a scalar sum of 2 vectors' do
      vector_1 = Polygon::Vector.new([1, 2, 0])
      vector_2 = Polygon::Vector.new([0.5, 2, 3])
      vector_1.scalar(vector_2).should == 4.5
    end
  end
end