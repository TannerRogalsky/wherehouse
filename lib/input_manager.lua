local InputManager = {}


-- keyboard input
MOAIInputMgr.device.keyboard:setCallback(function(unicode, down)
  if down == true then
    beholder.trigger("key_down", InputManager.key_map[unicode], unicode)
  else
    beholder.trigger("key_up", InputManager.key_map[unicode], unicode)
  end
end)


-- mouse and touch input
if MOAIInputMgr.device.pointer then
  local function mouse_callback(down, button)
    local x, y = MOAIInputMgr.device.pointer:getLoc()

    if down == true then beholder.trigger("mouse_down", x, y, button)
    elseif down == false then beholder.trigger("mouse_up", x, y, button)
    else beholder.trigger("mouse_moved", x, y) end
  end

  MOAIInputMgr.device.mouseLeft:setCallback(function(down) mouse_callback(down, "left") end)
  MOAIInputMgr.device.mouseRight:setCallback(function(down) mouse_callback(down, "right") end)
  MOAIInputMgr.device.mouseMiddle:setCallback(function(down) mouse_callback(down, "middle") end)
  MOAIInputMgr.device.pointer:setCallback(function(down) mouse_callback(down, "moved") end)
else
  MOAIInputMgr.device.touch:setCallback(
    function(eventType, idx, x, y, tapCount)
      if eventType == MOAITouchSensor.TOUCH_DOWN then
        beholder.trigger("mouse_down", x, y, "touch")
      elseif eventType == MOAITouchSensor.TOUCH_UP then
        beholder.trigger("mouse_up", x, y, "touch")
      elseif eventType == MOAITouchSensor.TOUCH_MOVE then
        beholder.trigger("mouse_moved", x, y, "touch")
      end
    end)
end

-- map unicode value to human readable key code
InputManager.key_map = {
  [100] = "d",
  [115] = "s",
  [119] = "w",
  [27] = "esc",
  [97] = "a",
}

return InputManager
