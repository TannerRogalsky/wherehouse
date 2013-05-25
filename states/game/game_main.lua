local Main = Game:addState('Main')

function Main:enteredState()
  self.map = Map:new(0, 0, 14, 14, 50, 50)
  self.map:add_to_layer(self.action_layer)

  sprite_image = MOAIGfxQuad2D.new()
  sprite_image:setTexture("images/50x50__0005_tilted-box-2.png")
  sprite_image:setRect(-25, -25, 25, 25)


  local map_entity = MapEntity:new(self.map, 1, 1)
  self.map:add_entity(map_entity)

  self.mover = map_entity
end

function Main:mouse_down(x, y, button)
  local grid_x, grid_y = self.map:world_to_grid_coords(x, y)
  print(next(self.map.grid:g(grid_x, grid_y).content))
end

function Main:mouse_up(x, y, button)
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
