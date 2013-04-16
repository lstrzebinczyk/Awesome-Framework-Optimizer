require 'gosu'
require 'narray'

require_relative 'models/line'
require_relative 'models/point'
require_relative 'models/polygon'
require_relative 'models/polygon/circle'
require_relative 'models/polygon/field'
require_relative 'models/polygon/stiff_matrix'
require_relative 'models/polygon/vector'
require_relative 'models/background'
require_relative 'models/framework'
require_relative 'models/fem_equation/stiff_matrix'
require_relative 'models/fem_equation/solver'
require_relative 'models/fem_equation/vector'
require_relative 'configuration'
require_relative 'statistics'
require_relative 'presenters/line'
require_relative 'presenters/background'
require_relative 'presenters/polygon'
require_relative 'presenters/framework'
require_relative 'presenters/statistics'
require_relative 'task/triangulation'
require_relative 'task/optimization'
require_relative 'task/idle'
require_relative 'window/gosu'