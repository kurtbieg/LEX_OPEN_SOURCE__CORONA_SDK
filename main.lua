-- The MIT License (MIT)
-- 
-- Copyright (c) 2014, Simple Machine LLC
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- Dictionary API found in the "Systems" folder provided by Dale Gordon

-- English dictionary from http://dreamsteep.com/projects/the-english-open-word-list.html
-- The “English Open Word List” (EOWL) was developed by Ken Loge, but is almost entirely 
-- derived from the “UK Advanced Cryptics Dictionary” (UKACD) Version 1.6, by J Ross Beresford.

-- UK Advanced Cryptics Dictionary Licensing Information:

-- Copyright © J Ross Beresford 1993-1999. All Rights Reserved. 
-- The following restriction is placed on the use of this publication: 
-- if the UK Advanced Cryptics Dictionary is used in a software package 
-- or redistributed in any form, the copyright notice must be prominently 
-- displayed and the text of this document must be included verbatim.



-- This is the main file, setting up all the globals, any save files, and basic inits

display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" )
local json = require "json"

_G.sysOS="iPhone OS"

math.randomseed( os.time() )

_G.isInTitle=true

_G.currentLevel=1
_G.drumPattern=1

_G.isGameOver=false

_G.currentLevel=1

_G.WordGameDictionary = require("Systems.WordGameSystem.WordGameDictionary");
_G.WordGameDictionary:load("en");

local _W = display.contentWidth / 2
local _H = display.contentHeight / 2

_G.background=display.newGroup()
_G.background.x,_G.background.y= _W,_H

_G.gameField=display.newRect(0,0, _W*2,_H*3)
_G.gameField.x, _G.gameField.y=0,0
_G.gameField:setFillColor(254/255, 	214/255, 	89/255)
_G.background:insert(_G.gameField)

_G.title_Text = display.newText("WORDS",0,0,native.systemFont, 24)
if	_G.sysOS=="iPhone OS" then
	_G.title_Text.x, _G.title_Text.y=0,0
else
	_G.title_Text.x, _G.title_Text.y=0,0
end
_G.title_Text:setFillColor(100/255)
_G.title_Text.xScale, _G.title_Text.yScale=2,2

_G.title_Start_Text = display.newText("T A P  T O  P L A Y",0,0,native.systemFont, 18)
_G.title_Start_Text.x, _G.title_Start_Text.y=0,34
_G.title_Start_Text:setFillColor(100/255)

_G.background:insert(_G.title_Text)

_G.background:insert(_G.title_Start_Text)
 
local gameFrame=display.newGroup()
gameFrame.x, gameFrame.y=_W,_H

local top_Rect=display.newRect(0,0, _W*4,_H*2)
top_Rect.x, top_Rect.y=0,_H*2
top_Rect:setFillColor(0/255)
gameFrame:insert(top_Rect)

local bottom_Rect=display.newRect(0,0, _W*4,_H*2)
bottom_Rect.x, bottom_Rect.y=0,-_H*2
bottom_Rect:setFillColor(0/255)
gameFrame:insert(bottom_Rect)

local left_Rect=display.newRect(0,0, _W*2,_H*4)
left_Rect.x, left_Rect.y=-_W*2,0
left_Rect:setFillColor(0/255)
gameFrame:insert(left_Rect)

local right_Rect=display.newRect(0,0, _W*2,_H*4)
right_Rect.x, right_Rect.y=_W*2,0
right_Rect:setFillColor(0/255)
gameFrame:insert(right_Rect)

local display_stage = display.getCurrentStage()
display_stage:insert( _G.background )
display_stage:insert( storyboard.stage )
display_stage:insert( gameFrame )

math.randomseed( os.time() )

local jsonFile = function( filename, base )

	-- set default base dir if none specified
	if not base then base = system.ResourceDirectory; end

	-- create a file path for corona i/o
	local path = system.pathForFile( filename, base )

	-- will hold contents of file
	local contents

	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "r" )
	if file then
	   -- read all contents of file into a string
	   contents = file:read( "*a" )
	   io.close( file )	-- close the file after using it
	end

	return contents
end

_G.highScore=0

function _G.loadScoresFile()
	print("FILE FOUND")
	local m = json.decode( jsonFile("scores.json", system.DocumentsDirectory ))
	_G.highScore=m
	print(_G.highScore[1])
end

function _G.saveScoresFile()
	print("SAVE FOUND")
	local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
	file = io.open( filePath, "w" )
	file:write(json.encode(_G.highScore))
	io.close( file )	
end

function _G.makeScoresFile()
	local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
	file = io.open( filePath, "w" )
	_G.highScore={0}
	file:write(json.encode(_G.highScore))
	io.close( file )
	_G.isFirstTimeEver=true
end

if	jsonFile("scores.json", system.DocumentsDirectory ) then
	_G.loadScoresFile()
	if	_G.highScore[1]==0 then
		_G.isTutorial=false
	end
else
	_G.makeScoresFile()
	_G.isTutorial=false
end

local options =
{
    effect = "zoomInOutFade",
    time = 0,
}

storyboard.gotoScene( "menu", options )