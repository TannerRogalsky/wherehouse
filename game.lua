Game = class('Game', Base):include(Stateful)

function Game:initialize()
  Base.initialize(self)

  beholder.group(self, function()
    -- the anonymous function wrapping the call to the actual function is a stupid hack that totally works
    beholder.observe("mouse_down", function(x, y, button)
      local world_x, world_y = self.action_layer:wndToWorld(x, y)
      self:mouse_down(world_x, world_y, button)
    end)
    beholder.observe("mouse_up", function(x, y, button)
      local world_x, world_y = self.action_layer:wndToWorld(x, y)
      self:mouse_up(world_x, world_y, button)
    end)
    beholder.observe("mouse_moved", function(x, y)
      local world_x, world_y = self.action_layer:wndToWorld(x, y)
      self:mouse_moved(world_x, world_y)
    end)
    beholder.observe("key_down", function(key, unicode)
      self:key_down(key, unicode)
    end)
    beholder.observe("key_up", function(key, unicode)
      self:key_up(key, unicode)
    end)
  end)

  self.viewport = MOAIViewport.new()
  self.viewport:setSize(SCREEN_WIDTH, SCREEN_HEIGHT)
  self.viewport:setScale (SCREEN_UNITS_X, SCREEN_UNITS_Y)

  self.action_layer = MOAILayer2D.new()
  self.action_layer:setViewport(self.viewport)
  MOAISim.pushRenderPass(self.action_layer)

  self:gotoState("Main")
end

function Game:mouse_down(x, y, button)
  print(x, y, button)
end

function Game:mouse_up(x, y, button)
  print(x, y, button)
end

function Game:mouse_moved(x, y)
  print(x, y)
end

function Game:key_down(key, unicode)
  print(key, unicode)
end

function Game:key_up(key, unicode)
  print(key, unicode)
end
