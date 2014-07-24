-- This is the a basic file for the actual LEX game so we can control the initial animation. Tapping here starts the game and hides the title

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth / 2
local _H = display.contentHeight / 2

local gameStage=display.newGroup()
gameStage.x, gameStage.y=_W,_H

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
local group = self.view

-----------------------------------------------------------------------------

-- CREATE display objects and add them to 'group' here.
-- Example use-case: Restore 'group' from previously saved state.

-----------------------------------------------------------------------------

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
local group = self.view

function startGame(event)
	if	event.phase=="began" then
		_G.title_Text.alpha=0.0
		_G.title_Start_Text.alpha=0.0
		_G.isInTitle=false
		local options =
		{
		    effect = "zoomInOutFade",
		    time = 0,
		}
		audio.play( _G.starting, { loops=0})	

		storyboard.gotoScene( "inGame", options )	
	end
	return true
end

local play_Btn = display.newText("  ",0,0,native.systemFont, 340)
play_Btn.x, play_Btn.y=0,0
play_Btn:addEventListener("touch", startGame)
play_Btn:setFillColor(254/255, 	214/255, 	89/255, 1/255)
gameStage:insert(play_Btn)

group:insert(gameStage)

-----------------------------------------------------------------------------

-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

-----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
local group = self.view

-----------------------------------------------------------------------------

-- INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

-----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
local group = self.view

-----------------------------------------------------------------------------

-- INSERT code here (e.g. remove listeners, widgets, save state, etc.)

-----------------------------------------------------------------------------

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene