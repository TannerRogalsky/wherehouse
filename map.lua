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
end

-- position is a MOAIGridSpace position (default MOAIGridSpace.TILE_CENTER)
function Map:grid_to_world_coords(grid_x, grid_y, position)
  local moai_grid = self.grid_prop:getGrid()
  local model_x, model_y = moai_grid:getTileLoc(grid_x, grid_y, position)
  local world_x, world_y = self.grid_prop:modelToWorld(model_x, model_y)
  -- print(world_x, world_y, model_x, model_y, grid_x, grid_y)
  return world_x, world_y
end

function Map:world_to_grid_coords(world_x, world_y)
  local moai_grid = self.grid_prop:getGrid()
  local model_x, model_y = self.grid_prop:worldToModel(world_x, world_y)
  local grid_x, grid_y = moai_grid:locToCoord(model_x, model_y)
  -- print(world_x, world_y, model_x, model_y, grid_x, grid_y)
  return grid_x, grid_y
end

function Map:add_to_layer(layer)
  self.layer = layer
end

function Map:remove_from_layer()
  self.layer = nil
end

function Map:add(x, y, prop)
  local world_x, world_y = self:grid_to_world_coords(x, y)
  print(world_x, world_y)
  prop:setLoc(world_x, world_y)
  self.layer:insertProp(prop)
end
