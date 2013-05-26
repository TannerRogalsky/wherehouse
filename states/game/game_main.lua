local Main = Game:addState('Main')

function Main:enteredState()
  self.map = MapLoader.load("test")

  local map_entity = MapEntity:new(self.map, 1, 1)
  self.map:add_entity(map_entity)

  self.mover = map_entity

  local layers = self.map:get_layers()
  for _,layer in ipairs(layers) do
    layer:setViewport(self.viewport)
  end
  MOAIRenderMgr.setRenderTable(layers)

  self.mouse_down_pos = nil
end

function Main:mouse_down(x, y, button)
  local grid_x, grid_y = self.map:world_to_grid_coords(x, y)
  print(self.map.grid:g(grid_x, grid_y):has_content())

  self.mouse_down_pos = {x = x, y = y}
end

function Main:mouse_up(x, y, button)
  if self.mouse_down_pos then
    -- TODO this could use some tolerances
    local down = self.mouse_down_pos
    local delta_x, delta_y = down.x - x, down.y - y

    -- only use the largest
    if math.abs(delta_x) > math.abs(delta_y) then
      delta_y = 0
    else
      delta_x = 0
    end

    delta_x = math.clamp(-1, delta_x, 1)
    delta_y = math.clamp(-1, delta_y, 1)

    local direction = Direction[-delta_x][delta_y]
    if direction then
      self.mover:move(direction:unpack())
    end

    self.mouse_down_pos = nil
  end
end

function Main:mouse_moved(x, y)
end

local control_map = {
  keyboard = {
    w = function(self) self.mover:move(Direction.NORTH:unpack()) end,
    s = function(self) self.mover:move(Direction.SOUTH:unpack()) end,
    a = function(self) self.mover:move(Direction.WEST:unpack()) end,
    d = function(self) self.mover:move(Direction.EAST:unpack()) end
  }
}

function Main:key_down(key, unicode)
  local action = control_map.keyboard[key]
  if type(action) == "function" then action(self) end
end

function Main:key_up(key, unicode)
end

function Main:exitedState()
end

function Main:quit()
end

return Main
