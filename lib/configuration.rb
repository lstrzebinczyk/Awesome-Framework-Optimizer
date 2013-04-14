class Configuration
  attr_reader :stiff, :force, :energy_limit, :min_field, :max_field, :window_x, :window_y, :scale, :translate, :window
  attr_writer :window

  def initialize(window = nil)
    @stiff = 20.0
    @force = -7.5

    @energy_limit = 0.05
    @max_field = 40
    @min_field = 0.1
    @min_angle = 40

    @window_x = 1200
    @window_y = 600

    @scale = 15
    @translate = @window_y * 0.1
  end

  def max_angle_cos
    Math.cos (@min_angle * Math::PI / 360.0)
  end

  def self.global
    @config ||= self.new
  end
end