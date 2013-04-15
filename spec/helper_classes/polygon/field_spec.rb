require 'spec_helper'

describe Polygon::Field do
  describe "to_f" do
    it 'counts field according to input data' do
      Polygon::Field.new(0, 0, 0, 1, 1, 0).to_f.should == 0.5
      Polygon::Field.new(0, 0, 0, 1, 2, 0).to_f.should == 1
      Polygon::Field.new(0, -1, 0, 1, 1, 0).to_f.should == 1
    end
  end
end