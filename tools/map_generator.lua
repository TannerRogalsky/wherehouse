local function newline(string)
  return string .. "\n"
end

local function main(x, y, w, h)
  print(x, y, w, h)

  local f = io.open("template.tmx", "w")
  local output = ""

  output = output .. newline([[<?xml version="1.0" encoding="UTF-8"?>]])
  output = output .. newline([[<map version="1.0" orientation="orthogonal" width="]] .. x .. [[" height="]] .. y .. [[" tilewidth="]] .. w .. [[" tileheight="]] .. h .. [[">]])

  -- tile layer
  output = output .. newline([[ <layer name="Tile Layer 1" width="]] .. x .. [[" height="]] .. y .. [[">]])
  output = output .. newline([[  <data>]])
  for i = 1, x * y do
    output = output .. newline([[   <tile gid="0"/>]])
  end
  output = output .. newline([[  </data>]])
  output = output .. newline([[ </layer>]])


  -- object layer
  output = output .. newline([[ <objectgroup name="Nodes" width="]] .. x .. [[" height="]] .. y .. [[">]])
  for i = 0, x - 1 do
    for j = 0, y - 1 do
      output = output .. newline([[  <object name="n_]] .. tostring(i) .. tostring(j) .. [[" x="]] .. i * w .. [[" y="]] .. j * h .. [[" width="]] .. w .. [[" height="]] .. h .. [[">]])
      -- properties ie. siblings
      output = output .. newline([[  </object>]])
    end
  end
  output = output .. newline([[ </objectgroup>]])

   --  <properties>
   --   <property name="blah" value="n_02"/>
   --  </properties>

  output = output .. newline([[</map>]])

  f:write(output)

  f:flush()
  f:close()
end

do
  local x, y = arg[1] or 14, arg[2] or 14
  local w, h = arg[3] or 50, arg[4] or 50
  main(x, y, w, h)
end
