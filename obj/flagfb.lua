local flag = class{
	function(self, map)
		self.map = map
		self.sb = love.graphics.newSpriteBatch(
			love.graphics.newImage("resources/flagflash.png"), #map * #map[1])
		self.edge = love.graphics.newImage("resources/edgeflash.png")
	end
}

function flag:add(r, c, nS)
	local x, y = worldCoordinates(r, c, nS)
	if not self.map[r][c].flag then
		self.map[r][c].flag = true
		self.sb:add(x, y)
	end
end

function flag:clear()
	self.sb:clear()
end

function flag:draw(t, wBT)
	love.graphics.setColor(255,255,255,255*t)
	love.graphics.draw(self.sb, 0 , 0)
	if wBT < 2 then
		love.graphics.draw(self.edge, 0, 0)
	end
end

return flag
