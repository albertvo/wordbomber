
--[[
Tile = {}
function Tile:new(letter, xGridPos, yGridPos)
	
	local tile = display.newGroup()
 	local xGridStart = 27
	local yGridStart = 140
	
	
	
	local tileImage = display.newImage("tile_a.png", xGridStart + (xGridPos * 85), yGridStart + (yGridPos * 85))
	tileImage:setReferencePoint(display.TopLeftReferencePoint)
	tile:insert(tileImage)
 
	local click = audio.loadSound("click.wav")
	function tile:tap( event )
		audio.play(click)
		display.remove( tileImage )
	end
	tile:addEventListener( "tap", tile.tileImage )
	
	return tile
end

function Tile:fall()
	print(self)
	x.remove( self )
end


return Tile

]]

-------------------------------------------------
--
-- letter.lua
--
-------------------------------------------------
local easingx  = require("easing")
local tile = {}
local tile_mt = { __index = tile }	-- metatable

local xGridStart = 0
local yGridStart = 100
local tileWidth = 64
local click = audio.loadSound("click_sound.wav")
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function getXCoord( )	-- local; only visible in this module
	return self.xGrid
end

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function tile.new( letter, xGridPos, yGridPos )	-- constructor
	local new_tile = {
		letter = letter or "a",
		xGridPos = xGridPos or 1,
		yGridPos = yGridPos or 1,
		hasBomb = false,
		isEmpty = false,
		group = display.newGroup()
	}
	
	local tileImage = display.newImage("tile_"..letter..".png")
	new_tile.group:insert(tileImage)
	new_tile.group:setReferencePoint( display.TopLeftReferencePoint)
	new_tile.group.x = xGridStart + ((xGridPos-1) * tileWidth)
	new_tile.group.y = yGridStart + ((yGridPos-1) * tileWidth)
	
	
	function place_bomb( event )
		audio.play(click)
		new_tile.hasBomb = true
	end
	new_tile.group:addEventListener( "tap", place_bomb )
	
	
	return setmetatable( new_tile, tile_mt )
end

-------------------------------------------------


function tile:detonate()
	if(self.hasBomb) then
		display.remove(self.group)
		self.group = nil
		self.hasBomb = false
		self.isEmpty = true
	end
end
  
function tile:fall(xGridPos, yGridPos)
	self.xGridPos = xGridPos
	self.yGridPos = yGridPos
	local yCoord = yGridStart + (yGridPos-1) * tileWidth
	transition.to(self.group, {time=600, y=yCoord, transition = easingx.easeOutBounce})
end




return tile

