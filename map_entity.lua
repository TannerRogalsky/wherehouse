MapEntity = class('MapEntity', Base)
MapEntity.static.tween_time = 0.3

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
  self.prop:setAttrLink(MOAIProp2D.INHERIT_LOC, self.parent.grid_prop, MOAIProp2D.TRANSFORM_TRAIT)

  self.prop:setDeck(self.parent.tileset)
end

function MapEntity:move(delta_x, delta_y)
  if self.out_tween == nil and self.in_tween == nil then
    local out_direction = Direction[delta_x][delta_y]

    self:remove_from_grid()
    self.parent.layer:removeProp(self.prop)

    local out_grid_x, out_grid_y = self.x, self.y
    local out_model_x, out_model_y = self.parent:grid_to_model_coords(out_grid_x, out_grid_y)
    local out_model_target_x, out_model_target_y = self.parent:grid_to_model_coords(out_grid_x + out_direction.x, out_grid_y + out_direction.y)

    -- move based on directional sibling
    local sibling = self.parent.grid:g(self.x, self.y).siblings[out_direction]
    self.x, self.y = sibling.x, sibling.y


    local in_grid_x, in_grid_y = self.x, self.y
    local in_model_x, in_model_y = self.parent:grid_to_model_coords(in_grid_x - out_direction.x, in_grid_y - out_direction.y)
    local in_model_target_x, in_model_target_y = self.parent:grid_to_model_coords(in_grid_x, in_grid_y)

    -- we need two props
    self.out_prop = MOAIProp2D.new()
    self.out_prop:setLoc(out_model_x, out_model_y)
    self.out_prop:setAttrLink(MOAIProp2D.INHERIT_LOC, self.parent.grid_prop, MOAIProp2D.TRANSFORM_TRAIT)
    self.out_prop:setDeck(self.parent.tileset)
    self.parent.layer:insertProp(self.out_prop)

    self.in_prop = MOAIProp2D.new()
    self.in_prop:setLoc(in_model_x, in_model_y)
    self.in_prop:setAttrLink(MOAIProp2D.INHERIT_LOC, self.parent.grid_prop, MOAIProp2D.TRANSFORM_TRAIT)
    self.in_prop:setDeck(self.parent.tileset)
    self.parent.layer:insertProp(self.in_prop)

    -- tween!
    self.out_tween = self.out_prop:seekLoc(out_model_target_x, out_model_target_y, MapEntity.tween_time, MOAIEaseType.LINEAR)
    self.in_tween = self.in_prop:seekLoc(in_model_target_x, in_model_target_y, MapEntity.tween_time, MOAIEaseType.LINEAR)

    -- set scissors
    local out_scissor = MOAIScissorRect.new()
    out_scissor:setRect(-25, -25, 25, 25)
    out_scissor:setLoc(out_model_x, out_model_y)
    out_scissor:setAttrLink(MOAIProp2D.INHERIT_LOC, self.parent.grid_prop, MOAIProp2D.TRANSFORM_TRAIT)
    self.out_prop:setScissorRect(out_scissor)

    local in_scissor = MOAIScissorRect.new()
    in_scissor:setRect(-25, -25, 25, 25)
    in_scissor:setLoc(in_model_target_x, in_model_target_y)
    in_scissor:setAttrLink(MOAIProp2D.INHERIT_LOC, self.parent.grid_prop, MOAIProp2D.TRANSFORM_TRAIT)
    self.in_prop:setScissorRect(in_scissor)

    -- clear tween and scissor
    self.out_tween:setListener(MOAIAction.EVENT_STOP, function()
      self.out_tween = nil
      self.out_prop:setScissorRect()
      self.parent.layer:removeProp(self.out_prop)
      self.out_prop = nil
    end)

    self.in_tween:setListener(MOAIAction.EVENT_STOP, function()
      self.in_tween = nil
      self.in_prop:setScissorRect()
      self.prop = self.in_prop
      self.in_prop = nil
    end)

    self:insert_into_grid()
  end
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
