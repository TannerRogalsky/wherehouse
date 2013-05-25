MapEntity = class('MapEntity', Base)

function MapEntity:initialize(parent, x, y, width, height)
  Base.initialize(self)
  assert(is_num(x) and is_num(y), "Position must be numbers.")
  assert(is_num(width) or width == nil)
  assert(is_num(height) or height == nil)

  self.x, self.y = x, y
  self.width, self.height = width or 1, height or 1

  self.parent = parent

  self.prop = MOAIProp2D.new()
  self.prop:setLoc(self.parent:grid_to_model_coords(self.x, self.y))
  self.prop:setScl(1, -1)
  self.prop:setAttrLink(MOAIProp2D.INHERIT_TRANSFORM, parent.grid_prop, MOAIProp2D.TRANSFORM_TRAIT)

  self.prop:setDeck(sprite_image)
end

function MapEntity:move(delta_x, delta_y)
  self:remove_from_grid()
  self.x, self.y = self.x + delta_x, self.y + delta_y
  self.prop:setLoc(self.parent:grid_to_model_coords(self.x, self.y))
  self:insert_into_grid()
end

function MapEntity:insert_into_grid()
  for _, _, tile in self.parent.grid:each(self.x, self.y, self.width, self.height) do
      tile.content[self.id] = self
  end
end

function MapEntity:remove_from_grid()
  for _, _, tile in self.parent.grid:each(self.x, self.y, self.width, self.height) do
      tile.content[self.id] = nil
  end
end
