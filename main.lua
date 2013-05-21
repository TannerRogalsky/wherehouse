-- screen / window init
SCREEN_WIDTH, SCREEN_HEIGHT = MOAIEnvironment.screenWidth or 720, MOAIEnvironment.screenHeight or 1280
SCREEN_UNITS_X, SCREEN_UNITS_Y = 720, 1280
MOAISim.openWindow("Test", SCREEN_WIDTH, SCREEN_HEIGHT )

-- main simulation loop -- sandboxed
do
  local mainThread = MOAICoroutine.new ()
  mainThread:run(function()
    while true do
      local dt = MOAISim.getStep()
      -- game.update(dt)
      coroutine.yield()
    end
  end)
end
