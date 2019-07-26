local normalDistribution = function(x, s, m)
	return 1 / (s * math.sqrt(2 * math.pi)) * math.exp(-(x - m) ^ 2 / (2 * s ^ 2))
end

local osuAccuracy = function(dt, od)
	dt = math.abs(dt)
	if dt <= 64 - (3 * od) then
		return 100
	elseif dt <= 97 - (3 * od) then
		return 100 * 2 / 3
	elseif dt <= 127 - (3 * od) then
		return 100 / 3
	elseif dt <= 151 - (3 * od) then
		return 100 / 6
	else
		return 0
	end
end

local file = io.open("acc.txt", "w")
file:write(" s/od:\t")
for od = 0, 10 do
	file:write(("%6s\t"):format(od))
end
file:write("\n")

local a, b, h = -151, 151, 0.1
local m = 0
for s = 1, 160 do
	file:write(("%5d:\t"):format(s))
	for od = 0, 10 do
		local sum = 0
		for t = a, b - h, h do
			sum = sum + h * normalDistribution(t, s, m) * osuAccuracy(t, od)
		end
		file:write(("%6s\t"):format(("%0.2f"):format(sum)))
	end
	file:write("\n")
end
