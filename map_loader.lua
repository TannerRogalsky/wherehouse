MapLoader = class('MapLoader', Base)
MapLoader.static.maps_folder = "levels/"

function MapLoader.load(map_name)
  local path = MapLoader.maps_folder .. map_name
  local map_data = require(path)
  local map = Map:new(0, 0, map_data.width, map_data.height, map_data.tilewidth, map_data.tileheight)

  -- grab the tileset info from the data and build it
  local tileset_data = map_data.tilesets[1]
  local tileset = MOAITileDeck2D.new()
  local tileset_texture = MOAITexture.new()
  tileset_texture:load(MapLoader.fix_relative_path(tileset_data.image))
  tileset:setTexture(tileset_texture)
  -- this setSize takes the size of the spritesheet grid
  tileset:setSize(math.floor(tileset_data.imagewidth / tileset_data.tilewidth), math.floor(tileset_data.imageheight / tileset_data.tileheight))
  tileset:setRect(-tileset_data.tilewidth / 2, - tileset_data.tileheight / 2, tileset_data.tilewidth / 2, tileset_data.tileheight / 2)
  map.tileset = tileset

  -- layers by type and name
  local layers = {}
  for _,layer in ipairs(map_data.layers) do
    if layers[layer.type] == nil then layers[layer.type] = {} end
    layers[layer.type][layer.name] = layer
  end

  map:set_background(MapLoader.fix_relative_path(layers.imagelayer["Background"].image))

  for index,tile_data in ipairs(layers.objectgroup["Nodes"].objects) do
    local grid_x, grid_y = tile_data.x / map_data.tilewidth + 1, tile_data.y / map_data.tileheight + 1
    local tile = map.grid:g(grid_x, grid_y)

    for _,direction in ipairs(Direction.list) do
      local sibling_name = tile_data.properties["sibling_"  .. direction.cardinal_name:lower()]

      if sibling_name then
        local sibling_x, sibling_y = MapLoader.parse_grid_coords(sibling_name)
        local sibling = map.grid:g(sibling_x, sibling_y)

        tile.siblings[direction] = sibling
      end
    end
  end

  for name, tilelayer in pairs(layers.tilelayer) do
    for i,tileset_index in ipairs(tilelayer.data) do
      i = i - 1
      local x = i % map.width + 1
      local y = math.floor(i / map.width) + 1
      if tileset_index > 0 then
        MapLoader.build_entity(map, x, y, tileset_index)
      end
    end
  end


  return map
end

function MapLoader.parse_grid_coords(sibling_name)
  local x, y = sibling_name:match("n_(..)(..)")
  return tonumber(x), tonumber(y)
end

function MapLoader.fix_relative_path(asset_path)
  return asset_path:gsub(".*/images", "images")
end

function MapLoader.build_entity(map, x, y, tileset_index)
  local entity = MapEntity:new(map, x, y)
  entity:set_index(tileset_index)
  map:add_entity(entity)
end
