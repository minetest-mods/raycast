local floor, abs, sqrt = math.floor, math.abs, math.sqrt
local cos, sin = math.cos, math.sin
local concat = table.concat

local map = {
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
	{1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1},
	{1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
}

local posX, posY = 22, 12
local dirX, dirY = -1, 0
local planeX, planeY = 0, 0.66
local w, h = 800, 600
local moveSpeed, rotSpeed = 2, 0.5

local function draw()
	local screen, i = {}, 0
	for x = 0, w do
		local camX = 2 * (x / w) - 1
		local rayPosX, rayPosY = posX, posY
		local rayDirX = dirX + planeX * camX
		local rayDirY = dirY + planeY * camX
		local mapX = floor(rayPosX)
		local mapY = floor(rayPosY)
		local sideDistX, sideDistY

		local deltaDistX = sqrt(1 + (rayDirY ^ 2) / (rayDirX ^ 2))
		local deltaDistY = sqrt(1 + (rayDirX ^ 2) / (rayDirY ^ 2))
		local perpWallDist, stepX, stepY
		local hit, side = 0

		if rayDirX < 0 then
			stepX = -1
			sideDistX = (rayPosX - mapX) * deltaDistX
		else
			stepX = 1
			sideDistX = (mapX + 1 - rayPosX) * deltaDistX
		end

		if rayDirY < 0 then
			stepY = -1
			sideDistY = (rayPosY - mapY) * deltaDistY
		else
			stepY =  1
			sideDistY = (rayPosY + 1 - rayPosY) * deltaDistY
		end

		while hit == 0 do
			if sideDistX < sideDistY then
				sideDistX = sideDistX + deltaDistX
				mapX = mapX+stepX
				side = 0
			else
				sideDistY = sideDistY + deltaDistY
				mapY = mapY + stepY
				side = 1
			end

			if map[mapX][mapY] > 0 then
				hit = 1
			end
		end

		if side == 0 then
			perpWallDist = abs((mapX - rayPosX + (1 - stepX) / 2) / rayDirX)
		else
			perpWallDist = abs((mapY - rayPosY + (1 - stepY) / 2) / rayDirY)
		end

		local lineHeight = abs(floor(h / perpWallDist))
		local drawStart = -lineHeight / 2 + h / 2

		if drawStart < 0 then
			drawStart = 0
		end

		local drawEnd = lineHeight / 2 + h / 2
		if drawEnd >= h then
			drawEnd = h - 1
		end

		local color = {255, 255, 0}
		local square = map[mapX][mapY]

		if square == 1 then
			color = {255, 0, 0}
		elseif square == 2 then
			color = {0, 255, 0}
		elseif square == 3 then
			color = {0, 0, 255}
		elseif square == 4 then
			color = {255, 255, 255}
		end

		if side == 1 then
			for j = 1, #color do
				color[j] = color[j] * 0.5
			end
		end

		color = minetest.rgba(color[1], color[2], color[3], 0xFF)

		for Y = drawStart, drawEnd do
			i = i + 1
			screen[i] = "box[" .. (x / 100) .. "," .. (Y / 100) ..
					";0.04,0.04;" .. color .. "]"
		end
	end

	return concat(screen)
end

local fs = [[
	size[8.5,6]
	no_prepend[]
	button[2,5;1,1;up;^]
	button[3,5;1,1;down;v]
	button[4,5;1,1;left;<]
	button[5,5;1,1;right;>]
]]

minetest.register_node("raycast:r", {
	drawtype = "normal",
	description = "raycast",
	paramtype = "light",
	groups = {cracky = 3},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", fs .. draw())
	end,

	on_receive_fields = function(pos, _, fields)
		if fields.up then
			if map[floor(posX + dirX * moveSpeed)][floor(posY)] == 0 then
				posX = posX + dirX * moveSpeed
			end

			if map[floor(posX)][floor(posY + dirY * moveSpeed)] == 0 then
				posY = posY + dirY * moveSpeed
			end
		end

		if fields.down then
			if map[floor(posX - dirX * moveSpeed)][floor(posY)] == 0 then
				posX = posX - dirX * moveSpeed
			end

			if map[floor(posX)][floor(posY - dirY * moveSpeed)] == 0 then
				posY = posY - dirY * moveSpeed
			end
		end

		if fields.left then
			local oldDirX = dirX
			dirX = dirX * cos(rotSpeed) - dirY * sin(rotSpeed)
			dirY = oldDirX * sin(rotSpeed) + dirY * cos(rotSpeed)

			local oldPlaneX = planeX
			planeX = planeX * cos(rotSpeed) - planeY * sin(rotSpeed)
			planeY = oldPlaneX * sin(rotSpeed) + planeY * cos(rotSpeed)
		end

		if fields.right then
			local oldDirX = dirX
			dirX = dirX * cos(-rotSpeed) - dirY * sin(-rotSpeed)
			dirY = oldDirX * sin(-rotSpeed) + dirY * cos(-rotSpeed)

			local oldPlaneX = planeX
			planeX = planeX * cos(-rotSpeed) - planeY * sin(-rotSpeed)
			planeY = oldPlaneX * sin(-rotSpeed) + planeY * cos(-rotSpeed)
		end

		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", fs .. draw())
	end,
})