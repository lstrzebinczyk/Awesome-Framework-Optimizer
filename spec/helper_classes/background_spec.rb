require 'spec_helper'

describe Background do
  describe 'draw' do
    it 'creates a Presenter object and calls draw on it' do
      Background::Presenter.any_instance.should_receive(:draw)
      Background.new.draw
    end
  end
end
