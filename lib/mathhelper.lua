local min = math.min
local max = math.max

function clamp(x, l, u)
	return min(max(x, l), u)
end

function within(x, l, u)
	if x < l then return -1
	elseif x > u then return 1
	else return 0 end
end

function contains(x, y, rect)
	local xVal = within(x, rect.x, rect.x+rect.w)
	local yVal = within(y, rect.y, rect.y+rect.h)
	if xVal == 0 and yVal == 0 then return true end
	return false
end

function worldCoordinates(row, col, nS)
	return col * nS, row * nS
end
