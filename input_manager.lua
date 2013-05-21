module ( "InputManager", package.seeall )

------------------------------------------------
-- initialize ( )
-- Setups the callback for updating pointer
-- position on both mouse and touches
------------------------------------------------
function InputManager:initialize ()

  function on_keyboard_event ( key, down )
    -- game:keyPressed ( InputManager.key_map[key] or key, down )
  end

  MOAIInputMgr.device.keyboard:setCallback ( on_keyboard_event )

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

InputManager.key_map = {
  [119] = "up",
  [97] = "left",
  [100] = "right",
  [27] = "esc"
}

