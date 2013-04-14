class Background
  class Presenter
    def draw
      configuration.window.draw_quad( 0, 0, 0xffffffff, 
                                      configuration.window_x, 0, 0xffffffff, 
                                      configuration.window_x, configuration.window_y, 0xffffffff, 
                                      0, configuration.window_y, 0xffffffff, 0)
    end

    private

    def configuration
      @config ||= Configuration.global
    end
  end
end