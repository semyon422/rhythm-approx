local json = require("json")
local jsonFile = io.open("data.json", "r")
print("reading maps")
local mapData = json.decode(jsonFile:read("*all"))
jsonFile:close()

local sumx, sumx2, sumxy, sumy = 0, 0, 0, 0
for i = 1, #mapData do
	local data = mapData[i]
	sumx = sumx + data.kps
	sumx2 = sumx2 + data.kps ^ 2
	sumxy = sumxy + data.kps * data.starRate
	sumy = sumy + data.starRate
end

local n = #mapData
local a = (n * sumxy - sumx * sumy) / (n * sumx2 - sumx * sumx)
local b = (sumy - a * sumx) / n

print("writing result")
print(("y = %0.3fx + %0.3f"):format(a, b))
local file = io.open("linear.json", "w")
file:write(json.encode({a = a, b = b}))
