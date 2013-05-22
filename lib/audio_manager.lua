module ( "AudioManager", package.seeall )

local audio_definitions = {
  
  backgroundMusic = {
    fileName = 'sounds/music.mp3', 
    type = RESOURCE_TYPE_SOUND, 
    loop = true,
    volume = 1
  },
  
  jump = {
    fileName = 'sounds/jump.wav', 
    type = RESOURCE_TYPE_SOUND, 
    loop = false,
    volume = 1
  }
}

sounds = {}

------------------------------------------------
-- initialize ( )
-- initializes the audio manager
------------------------------------------------
function AudioManager:initialize ()
  -- First of all, we need to load
  -- all the audio definitions
  -- into ResourceDefinitions.
  ResourceDefinitions:setDefinitions ( audio_definitions )
  
  -- Since we're using Untz, we need 
  -- to initialize it.
  MOAIUntzSystem.initialize ()
  
end
  
------------------------------------------------
-- play ( string: name, bool: loop )
-- if it was previously defined, it starts
-- playback for the audio referenced by 'name'.
-- If 'loop' parameter is true, the audio
-- will be repeated constantly.
------------------------------------------------
function AudioManager:play ( name, loop )

  -- Load the sound if it was not 
  -- loaded previously.
  local audio = AudioManager:get ( name )

  -- We use the 'loop' parameter
  -- if it was passed to override
  -- looping.
  if loop ~= nil then
    audio:setLooping ( loop )
  end
  
  -- We play the sound
  audio:play ()
  
end

------------------------------------------------
-- get ( string: name )
-- loads the sound if it was not loaded before.
-- this is useful to preload sounds.
------------------------------------------------
function AudioManager:get ( name )  

  -- First we check if the sound
  -- was loaded, and if it wasn't
  -- we load it.
  local audio = self.sounds[name]
  
  if not audio then 
    audio = ResourceManager:get ( name )
    self.sounds[name] = audio
  end
  
  return audio
end

------------------------------------------------
-- stop ( string: name )
-- if the audio referenced by 'name' is playing
-- it stops the playback.
------------------------------------------------
function AudioManager:stop ( name )
  
  -- Load the sound if it was not 
  -- loaded previously.
  local audio = AudioManager:get ( name )
  
  audio:stop ()
  
end

------------------------------------------------
-- fadeIn ( string: name, number: time, 
--   number: maxVolume)
-- it plays the audio referenced by 'name' if 
-- it was not playing and goes from 0 to 
-- maxVolume.
-- The 'time' parameter defines the duration
-- of the fadeIn.
------------------------------------------------
function AudioManager:fadeIn ( name, time, maxVolume )
end
  
------------------------------------------------
-- fadeOut ( string: name, number: time )
-- it plays the audio referenced by 'name' if 
-- it was not playing and goes from its current
-- volume to 0. 
-- The 'time' parameter defines the duration
-- of the fadeOut.
------------------------------------------------
function AudioManager:fadeOut ( name )
end