colors = {
	red = {255,0,0},
	green = {0,255,0},
	blue = {0,0,255},
	white = {255,255,255},
	black = {0,0,0},
	gray = {100,100,100},
	yellow = {255,255,0},
	cyan = {0,255,255},
}

alpha = {
	transparent = 0,
	semi = 128,
	opaque = 255,
}

function randomColor()
	local list = {}
	local count = 0
	for _,v in pairs(colors) do
		count = count + 1
		table.insert(list, v)
	end
	return list[math.random(count)]
end

return colors, alpha
