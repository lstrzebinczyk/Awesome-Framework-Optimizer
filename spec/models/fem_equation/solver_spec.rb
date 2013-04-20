require 'spec_helper'

describe FemEquation::Solver do
  def expected_response
    [ 
        0.05194504676036222,
       -3.5983973870311146,
        0.0,
        0.0,
        0.0,
        0.0,
        0.5721814970390656,
       -3.968285826415923,
        0.4958477289094209,
       -7.97646097254279,
        0.0,
       -8.911680476364769,
       -1.0723872687848597,
       -4.358654427183855,
        0.0,
       -8.071186640652954,
        0.0,
        0.0,
       -0.7948763887007045,
       -3.2246357753219246,
       -1.468187442833333,
       -2.632883678422425,
       -1.4589372276419796,
       -3.734020227880142,
       -0.04967796131010597,
       -7.577952491201208,
       -0.7658760861402577,
       -4.784132658516079 ]
  end

  describe 'solve' do
    it 'does a marvellous job at solving the equation' do #This test is bad and I feel bad
      framework = Framework.new
      framework.perform_triangulation

      stiff_matrix = FemEquation::StiffMatrix.new(framework)
      stiff_matrix.block_ids(framework.points_to_block_ids)
      force = framework.force_vector

      # FemEquation::Solver.new(stiff_matrix, force).solve.should == expected_response
      FemEquation::Solver.new(stiff_matrix, force).solve.each_with_index do |elem, i|
        (elem - expected_response[i]).abs.should < 0.0001
      end
    end
  end
end