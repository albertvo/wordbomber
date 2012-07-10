--[[

Author: Albert Vo

]]
-- activate multitouch
system.activate( "multitouch" )

-- Includes
local TileClass = require( "tile" )

-- Game properties
game_board = {}
grid_with = 14
grid_height = 16

-- Hide Status Bar
display.setStatusBar( display.HiddenStatusBar ) 

-- Setting up static graphics
background = display.newImage( "background.png" )
header = display.newImage( "header_sunny.png" )
logo = display.newImage( "logo.png" )
logo.x = display.contentWidth  / 2
logo.y = 60
footer = display.newImage( "footer.png" )
footer.y = display.contentHeight - 52

local btn_menu = display.newImage( "btn_menu.png" )
btn_menu.x = 90
btn_menu.y = 45

local textObject = display.newText( "Hello World!", 50, 50, nil, 24 )
textObject:setTextColor( 255,255,255 )

local click = audio.loadSound("click_sound.wav")



function load_game_board()
	
	for i = 0, grid_with, 1 do
		game_board[i] = {}
		for j = 0, grid_height, 1 do
			
			game_board[i][j] = TileClass.new("a", i, j )
		end
	end
end	


load_game_board()

function detonate()

	
	for i = 0, grid_with, 1 do
		for j = 0, grid_height, 1 do
			local tempTile = game_board[i][j]
			if(tempTile.hasBomb) then
				tempTile:detonate()
			end
			
		end
	end
	
	for i = 0, grid_with, 1 do
		for j = grid_height, 0, -1 do
			local tempTile = game_board[i][j]
			
				tempTile:fall()
			
			
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