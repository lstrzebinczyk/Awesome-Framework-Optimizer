require 'spec_helper'

describe Line do
  def point_1
    @point_1 ||= Point.new(0, 0)
  end

  def point_2
    @point_2 ||= Point.new(2, 10)
  end

  def temporary_point
    Point.new(0, 0, true)
  end

  def line
    @line ||= Line.new(point_1, point_2)
  end

  def inside_point
    Point.new(0, 4)
  end

  def outside_point
    Point.new(-1, 0)
  end

  describe 'stiff_matrix' do
    it 'counts and returns 4x4 stiff matrix' do
      expected = [
        [ 0.0037714641372727704,  0.018857320686363855, -0.0037714641372727704, -0.018857320686363855], 
        [ 0.018857320686363855,   0.09428660343181927,  -0.018857320686363855,  -0.09428660343181927 ], 
        [-0.0037714641372727704, -0.018857320686363855,  0.0037714641372727704,  0.018857320686363855], 
        [-0.018857320686363855,  -0.09428660343181927,   0.018857320686363855,   0.09428660343181927 ]
      ]

      line.stiff_matrix.should == expected
    end
  end

  describe 'temporary?' do
    it 'returns false if points are not temporary' do
      line.temporary?.should == false
    end

    it 'returns true if either point is temporary' do
      Line.new(point_1, temporary_point).temporary?.should == true
      Line.new(temporary_point, point_1).temporary?.should == true
    end
  end

  describe "new" do
    it "sets points in provided order if first point has bigger id" do
      line = Line.new(point_1, point_2)
      line.p1.should == point_1
      line.p2.should == point_2
    end
  end

  describe 'cos' do
    it 'returns cosine' do
      line.cos.should == 0.19611613513818404
    end
  end

  describe 'sin' do
    it 'returns sine' do
      line.sin.should == 0.9805806756909202
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
