module ( "InputManager", package.seeall )

------------------------------------------------
-- initialize ( )
-- Setups the callback for updating pointer
-- position on both mouse and touches
------------------------------------------------
function InputManager:initialize ()

  function onKeyboardEvent ( key, down )
    if key == 119 then key = 'up' end
    if key == 97 then key = 'left' end
    if key == 100 then key = 'right' end
    -- Game:keyPressed ( key, down )
  end

  MOAIInputMgr.device.keyboard:setCallback ( onKeyboardEvent )

  if MOAIInputMgr.device.pointer then
    local function mouse_callback(down, button)
      local x, y = MOAIInputMgr.device.pointer:getLoc()

      -- if down == true then game.mouse_pressed(x, y, button)
      -- elseif down == false then game.mouse_released(x, y, button)
      -- else game.mouse_moved(x, y) end
    end

    MOAIInputMgr.device.mouseLeft:setCallback(function(down) mouse_callback(down, "left") end)
    MOAIInputMgr.device.mouseRight:setCallback(function(down) mouse_callback(down, "right") end)
    MOAIInputMgr.device.mouseMiddle:setCallback(function(down) mouse_callback(down, "middle") end)
    MOAIInputMgr.device.pointer:setCallback(function(down) mouse_callback(down, "moved") end)
  else
    MOAIInputMgr.device.touch:setCallback(
      function(eventType, idx, x, y, tapCount)
        if eventType == MOAITouchSensor.TOUCH_DOWN then
          -- game.mouse_pressed(x, y, "touch")
        elseif eventType == MOAITouchSensor.TOUCH_UP then
          -- game.mouse_released(x, y, "touch")
        elseif eventType == MOAITouchSensor.TOUCH_MOVE then
          -- game.mouse_moved(x, y)
        end
      end)
  end
end

