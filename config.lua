function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
function pointInCircle(circle, point) return (point.x-circle.x)^2 + (point.y - circle.y)^2 < circle.radius^2 end
function string:split(sep) return self:match((self:gsub("[^"..sep.."]*"..sep, "([^"..sep.."]*)"..sep))) end
globalID = 0
function generateID() globalID = globalID + 1 return globalID end
function is_num(v) return type(v) == "number" end
function is_func(v) return type(v) == "function" end

require 'lib/resource_definitions'
require 'lib/resource_manager'

beholder = require 'lib/beholder'
InputManager = require 'lib/input_manager'

require 'lib/middleclass'
Stateful = require 'lib/stateful'
Grid = require 'lib/grid'
AStar = require 'lib/astar'

require 'base'
require 'game'

require 'states/game/game_main'
