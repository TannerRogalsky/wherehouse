-- screen / window init
SCREEN_WIDTH, SCREEN_HEIGHT = MOAIEnvironment.screenWidth or 720, MOAIEnvironment.screenHeight or 1280
SCREEN_UNITS_X, SCREEN_UNITS_Y = 720, 1280
MOAISim.openWindow("Template", SCREEN_WIDTH, SCREEN_HEIGHT )


-- requirements
dofile("config.lua")

-- initialize things here
beholder.observe("key_down", "esc", function()
  os.exit()
end)
local game = Game:new()


-- main simulation loop
local mainThread = MOAICoroutine.new ()
mainThread:run(function()
  while true do
    local dt = MOAISim.getStep()
    -- game.update(dt)
    coroutine.yield()
  end
end)
