class Background
  class Presenter < Presenter
    def draw
      config.window.draw_quad( 0,               0,               0xffffffff, 
                               config.window_x, 0,               0xffffffff, 
                               config.window_x, config.window_y, 0xffffffff, 
                               0,               config.window_y, 0xffffffff)
    end
  end
end