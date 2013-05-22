module ( "ResourceManager", package.seeall )

ASSETS_PATH = 'assets/'

local cache = {}

------------------------------------------------
-- get ( string: name )
-- returns the object defined by 'name'
-- and puts it in the cache if it was not 
-- already there.
------------------------------------------------
function ResourceManager:get ( name )
 
  -- If the resource is not on the cache
  -- we load it.
  if ( not self:loaded ( name ) ) then
    self:load ( name )
  end
  
  -- return the object indexed by 'name'
  -- on our local cache
  return cache[name]
end


------------------------------------------------
-- loaded ( string: name )
-- returns true if the cache has an object
-- indexed by 'name' that is not nil.
------------------------------------------------
function ResourceManager:loaded ( name )
  return cache[name] ~= nil
end


------------------------------------------------
-- load ( string: name )
-- creates the object based on the definition
-- and stores is on the cache.
------------------------------------------------
function ResourceManager:load ( name )
  local resourceDefinition = ResourceDefinitions:get ( name )

  if not resourceDefinition then
    -- Error handling for missing resource definition
    print ( "ERROR: Missing resource definition for " .. name )
  else
    -- resource will hold the object returned by
    -- our initialization methods
    local resource
    
    print ( name, resourceDefinition.type )
    -- we load the resource based on its type
    if ( resourceDefinition.type == RESOURCE_TYPE_IMAGE ) then
      resource = self:loadImage ( resourceDefinition )
    elseif ( resourceDefinition.type == RESOURCE_TYPE_TILED_IMAGE ) then
      resource = self:loadTiledImage ( resourceDefinition )
    elseif ( resourceDefinition.type == RESOURCE_TYPE_FONT ) then
      resource = self:loadFont ( resourceDefinition )
    elseif ( resourceDefinition.type == RESOURCE_TYPE_SOUND ) then
      resource = self:loadSound ( resourceDefinition )
    end
    
    -- store the resource under the name on cache
    cache[name] = resource
  end
end


------------------------------------------------
-- unload ( string: name )
-- removes the cached object pointed by 'name'
-- from cache.
------------------------------------------------
function ResourceManager:unload ( name )
  
  -- if the name is not nil, we replace
  -- the object referenced by 'name' on the
  -- 'cache' table allowing it to be garbage 
  -- collected if there are no external 
  -- references.
  if name then
    cache[name] = nil
  end
  
end


------------------------------------------------
-- loadImage ( table: definition )
-- loads the image object defined in 
-- 'definition'.
------------------------------------------------
function ResourceManager:loadImage ( definition )
  -- image will hold the final object
  local image
  
  -- filePath is the full image path name,
  -- we need to append the file name to ASSETS_PATH
  local filePath = ASSETS_PATH .. definition.fileName
  
  if definition.coords then
    -- load the image specified by its coordinates
    image = self:loadGfxQuad2D ( filePath, definition.coords )
  else
    -- load the entire image specified by its size
    local halfWidth = definition.width / 2
    local halfHeight = definition.height / 2
    image = self:loadGfxQuad2D ( filePath, { -halfWidth, -halfHeight, halfWidth, halfHeight } )
  end
  
  -- return the final image
  return image
end


------------------------------------------------
-- loadGfxQuad2D ( string: filePath, table: coords )
-- returns the MOAIGfxQuad2D created using 
-- filePath and coordinates from 'coords'.
------------------------------------------------
function ResourceManager:loadGfxQuad2D ( filePath, coords )
  
  -- We create the MOAIGfxQuad2D object
  local image = MOAIGfxQuad2D.new ()
  
  -- We tell it to use the texture
  -- located at filePath
  image:setTexture ( filePath )
  
  -- We define the rectangle that the
  -- image will grab its texture from
  image:setRect ( unpack ( coords ) )
  
  -- return the final image
  return image
end


------------------------------------------------
-- loadTiledImage ( table: definition )
-- loads the image object defined in 
-- 'definition', using MOAITileDeck2D.
------------------------------------------------
function ResourceManager:loadTiledImage ( definition )
  
  -- We create the MOAITileDeck2D object
  local tiledImage = MOAITileDeck2D.new ()
  
  -- filePath is the full image path name,
  -- we need to append the file name to ASSETS_PATH
  local filePath = ASSETS_PATH .. definition.fileName

  -- We set all the data gathered from
  -- 'definition'.
  tiledImage:setTexture ( filePath )
  tiledImage:setSize ( unpack ( definition.tileMapSize ) )
  
  -- If width and height is defined, we set
  -- the rectangle for the image.
  if definition.width and definition.height then
    local half_width = definition.width / 2
    local half_height = definition.height / 2
    tiledImage:setRect ( -half_width, -half_height, half_width, half_height )
  end
  -- return the final image
  return tiledImage
  
end


------------------------------------------------
-- loadFont ( table: definition )
-- loads the font object defined in 
-- 'definition'.
------------------------------------------------
function ResourceManager:loadFont ( definition )
  
  -- Create the MOAIFont object
  local font = MOAIFont.new ()
  
  -- filePath is the full image path name,
  -- we need to append the file name to ASSETS_PATH
  local filePath = ASSETS_PATH .. definition.fileName

  -- Load the ttf using all the info from
  -- 'definitions'
  font:loadFromTTF ( filePath, definition.glyphs, 
    definition.fontSize, definition.dpi )
  
  -- return the final font
  return font
end


------------------------------------------------
-- loadSound ( table: definition )
-- loads the sound object defined in 
-- 'definition'. We use Untz engine in this 
-- example.
------------------------------------------------
function ResourceManager:loadSound ( definition )

  -- Create the MOAIUntzSound object
  local sound = MOAIUntzSound.new ()
  
  -- filePath is the full image path name,
  -- we need to append the file name to ASSETS_PATH
  local filePath = ASSETS_PATH .. definition.fileName
  
  -- Load the sound using all the info from
  -- 'definitions'
  sound:load ( filePath )
  sound:setVolume ( definition.volume )
  sound:setLooping ( definition.loop )
  
  -- return the final sound
  return sound
end
