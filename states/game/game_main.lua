local Main = Game:addState('Main')

function Main:enteredState()
  self.map = Map:new(0, 0, 14, 14, 50, 50)
  self.map:add_to_layer(self.action_layer)

  local sprite = MOAIProp2D.new()
  local sprite_image = MOAIGfxQuad2D.new()
  sprite_image:setTexture("images/50x50__0005_tilted-box-2.png")
  sprite_image:setRect(-25, -25, 25, 25)
  sprite:setDeck(sprite_image)

  self.map:add(1, 1, sprite)

  sprite = MOAIProp2D.new()
  self.sprite_image = MOAIGfxQuad2D.new()
  self.sprite_image:setTexture("images/50x50_0005_1x1-leaking-box.png")
  self.sprite_image:setRect(-25, -25, 25, 25)
  sprite:setDeck(self.sprite_image)

  self.map:add(2, 2, sprite)
end

function Main:mouse_down(x, y, button)
  local grid_x, grid_y = self.map:world_to_grid_coords(x, y)
  print(grid_x, grid_y)
  local sprite = MOAIProp2D.new()
  sprite:setDeck(self.sprite_image)
  self.map:add(grid_x, grid_y, sprite)
end

function Main:mouse_up(x, y, button)
end

function Main:mouse_moved(x, y)
end

function Main:key_down(key, unicode)
end

function Main:key_up(key, unicode)
end

function Main:exitedState()
end

function Main:quit()
end

return Main
