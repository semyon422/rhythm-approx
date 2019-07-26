local json = require("json")

local data, w, h, a, b
love.load = function()
	love.window.setMode(1024, 576)
	w, h = love.graphics.getDimensions()
	
	local jsonFileData = io.open("data.json", "r")
	data = json.decode(jsonFileData:read("*all"))
	
	local jsonFileLinear = io.open("linear.json", "r")
	local linear = json.decode(jsonFileLinear:read("*all"))
	a = linear.a
	b = linear.b
end

local scale = 48
love.draw = function()
	love.graphics.setLineWidth(4)
	love.graphics.setColor(255, 255, 255, 63)
	for i = 0, w, scale do
		love.graphics.line(i, 0, i, h)
	end
	for i = 0, h, scale do
		love.graphics.line(0, i, w, i)
	end
	
	love.graphics.setColor(255, 255, 255, 63)
	for _, d in ipairs(data) do
		love.graphics.circle("fill", d.kps * scale, h - d.starRate * scale, 2)
	end
	
	love.graphics.setColor(255, 255, 63, 255)
	love.graphics.line(0, h, w, (a * (w / scale) + b) * w)
	love.graphics.line(0, h - b * scale, w, h - (a * w / scale + b) * scale)
end
