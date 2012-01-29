local body = class{
	function(self, r, c, nS)
		self.pos = {}
		self.pos.r = r
		self.pos.c = c
		self.pos.x, self.pos.y = worldCoordinates(self.pos.r, self.pos.c, nS)
	end
}

local snake = class{
	function(self, r, c, size, speed, wBT, length, color)
		self.head = {
			pos = {
				r = r,
				c = c,
			},
		}
		self.head.pos.x, self.head.pos.y = worldCoordinates(
			self.head.pos.r, self.head.pos.c, size)
		self.size = size
		self.speed = speed
		self.timer = 0
		self.wBT = wBT
		self.vel = {r = 0, c = 0}
		self.parts = {}
		self.dirFlags = {
			up = true,
			down = true,
			left = true,
			right = true,
		}
		self.length = length
		self.color = color or colors.yellow
	end
}

function snake:eat(food)
	self.size = self.size + 1
end

function snake:update(map, flag, food, dt)
	-- Increase timers
	self.timer = self.timer + dt
	if self.wBT > 0 then
		self.wBT = self.wBT - dt
	else
		self.wBT = 0
	end
	
	-- The speed is a timer bound that slows down the update speed
	if self.timer < self.speed then return end
	self.timer = 0
	
	-- If the snake is equal to its length, remove the last body part
	-- (since a new one will be added soon)
	if #self.parts == self.length then
		table.remove(self.parts, #self.parts)
	end
	
	-- Add to the body the current location of the head
	table.insert(self.parts, 1, body(
		self.head.pos.r,
		self.head.pos.c,
		self.size))
	if self.wBT == 0 then
		flash:add(self.head.pos.r, self.head.pos.c, self.size)
	end
		
	-- Move the head based upon current "velocity"
	self.head.pos.r = self.head.pos.r + self.vel.r
	self.head.pos.c = self.head.pos.c + self.vel.c
	
	-- Change the head's world coordinates
	self.head.pos.x, self.head.pos.y = worldCoordinates(
		self.head.pos.r,
		self.head.pos.c,
		self.size)
		
	-- If the snake hits the edge or a wall, die
	if	not contains(self.head.pos.x, self.head.pos.y, window) or
		map[self.head.pos.r][self.head.pos.c].wall then
		dead = true
	end
	
	-- If the snake tries to go back into itself, die
	if	#self.parts >= 2 and
		self.head.pos.r == self.parts[2].pos.r and
		self.head.pos.c == self.parts[2].pos.c and
		self.vel.r + self.vel.c ~= 0 then
		dead = true
	end
	
	if self.head.pos.r == food.r and self.head.pos.c == food.c then
		self.length = self.length + 1
		self.wBT = self.wBT + 2
		food:move(self.head.pos.r, self.head.pos.c, self, map)
		flag:clear()
		toggleMapFlags(map, self.size)
	end
end

function snake:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle(
		"fill",
		self.head.pos.x,
		self.head.pos.y,
		self.size,
		self.size)
	love.graphics.setColor(50,50,50)
	love.graphics.rectangle(
		"line",
		self.head.pos.x,
		self.head.pos.y,
		self.size,
		self.size)
	for _,v in pairs(self.parts) do
		local vX, vY = worldCoordinates(v.pos.r, v.pos.c, self.size)
		love.graphics.setColor(self.color)
		love.graphics.rectangle(
			"fill",
			vX,
			vY,
			self.size,
			self.size)
		love.graphics.setColor(50,50,50)
		love.graphics.rectangle(
			"line",
			vX,
			vY,
			self.size,
			self.size)
	end
	love.graphics.setColor(colors.white)
	love.graphics.print(string.format("Wall timer: %.2f", self.wBT), 0, 0)
end

function snake:toggleFlags(badFlag)
	for k,v in pairs(self.dirFlags) do
		if k == badFlag then
			self.dirFlags[k] = false
		else
			self.dirFlags[k] = true
		end
	end
end

function snake:controls(k)
	if self.dirFlags.up and k == "up" then
		self.vel.r = -1
		self.vel.c = 0
		self:toggleFlags("down")
	end
	if self.dirFlags.down and k == "down" then
		self.vel.r = 1
		self.vel.c = 0
		self:toggleFlags("up")
	end
	if self.dirFlags.left and k == "left" then
		self.vel.r = 0
		self.vel.c = -1
		self:toggleFlags("right")
	end
	if self.dirFlags.right and k == "right" then
		self.vel.r = 0
		self.vel.c = 1
		self:toggleFlags("left")
	end
end

return snake
