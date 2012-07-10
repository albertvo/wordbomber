
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

local tile = {}
local tile_mt = { __index = tile }	-- metatable

local xGridStart = 6
local yGridStart = 125
local click = audio.loadSound("click_sound.wav")
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function fall( realYears )	-- local; only visible in this module
	return realYears * 7
end

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function tile.new( letter, xGridPos, yGridPos )	-- constructor
	local new_tile = {
		letter = letter or "a",
		xGridPos = xGridPos or 0,
		yGridPos = yGridPos or 0,
		xCoord = xGridStart + (xGridPos * 42),
		yCoord = yGridStart + (yGridPos * 43),
		hasBomb = false,
		isEmpty = false,
		image = display.newImage("tile_a.png", xGridStart + (xGridPos * 42), yGridStart + (yGridPos * 43))
	}
	
	new_tile.image:setReferencePoint( display.TopLeftReferencePoint)
	
	function place_bomb( event )
		audio.play(click)
		new_tile.hasBomb = true
		display.remove(new_tile.image)
	end
	new_tile.image:addEventListener( "tap", place_bomb )
	
	
	return setmetatable( new_tile, tile_mt )
end

-------------------------------------------------

function tile:detonate()
	if(self.hasBomb) then
		display.remove(self.image)
		self.hasBomb = false
		self.isEmpty = true
	end
end
  
function tile:fall()
	if(self.isEmpty == false) then
		--find the lowest empty spot in the column
		local lowestEmptyTile = nil
		for i = self.yGridPos, grid_height, 1 do
			if( game_board[self.xGridPos][i].isEmpty ) then
				lowestEmptyTile = game_board[self.xGridPos][i]
			end
		end
		
		--migrate properties to the lowest empty spot and change game board
		if( lowestEmptyTile ~= nil ) then
			transition.to(self.image, {time=300, y=lowestEmptyTile.yCoord, transition = easing.linear})
			
			
			print( lowestEmptyTile.yGridPos )
			lowestEmptyTile.image = self.image
			lowestEmptyTile.letter = self.letter
			lowestEmptyTile.isEmpty = false
			
			
			
			self.isEmpty = true
			self.image = nil
			self.letter = nil
			
			--game_board[self.xGridPos][self.yGridPos] = self
			
			
			
			

		end
	end
end




return tile

