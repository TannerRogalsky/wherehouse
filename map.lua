Map = class('Map', Base)

function Map:initialize(x, y, width, height, tile_width, tile_height)
  Base.initialize(self)
  assert(is_num(x) and is_num(y), "Position must be numbers.")
  assert(is_num(width) and is_num(height), "Grid size must be numbers.")
  assert(is_num(tile_width) and is_num(tile_height), "Tile size must be numbers.")

  self.x, self.y = x, y
  self.width, self.height = width, height
  self.tile_width, self.tile_height = tile_width, tile_height

  -- this grid prop is just for ease of getting coords for the actual grid
  self.grid_prop = MOAIProp2D.new()
  local moai_grid = MOAIGrid.new()
  moai_grid:setSize(width, height, tile_width, tile_height)
  self.grid_prop:setGrid(moai_grid)
  -- center the prop based on grid size + the position that was provided
  self.grid_prop:setScl(1, -1)
  self.grid_prop:setLoc(-width / 2 * tile_width, height / 2 * tile_height)
  self.grid_prop:addLoc(x, y)

  -- this is the real grid that has stuff in it
  self.grid = Grid:new(width, height)
  for x,y,_ in self.grid:each() do
    self.grid[x][y] = MapTile:new(self, x, y)
  end

  self.entities = {}
  self.layers = {
    background = MOAILayer2D.new(),
    main = MOAILayer2D.new(),
    foreground = MOAILayer2D.new()
  }
end

-- position is a MOAIGridSpace position (default MOAIGridSpace.TILE_CENTER)
function Map:grid_to_world_coords(grid_x, grid_y, position)
  local model_x, model_y = self:grid_to_model_coords(grid_x, grid_y, position)
  local world_x, world_y = self.grid_prop:modelToWorld(model_x, model_y)
  return world_x, world_y
end

function Map:grid_to_model_coords(grid_x, grid_y, position)
  local moai_grid = self.grid_prop:getGrid()
  local model_x, model_y = moai_grid:getTileLoc(grid_x, grid_y, position)
  return model_x, model_y
end

function Map:world_to_grid_coords(world_x, world_y)
  local moai_grid = self.grid_prop:getGrid()
  local model_x, model_y = self.grid_prop:worldToModel(world_x, world_y)
  local grid_x, grid_y = moai_grid:locToCoord(model_x, model_y)
  return grid_x, grid_y
end

function Map:get_layers()
  local ls = self.layers
  return {ls.background, ls.main, ls.foreground}
end

function Map:add_entity(entity, layer)
  assert(instanceOf(MapEntity, entity))
  layer = layer or self.layers.main
  entity:insert_into_grid()
  entity.layer = layer
  self.entities[entity.id] = entity
  self.layers.main:insertProp(entity.prop)
end

function Map:remove_entity(entity, layer)
  assert(instanceOf(MapEntity, entity))
  layer = layer or self.layers.main
  entity:remove_from_grid()
  entity.layer = layer
  self.entities[entity.id] = entity
  self.layers.main:removeProp(entity.prop)
end
