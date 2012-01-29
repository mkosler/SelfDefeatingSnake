-- Libraries
class = require "lib/class"
require "lib/mathhelper"
require "lib/colors"
require "lib/tlfres"

-- Objects
local snake = require "obj/snake"
local flagFb = require "obj/flagfb"
local food = require "obj/food"

function buildGrid(nNum)
	local g = {}
	for r = 0, nNum do
		g[r] = {}
		for c = 0, nNum do
			g[r][c] = {}
		end
	end
	return g
end

local function drawMap(map, nS)
	local fb = love.graphics.newFramebuffer()
	love.graphics.setRenderTarget(fb)
	love.graphics.setColor(colors.cyan)
	for row = 0, #map - 1 do
		local nCol = #map[row]
		for col = 0, nCol - 1 do
			if map[row][col].wall then
				love.graphics.rectangle(
					"fill",
					col * nS,
					row * nS,
					nS,
					nS)
			else
				love.graphics.rectangle(
					"line",
					col * nS,
					row * nS,
					nS,
					nS)
			end
		end
	end
	love.graphics.setRenderTarget()
	return fb
end

function toggleMapFlags(map, nS)
	for r = 0, #map - 1 do
		for c = 0, #map[r] - 1 do
			if map[r][c].flag then
				map[r][c].wall = true
				map[r][c].flag = false
			end
		end
	end
	mapFb = drawMap(map, nS)
end

function love.load()
	math.randomseed(os.time())
	TLfres.setScreen()
	window = {
		x = -1,
		y = -1,
		w = 600,
		h = 600,
	}
	local nodeSize = 20
	nNum = window.w/nodeSize
	map = buildGrid(nNum)
	mapFb = drawMap(map, nodeSize)
	player = snake(
		#map - 1,
		0,
		nodeSize,
		0.07,
		5,
		5)
	dead = false
	fTimer = 0
	fTTrigger = true
	flash = flagFb(map)
	fPiece = food(nNum, nodeSize)
	fPiece:move(player.head.pos.r, player.head.pos.c, player, map)
end

function love.update(dt)
	if not dead then
		player:update(map, flash, fPiece, dt)
	end
	if fTTrigger then
		fTimer = fTimer + dt
		if fTimer >= 1 then
			fTTrigger = false
		end
	else
		fTimer = fTimer - dt
		if fTimer <= 0 then
			fTTrigger = true
			fTimer = 0
		end
	end
end

function love.draw()
	TLfres.transform()
	love.graphics.setColor(colors.white)
	love.graphics.draw(mapFb, 0, 0)
	player:draw()
	fPiece:draw()
	flash:draw(fTimer, player.wBT)
	TLfres.letterbox(4,3)
end

function love.keypressed(k)
	if k == "escape" then
		love.event.push("q")
	end
	player:controls(k)
end
