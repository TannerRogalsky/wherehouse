MapTile = class('MapTile', Base)

function MapTile:initialize(parent, x, y)
  Base.initialize(self)
  self.parent = parent
  self.x = x
  self.y = y

  self.content = {}
  self.siblings = {}
end

function MapTile:has_content()
  if next(self.content) then
    return true
  else
    return false
  end
end
