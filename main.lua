--[[

Author: Albert Vo

]]
-- activate multitouch
system.activate( "multitouch" )

-- Includes
local TileClass = require( "tile" )

-- Game properties
game_board = {}
grid_with = 10
grid_height = 10
letters = {"a","b","c","d","star"}

-- Hide Status Bar
display.setStatusBar( display.HiddenStatusBar ) 

-- Setting up static graphics
--background = display.newImage( "background.png" )
header = display.newImage( "header_sunny.png" )
logo = display.newImage( "logo.png" )
logo.x = display.contentWidth  / 2
logo.y = 60
--footer = display.newImage( "footer.png" )
--footer.y = display.contentHeight - 52

local btn_menu = display.newImage( "btn_menu.png" )
btn_menu.x = 90
btn_menu.y = 45

local textObject = display.newText( "Hello World!", 50, 50, nil, 24 )
textObject:setTextColor( 255,255,255 )

local click = audio.loadSound("click_sound.wav")



function load_game_board()
	
	for i = 1, grid_with, 1 do
		game_board[i] = {}
		for j = 1, grid_height, 1 do
			letterIndex = math.random (1, table.getn(letters))
			game_board[i][j] = TileClass.new(letters[letterIndex], i, j )
		end
	end
end	


load_game_board()

function detonate()

	
	for i = 1, grid_with, 1 do
		for j = 1, grid_height, 1 do
			local tempTile = game_board[i][j]
			if(tempTile and tempTile.hasBomb) then
				tempTile:detonate()
				game_board[i][j] = nil
			end
			
		end
	end
	
	for i = 1, grid_with, 1 do
		for j = grid_height, 1, -1 do -- bottom up traversal
			if(game_board[i][j]) then -- if non empty
				local lowestEmptySpaceX = nil
				local lowestEmptySpaceY = nil
				for k = j, grid_height, 1 do --start looking down for the lowest empty space
					if(game_board[i][k] == nil) then
						lowestEmptySpaceX = i
						lowestEmptySpaceY = k
					end
				end
				if(lowestEmptySpaceX) then
					game_board[i][j]:fall(lowestEmptySpaceX, lowestEmptySpaceY)
					game_board[lowestEmptySpaceX][lowestEmptySpaceY] = game_board[i][j]
					game_board[i][j] = nil
				end
			end
		end
	end
	
end


function btn_menu:tap( event )
	audio.play(click)
	local r = math.random( 0, 255 )
    local g = math.random( 0, 255 )        
	local b = math.random( 0, 255 )
 	textObject:setTextColor( r, g, b )
	detonate()	
end


btn_menu:addEventListener( "tap", btn_menu )

function drawLine( event )
  if(event.phase == "ended") then
    line = display.newLine(event.xStart, event.yStart, event.x, event.y)
    line:setColor(255,0,0)
    line.width = 5
  end
end

Runtime:addEventListener("touch", drawLine)