-- screen / window init
SCREEN_WIDTH, SCREEN_HEIGHT = MOAIEnvironment.screenWidth or 720, MOAIEnvironment.screenHeight or 1280
SCREEN_UNITS_X, SCREEN_UNITS_Y = 720, 1280
MOAISim.openWindow("Test", SCREEN_WIDTH, SCREEN_HEIGHT )


-- requirements
require 'resource_definitions'
require 'resource_manager'
require 'input_manager'


-- initialize things here
InputManager:initialize()
game_over = false


-- main simulation loop
local mainThread = MOAICoroutine.new ()
mainThread:run(function()
  while not game_over do
    local dt = MOAISim.getStep()
    -- game.update(dt)
    coroutine.yield()
  end
end)
