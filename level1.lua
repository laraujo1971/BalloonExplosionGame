-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

system.activate( "multitouch" )

--physics.setDrawMode("hybrid")

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- Add walls and ceiling
	local leftWall = display.newRect( 0, 0, 1, display.contentHeight*2 )
	local rightWall = display.newRect( display.contentWidth, 0, 1, display.contentHeight*2 )
	local ceiling = display.newRect( -40, -40, display.contentWidth*2+100, 0.1 )

	-- Add all these elements to the physics engine 
	physics.addBody( leftWall, "static", { friction=0.3 } )
	physics.addBody( rightWall, "static", { friction=0.3 } )
	physics.addBody( ceiling, "static", { friction=0.3 } )

	-- display a background image
	local background = display.newImageRect( "green_lightening_background.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	-- make a balloon (off-screen), position it, and rotate slightly
	local balloon = display.newImageRect( "red_balloon_icon.png", 150, 150 )
	balloon.x = display.contentWidth/2
	balloon.rotation = 15

	-- "touchBalloon" event is dispatched whenever you click in the balloon
	balloon:addEventListener( "touch", touchBalloon )

	-- add physics to the balloon
	physics.addBody( balloon, { radius = 35, friction=0.2, bounce=0.4 } )
	
	-- create a grass object and add physics (with custom shape)
	--local grass = display.newImageRect( "grass.png", screenW, 82 )
	--grass.anchorX = 0
	--grass.anchorY = 1
	--grass.x, grass.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local nail  = display.newImageRect( "nail-icon3.png", 28, 89 )
	nail.x = display.contentWidth/2
	nail.y = display.contentHeight
	nail.anchorX = 0
	nail.anchorY = 1

	-- "touchBalloon" event is dispatched whenever you click in the balloon
	Runtime:addEventListener( "collision", onCollision )

	physics.addBody( nail, "static", { friction=0.3 } )

	-- all display objects must be inserted into group
	group:insert( leftWall )
	group:insert( rightWall )
	group:insert( ceiling )

	group:insert( background )
	group:insert( nail )
	group:insert( balloon )
end

-- Called every time you touch the balloon:
function touchBalloon( event )
	local balloon = event.target
	
	balloon:applyLinearImpulse(0, -0.3, event.x, event.y)
	
end

-- Called every time you touch the balloon:
function onCollision( event )

	local group = self.view
	
	group:remove(5)
	group:remove(6)

	-- add physics to the balloon
	-- create/position logo/title image on upper-half of the screen
	local gameOver = display.newImageRect( "game-over.png", 256, 256 )
	gameOver.x = display.contentWidth * 0.5
	gameOver.y = display.contentHeight * 0.5
	
	physics.addBody( gameOver, "static" )

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene