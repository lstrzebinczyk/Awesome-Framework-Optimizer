class Presenter
  private

  def configuration
    @config ||= Configuration.global
  end

  def draw_line(p1_x, p1_y, p2_x, p2_y)
    configuration.window.draw_line(
      rescale(p1_x), configuration.window_y - rescale(p1_y), 0xff000000, 
      rescale(p2_x), configuration.window_y - rescale(p2_y), 0xff000000)
  end

  def draw_triangle(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, color)
    configuration.window.draw_triangle( rescale(p1_x), configuration.window_y - rescale(p1_y), color, 
                                        rescale(p2_x), configuration.window_y - rescale(p2_y), color,
                                        rescale(p3_x), configuration.window_y - rescale(p3_y), color)
  end

  def rescale(number)
    configuration.translate + number * configuration.scale
  end
end