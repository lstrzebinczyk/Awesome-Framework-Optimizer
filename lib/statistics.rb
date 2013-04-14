class Statistics
  attr_reader :time, :begin_time, :last_goal, :time_step
  attr_accessor :goals

  def initialize(framework)
    @framework = framework

    @time       = Time.now
    @begin_time = Time.now
    @goals  = [1000000.0]
  end

  def draw_status_1
    Presenter.new(self).draw_status_1
  end

  def draw_status_2
    Presenter.new(self).draw_status_2
  end

  def update!(goal = nil)
    @time_step = Time.now - @time
    @time = Time.now

    if goal
      @goals << goal
    end
  end

  def time_from_start
    Time.now - @begin_time
  end

  def points_size
    @framework.points.size
  end

  def max_energy
    @framework.max_energy
  end

  def good_enough?
    @goals.last >= @goals[-2] * 1.01
  end

  def optimization
    @goals.last / @goals.first
  end
end