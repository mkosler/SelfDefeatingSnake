local food = class{
	function(self, nNum, nS)
		self.nNum = nNum
		self.size = nS
		self.rad = nS/2
		self.color = colors.green
		self.diff = 3
	end
}

function food:move(hR, hC, snake, map)
	local recFlag = false
	self.r = math.random(
		math.max(hR - self.diff, 0),
		math.min(hR + self.diff, self.nNum - 1))
	self.c = math.random(
		math.max(hC - self.diff, 0),
		math.min(hC + self.diff, self.nNum - 1))
	for _,v in pairs(snake.parts) do
		if self.r == v.r and self.c == v.c then
			recFlag = true
			break
		end
	end
	if not recFlag and map[self.r][self.c].wall then
		recFlag = true
	end
	if recFlag then
		self:move(hR, hC, snake, map)
	else
		self.x, self.y = worldCoordinates(self.r, self.c, self.size)
		self.diff = self.diff + 1
	end
end

function food:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle(
		"fill",
		self.x + self.rad,
		self.y + self.rad,
		self.rad)
end

return food
