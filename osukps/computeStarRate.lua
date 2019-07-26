local omppc = require("omppc")

local parse = function(path)
	local file = io.open(path, "r")
	
	local playData = omppc.PlayData:new()
	playData.modsData = ""
	playData.beatmapString = file:read("*all")
	playData.score = 1000000
	playData:process()
	
	file:close()
	
	local data = playData:getData()
	
	assert(data.starRate > 0)
	assert(data.noteCount > 0)
	local noteData = playData.beatmap.noteData
	data.length = (noteData[#noteData].startTime - noteData[1].startTime) / 1000
	data.kps = data.noteCount / data.length
	
	return data
end

local mapsFile = io.open("maps.txt", "r")
local mapList = {}
print("reading maps")
for line in mapsFile:lines() do
	mapList[#mapList + 1] = line
end

local position = 0
local mapData = {}
print("calculation starrate")
for i = 1, #mapList do
	local path = mapList[i]
	local status, err = pcall(parse, path)
	if status then
		mapData[#mapData + 1] = err
	end
	local newPosition = math.floor(i / #mapList * 100)
	if newPosition > position then
		position = newPosition
		print(("%3s%%"):format(position))
	end
end

print("export to json")
local json = require("json")
local jsonFile = io.open("data.json", "w")
jsonFile:write(json.encode(mapData))
jsonFile:close()
