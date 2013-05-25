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
  self.x, self.y = self.x + delta_x, self.y + delta_y
  self.prop:setLoc(self.parent:grid_to_model_coords(self.x, self.y))
end
