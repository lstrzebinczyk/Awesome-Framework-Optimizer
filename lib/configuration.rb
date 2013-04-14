class Configuration
  attr_reader :stiff, :force, :energy_limit, :min_field, :max_field

  def initialize
    @stiff = 20.0
    @force = -7.5

    @energy_limit = 0.05
    @max_field = 40
    @min_field = 0.1
    @min_angle = 40
  end

  def max_angle_cos
    Math.cos (@min_angle * Math::PI / 360.0)
  end
end