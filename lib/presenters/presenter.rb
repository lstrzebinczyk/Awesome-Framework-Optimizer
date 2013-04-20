class Presenter
  include Configurable

  private

  def draw_line(p1_x, p1_y, p2_x, p2_y)
    config.window.draw_line(
      rescale(p1_x), config.window_y - rescale(p1_y), 0xff000000, 
      rescale(p2_x), config.window_y - rescale(p2_y), 0xff000000)
  end

  def draw_triangle(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, color)
    config.window.draw_triangle(rescale(p1_x), config.window_y - rescale(p1_y), color, 
                                rescale(p2_x), config.window_y - rescale(p2_y), color,
                                rescale(p3_x), config.window_y - rescale(p3_y), color)
  end

  def rescale(number)
    config.translate + number * config.scale
  end
end