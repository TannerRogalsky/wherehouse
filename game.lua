Game = class('Game', Base):include(Stateful)

function Game:initialize()
  Base.initialize(self)

  beholder.group(self, function()
    -- the anonymous function wrapping the call to the actual function is a stupid hack that totally works
    beholder.observe("mouse_down", function(x, y, button) self:mouse_down(x, y, button) end)
    beholder.observe("mouse_up", function(x, y, button) self:mouse_up(x, y, button) end)
    beholder.observe("mouse_moved", function(x, y) self:mouse_moved(x, y) end)
    beholder.observe("key_down", function(key, unicode) self:key_down(key, unicode) end)
    beholder.observe("key_up", function(key, unicode) self:key_up(key, unicode) end)
  end)

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
