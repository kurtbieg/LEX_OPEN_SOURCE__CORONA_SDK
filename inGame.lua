-- This is the entire game, it reads mostly like a book, top to bottom.
-- Most of the important stuff you'll find when the tiles are created, 
-- when they are tapped, and most importantly, when the player submits a word.
-- That's it really. Hope it brings you inspiration :)

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth / 2
local _H = display.contentHeight / 2

local isHighScoreEvent=false

local switchMusic=0
_G.switchCurrentScale=0

local currentWordNum=1

local canReset=false

colorArray={
	
	{254/255, 	214/255, 	89/255},
	{246/255,	239/255,	93/255},
	{185/255,	220/255,	103/255},
	
	{121/255,	193/255,	67/255},
	{0/255,		144/255,	75/255},
	{0/255,		123/255,	122/255},
	
	{0/255, 	81/255, 	123/255},
	{99/255, 	25/255, 	175/255},
	{134/255, 	0/255, 		204/255},
	
	{0/255,		0/255,		0/255},
	
	{254/255, 	214/255, 	89/255},
	{246/255,	239/255,	93/255},
	{185/255,	220/255,	103/255},
	
	{121/255,	193/255,	67/255},
	{0/255,		144/255,	75/255},
	{0/255,		123/255,	122/255},
	
	{0/255, 	81/255, 	123/255},
	{99/255, 	25/255, 	175/255},
	{134/255, 	0/255, 		204/255},
	
	{0/255,		0/255,		0/255},
	
	
	{254/255, 	214/255, 	89/255},
	{246/255,	239/255,	93/255},
	{185/255,	220/255,	103/255},
	
	{121/255,	193/255,	67/255},
	{0/255,		144/255,	75/255},
	{0/255,		123/255,	122/255},
	
	{0/255, 	81/255, 	123/255},
	{99/255, 	25/255, 	175/255},
	{134/255, 	0/255, 		204/255},
	
	{0/255,		0/255,		0/255},
	
	
	{254/255, 	214/255, 	89/255},
	{246/255,	239/255,	93/255},
	{185/255,	220/255,	103/255},
	
	{121/255,	193/255,	67/255},
	{0/255,		144/255,	75/255},
	{0/255,		123/255,	122/255},
	
	{0/255, 	81/255, 	123/255},
	{99/255, 	25/255, 	175/255},
	{134/255, 	0/255, 		204/255},
	
	{0/255,		0/255,		0/255},
	
	
	{254/255, 	214/255, 	89/255},
	{246/255,	239/255,	93/255},
	{185/255,	220/255,	103/255},
	
	{121/255,	193/255,	67/255},
	{0/255,		144/255,	75/255},
	{0/255,		123/255,	122/255},
	
	{0/255, 	81/255, 	123/255},
	{99/255, 	25/255, 	175/255},
	{134/255, 	0/255, 		204/255},
	
	{0/255,		0/255,		0/255},
}


colorPatterArray={
	{0/255,		123/255,	122/255},
	
	{0/255, 	81/255, 	123/255},
	{99/255, 	25/255, 	175/255},
	{134/255, 	0/255, 		204/255},
	{255/255, 	84/255, 	230/255},
	
	{254/255, 	214/255, 	89/255},
	{246/255,	239/255,	93/255},
	{185/255,	220/255,	103/255},
	
	{121/255,	193/255,	67/255},
	{0/255,		144/255,	75/255},
	
}

local usedLetters={
	{},{},{},{},{},{},{},{},{},{},
}

local letterFrequencyArray={
	{"a",	8},
	{"b",	3},
	{"c",	3},
	{"d",	4},
	{"e",	10},
	{"f",	2},
	{"g",	3},
	{"h",	3},
	{"i",	7},
	{"j",	1},
	{"k",	2},
	{"l",	5},
	{"m",	3},
	{"n",	5},
	{"o",	6},
	{"p",	3},
	{"q",	1},
	{"r",	4},
	{"s",	5},
	{"t",	5},
	{"u",	4},
	{"v",	2},
	{"w",	2},
	{"x",	1},
	{"y",	3},
	{"z",	1},
}

local letterValueArray={
	{"a",	1},
	{"b",	3},
	{"c",	3},
	{"d",	2},
	{"e",	1},
	{"f",	4},
	{"g",	2},
	{"h",	4},
	{"i",	1},
	{"j",	8},
	{"k",	5},
	{"l",	1},
	{"m",	3},
	{"n",	1},
	{"o",	1},
	{"p",	3},
	{"q",	10},
	{"r",	1},
	{"s",	1},
	{"t",	1},
	{"u",	2},
	{"v",	4},
	{"w",	4},
	{"x",	8},
	{"y",	4},
	{"z",	10},
}

local letterSelectArray={}

local totalVowels=0
local totalConsonants=0

function makeLetterDistributionArray()
	for i=1,#letterFrequencyArray do
		for j=1,letterFrequencyArray[i][2] do
			letterSelectArray[#letterSelectArray+1]={letterFrequencyArray[i][1], letterValueArray[i][2]}
		end
	end
end

makeLetterDistributionArray()

local gameStage=display.newGroup()
gameStage.x, gameStage.y=_W,_H

local totalTilesOnScreen=9

local currentWordString=""
local currentLetterArray={}

local everyThird=0

local totalWordScore=0
local currentScore=0
local currentBonus=0
local currentBonusArray={0,0,0,0,3,3,3,3,10}

local bestWordArray={}

_G.currentLevel=1
local currentLevelProgress=0

local baseColor_Rect=display.newRect(0,0,_W*2,_H*2)
baseColor_Rect.x, baseColor_Rect.y=-_W,0
baseColor_Rect.anchorX = 0
baseColor_Rect.alpha=0.0
baseColor_Rect:setFillColor(colorArray[1][1], colorArray[1][2], colorArray[1][3])
gameStage:insert(baseColor_Rect)

newHighScore_Img_Top=display.newImageRect("img/newHighScore.png", _W*2, _H*2)
newHighScore_Img_Top.x, newHighScore_Img_Top.y=0,0
newHighScore_Img_Top.alpha=0.0
newHighScore_Img_Top.xO, newHighScore_Img_Top.yO=0,0
gameStage:insert(newHighScore_Img_Top)

newHighScore_Img_Fade=display.newImageRect("img/newHighScore.png", _W*2, _H*2)
newHighScore_Img_Fade.x, newHighScore_Img_Fade.y=0,0
newHighScore_Img_Fade.alpha=.0
newHighScore_Img_Fade.xO, newHighScore_Img_Fade.yO=0,0
gameStage:insert(newHighScore_Img_Fade)

local baseColorSlider_Rect=display.newRect(0,0,_W*2,_H*2)
baseColorSlider_Rect.x, baseColorSlider_Rect.y=-_W,(-_H*2)+40
baseColorSlider_Rect.yO=(-_H*2)+40
baseColorSlider_Rect.anchorX = 0
baseColorSlider_Rect.xScale=-.1
baseColorSlider_Rect.alpha=0.0
baseColorSlider_Rect:setFillColor(colorArray[_G.currentLevel+1][1], colorArray[_G.currentLevel+1][2], colorArray[_G.currentLevel+1][3])
gameStage:insert(baseColorSlider_Rect)

_G.gameOverSlam_Gp=display.newGroup()
gameStage:insert(_G.gameOverSlam_Gp)

tileAnim_Gp=display.newGroup()
tileAnim_Gp.x,tileAnim_Gp.y= 0,0
gameStage:insert(tileAnim_Gp)

local title_Text = display.newText("",0,0,native.systemFont, 300)
gameStage:insert(title_Text)

_G.gameOverSlam_Gp.x, _G.gameOverSlam_Gp.y=0,0
_G.gameOverSlam_Gp.xO, _G.gameOverSlam_Gp.yO=0,0
_G.gameOverSlam_Gp.alpha=0.0

local gameOverSlamGame_Text = display.newText("GAME", 0, 0, native.systemFont, 300)
gameOverSlamGame_Text.x, gameOverSlamGame_Text.y=0,-120
gameOverSlamGame_Text.alpha=1.0
gameOverSlamGame_Text:setFillColor(0)
_G.gameOverSlam_Gp:insert(gameOverSlamGame_Text)

local gameOverSlamOver_Text = display.newText("OVER", 0, 0, native.systemFont, 300)
gameOverSlamOver_Text.x, gameOverSlamOver_Text.y=0,120
gameOverSlamOver_Text:setFillColor(0)
gameOverSlamOver_Text.alpha=1.0
_G.gameOverSlam_Gp:insert(gameOverSlamOver_Text)

local bestWord_Text_Shadow = display.newText("", 0, 0, native.systemFont, 20)
bestWord_Text_Shadow.x, bestWord_Text_Shadow.y=0,_H-94
bestWord_Text_Shadow.alpha=0.0
bestWord_Text_Shadow:setFillColor(255)

local bestWord_Text = display.newText("", 0, 0, native.systemFont, 20)
bestWord_Text.x, bestWord_Text.y=0,_H-95
bestWord_Text.alpha=0.0
bestWord_Text:setFillColor(0)

local gameOverTimer

local gameOverTile_Gp=display.newGroup()
gameOverTile_Gp.x, gameOverTile_Gp.y=0,30
gameOverTile_Gp.xO, gameOverTile_Gp.yO=0,0
gameStage:insert(gameOverTile_Gp)

local letterTile_Gp=display.newGroup()
-- letterTile_Gp.x, letterTile_Gp.y=0,30
letterTile_Gp.x, letterTile_Gp.y=0,40
if	_G.isTall==false then
	letterTile_Gp.xScale, letterTile_Gp.yScale=.85,.85
end
letterTile_Gp.xO, letterTile_Gp.yO=0,0
gameStage:insert(letterTile_Gp)

local wordCapsule_Gp=display.newGroup()
wordCapsule_Gp.x, wordCapsule_Gp.y=0,-50
wordCapsule_Gp.xO, wordCapsule_Gp.yO=0,-50
wordCapsule_Gp.xScale, wordCapsule_Gp.yScale=.50,.50
gameStage:insert(wordCapsule_Gp)

gameStage:insert(bestWord_Text_Shadow)
gameStage:insert(bestWord_Text)

local capsuleWidth=1000

wordCapsule_body_Img_Shadow=display.newImageRect("img/capBody.png", capsuleWidth, 200)
wordCapsule_body_Img_Shadow.x, wordCapsule_body_Img_Shadow.y=1,1
wordCapsule_body_Img_Shadow.xScale=-.1
wordCapsule_body_Img_Shadow.yScale=-.1
wordCapsule_body_Img_Shadow.alpha=0
wordCapsule_body_Img_Shadow:setFillColor(0.3)
wordCapsule_Gp:insert(wordCapsule_body_Img_Shadow)

wordCapsule_leftEnd_Img_Shadow=display.newImageRect("img/capEnd.png", 200, 200)
wordCapsule_leftEnd_Img_Shadow.x, wordCapsule_leftEnd_Img_Shadow.y=(-wordCapsule_body_Img_Shadow.width*wordCapsule_body_Img_Shadow.xScale)/2+1+1,1
wordCapsule_leftEnd_Img_Shadow.xScale=-.1
wordCapsule_leftEnd_Img_Shadow.yScale=-.1
wordCapsule_leftEnd_Img_Shadow.alpha=0
wordCapsule_leftEnd_Img_Shadow:setFillColor(0.3)
wordCapsule_Gp:insert(wordCapsule_leftEnd_Img_Shadow)

wordCapsule_righEnd_Img_Shadow=display.newImageRect("img/capEnd.png", 200, 200)
wordCapsule_righEnd_Img_Shadow.x, wordCapsule_righEnd_Img_Shadow.y=(wordCapsule_body_Img_Shadow.width*wordCapsule_body_Img_Shadow.xScale)/2-1+1,1
wordCapsule_righEnd_Img_Shadow.xScale=-.1
wordCapsule_righEnd_Img_Shadow.yScale=-.1
wordCapsule_righEnd_Img_Shadow.alpha=0
wordCapsule_righEnd_Img_Shadow:setFillColor(0.3)
wordCapsule_Gp:insert(wordCapsule_righEnd_Img_Shadow)

local word_Gp=display.newGroup()

local isTapped=false
local isPulling=false
local startingX=0
local newX=0
local xDiff=0
local isClear=false

function removeLetter(event)
	if	event.phase=="began" and _G.isGameOver==false then
		startingX=event.x-_W
		isTapped=true
		display.getCurrentStage():setFocus(event.target)
	end
	if	event.phase=="moved" and _G.isGameOver==false then
		if	isTapped then
			if	event.x-_W>startingX+20 or event.x-_W<startingX-20 then
				if	isPulling==false then
					xDiff=(event.x-_W)-startingX
					transition.to(wordCapsule_Gp, {time=50, x=event.x-_W-startingX, transition=easing.outQuad})
				end
				isPulling=true
			end
		end
		if	isPulling then
			wordCapsule_Gp.x=event.x-_W-startingX
		end
	end	
	if	event.phase=="ended" and _G.isGameOver==false and isPulling==false then
		 if	#currentLetterArray>0 then	
			local tempStringLength=string.len(currentWordString)
						
			currentWordString=string.sub(currentWordString, 1, tempStringLength-1)
			word_Gp.wordText_Txt.text=string.upper(currentWordString)
			letterTile_Gp[currentLetterArray[#currentLetterArray]].isTapped=false
			letterTile_Gp[currentLetterArray[#currentLetterArray]][5].alpha=.0
			totalWordScore=(totalWordScore-(letterTile_Gp[currentLetterArray[#currentLetterArray]].value*_G.currentLevel))
			
			wordScore_Txt.text="+"..totalWordScore
			if	string.len(currentWordString)==9 then
				wordScore_Txt.text="+" .. totalWordScore .. " +" .. (currentBonusArray[string.len(currentWordString)]*_G.currentLevel)
				currentBonus=(currentBonusArray[string.len(currentWordString)]*_G.currentLevel)
			elseif	string.len(currentWordString)>4 then
				wordScore_Txt.text="+".. totalWordScore .. " +" .. (currentBonusArray[string.len(currentWordString)]*_G.currentLevel)
				currentBonus=(currentBonusArray[string.len(currentWordString)]*_G.currentLevel)
			else
				wordScore_Txt.text="+".. totalWordScore
				currentBonus=0
			end
			if	totalWordScore==0 then
				wordScore_Txt.text=""
				totalWordScore=0
			end
			wordScore_Txt_Shadow.text=wordScore_Txt.text

			table.remove(currentLetterArray, #currentLetterArray)
			manageWordCapsule(word_Gp.wordText_Txt.width)
		end
	end
	if	event.phase=="ended" then		
		if	isPulling then
			if	wordCapsule_Gp.x>wordCapsule_Gp.xO-20 and wordCapsule_Gp.x<wordCapsule_Gp.xO+20 then
			else
				isClear=true
				transition.to(wordCapsule_Gp, {time=100, x=wordCapsule_Gp.xO, transition=easing.inQuad, onComplete=submitWord})
			end
		end
		isTapped=false
		isPulling=false
		startingX=0
		newX=0
		xDiff=0
		display.getCurrentStage():setFocus(nil)
	end
	return true
end


wordCapsule_body_Img=display.newImageRect("img/capBody.png", capsuleWidth, 200)
wordCapsule_body_Img.x, wordCapsule_body_Img.y=0,0
wordCapsule_body_Img.xScale=-.1
wordCapsule_body_Img.yScale=-.1
wordCapsule_body_Img.alpha=0
wordCapsule_body_Img:addEventListener("touch", removeLetter)
wordCapsule_Gp:insert(wordCapsule_body_Img)

wordCapsule_leftEnd_Img=display.newImageRect("img/capEnd.png", 200, 200)
wordCapsule_leftEnd_Img.x, wordCapsule_leftEnd_Img.y=(-wordCapsule_body_Img.width*wordCapsule_body_Img.xScale)/2+1,0
wordCapsule_leftEnd_Img.xScale=-.1
wordCapsule_leftEnd_Img.yScale=-.1
wordCapsule_leftEnd_Img.alpha=0
wordCapsule_leftEnd_Img:addEventListener("touch", removeLetter)
wordCapsule_Gp:insert(wordCapsule_leftEnd_Img)

wordCapsule_righEnd_Img=display.newImageRect("img/capEnd.png", 200, 200)
wordCapsule_righEnd_Img.x, wordCapsule_righEnd_Img.y=(wordCapsule_body_Img.width*wordCapsule_body_Img.xScale)/2-1,0
wordCapsule_righEnd_Img.xScale=-.1
wordCapsule_righEnd_Img.yScale=-.1
wordCapsule_righEnd_Img.alpha=0
wordCapsule_righEnd_Img:addEventListener("touch", removeLetter)
wordCapsule_Gp:insert(wordCapsule_righEnd_Img)

function cancelPrevCapsuleAnims()
	if	wordCapsule_body_Img.anim~=nil then
		transition.cancel(wordCapsule_body_Img.anim)
	end
	if	wordCapsule_leftEnd_Img.anim~=nil then
		transition.cancel(wordCapsule_leftEnd_Img.anim)
	end
	if	wordCapsule_righEnd_Img.anim~=nil then
		transition.cancel(wordCapsule_righEnd_Img.anim)
	end
	
	if	wordCapsule_body_Img_Shadow.anim~=nil then
		transition.cancel(wordCapsule_body_Img_Shadow.anim)
	end
	if	wordCapsule_leftEnd_Img_Shadow.anim~=nil then
		transition.cancel(wordCapsule_leftEnd_Img_Shadow.anim)
	end
	if	wordCapsule_righEnd_Img_Shadow.anim~=nil then
		transition.cancel(wordCapsule_righEnd_Img_Shadow.anim)
	end
end

function manageWordCapsule(n)
	local newWidth=n
	local newCapsuleScale=(newWidth/capsuleWidth)+(.02*string.len(currentWordString))
	cancelPrevCapsuleAnims()
	
	wordCapsule_body_Img.alpha=1
	wordCapsule_leftEnd_Img.alpha=1
	wordCapsule_righEnd_Img.alpha=1
	
	if	string.len(currentWordString)>0 then
		wordCapsule_body_Img.anim=transition.to(wordCapsule_body_Img, {time=1000, xScale=newCapsuleScale, yScale=1, alpha=1, transition=easing.outElastic})
		wordCapsule_leftEnd_Img.anim=transition.to(wordCapsule_leftEnd_Img, {time=1000, xScale=1, yScale=1, alpha=1, x=(-wordCapsule_body_Img.width*newCapsuleScale)/2+1, transition=easing.outElastic})
		wordCapsule_righEnd_Img.anim=transition.to(wordCapsule_righEnd_Img, {time=1000, xScale=-1, yScale=1, alpha=1, x=(wordCapsule_body_Img.width*newCapsuleScale)/2-1, transition=easing.outElastic})
		
		wordCapsule_body_Img_Shadow.anim=transition.to(wordCapsule_body_Img_Shadow, {time=1000, xScale=newCapsuleScale, yScale=1, alpha=1, x=1, transition=easing.outElastic})
		wordCapsule_leftEnd_Img_Shadow.anim=transition.to(wordCapsule_leftEnd_Img_Shadow, {time=1000, xScale=1, yScale=1, alpha=1, x=(-wordCapsule_body_Img_Shadow.width*newCapsuleScale)/2+1+1, transition=easing.outElastic})
		wordCapsule_righEnd_Img_Shadow.anim=transition.to(wordCapsule_righEnd_Img_Shadow, {time=1000, xScale=-1, yScale=1, alpha=1, x=(wordCapsule_body_Img_Shadow.width*newCapsuleScale)/2-1+1, transition=easing.outElastic})
		
	else
		newWidth=0
		newCapsuleScale=newWidth/capsuleWidth
		function alphaTheCap()
			wordCapsule_body_Img.alpha=0
			wordCapsule_leftEnd_Img.alpha=0
			wordCapsule_righEnd_Img.alpha=0
		end
		
		wordCapsule_body_Img.anim=transition.to(wordCapsule_body_Img, {time=300, xScale=newCapsuleScale, yScale=0.001, alpha=1, transition=easing.outExpo})
		wordCapsule_leftEnd_Img.anim=transition.to(wordCapsule_leftEnd_Img, {time=300, xScale=0.001, yScale=0.001, alpha=1, x=(-wordCapsule_body_Img.width*newCapsuleScale)/2+1, transition=easing.outExpo})
		wordCapsule_righEnd_Img.anim=transition.to(wordCapsule_righEnd_Img, {time=300, xScale=0.001, yScale=0.001, alpha=1, x=(wordCapsule_body_Img.width*newCapsuleScale)/2-1, transition=easing.outExpo, onComplete=alphaTheCap})
	
		wordCapsule_body_Img_Shadow.anim=transition.to(wordCapsule_body_Img_Shadow, {time=300, xScale=newCapsuleScale, yScale=0.001, alpha=0, transition=easing.outExpo})
		wordCapsule_leftEnd_Img_Shadow.anim=transition.to(wordCapsule_leftEnd_Img_Shadow, {time=300, xScale=0.001, yScale=0.001, alpha=0, x=(-wordCapsule_body_Img_Shadow.width*newCapsuleScale)/2+1, transition=easing.outExpo})
		wordCapsule_righEnd_Img_Shadow.anim=transition.to(wordCapsule_righEnd_Img_Shadow, {time=300, xScale=0.001, yScale=0.001, alpha=0, x=(wordCapsule_body_Img_Shadow.width*newCapsuleScale)/2-1, transition=easing.outExpo})
	end
end

function manageBestWordCapsule(n)
	local newWidth=n
	local newCapsuleScale=(newWidth/capsuleWidth)+(.02*string.len(currentWordString))
	cancelPrevCapsuleAnims()
	
	wordCapsule_body_Img.alpha=1
	wordCapsule_leftEnd_Img.alpha=1
	wordCapsule_righEnd_Img.alpha=1
	
	if	string.len(currentWordString)>0 then
		wordCapsule_body_Img.anim=transition.to(wordCapsule_body_Img, {time=1000, xScale=newCapsuleScale, yScale=.5, alpha=1, transition=easing.outElastic})
		wordCapsule_leftEnd_Img.anim=transition.to(wordCapsule_leftEnd_Img, {time=1000, xScale=.5, yScale=.5, alpha=1, x=(-wordCapsule_body_Img.width*newCapsuleScale)/2+1, transition=easing.outElastic})
		wordCapsule_righEnd_Img.anim=transition.to(wordCapsule_righEnd_Img, {time=1000, xScale=-.5, yScale=.5, alpha=1, x=(wordCapsule_body_Img.width*newCapsuleScale)/2-1, transition=easing.outElastic})
		
		wordCapsule_body_Img_Shadow.anim=transition.to(wordCapsule_body_Img_Shadow, {time=1000, xScale=newCapsuleScale, yScale=.5, alpha=1, x=1, transition=easing.outElastic})
		wordCapsule_leftEnd_Img_Shadow.anim=transition.to(wordCapsule_leftEnd_Img_Shadow, {time=1000, xScale=.5, yScale=.5, alpha=1, x=(-wordCapsule_body_Img_Shadow.width*newCapsuleScale)/2+1+1, transition=easing.outElastic})
		wordCapsule_righEnd_Img_Shadow.anim=transition.to(wordCapsule_righEnd_Img_Shadow, {time=1000, xScale=-.5, yScale=.5, alpha=1, x=(wordCapsule_body_Img_Shadow.width*newCapsuleScale)/2-1+1, transition=easing.outElastic})
		
	else
		newWidth=0
		newCapsuleScale=newWidth/capsuleWidth
		function alphaTheCap()
			wordCapsule_body_Img.alpha=0
			wordCapsule_leftEnd_Img.alpha=0
			wordCapsule_righEnd_Img.alpha=0
		end
		
		wordCapsule_body_Img.anim=transition.to(wordCapsule_body_Img, {time=300, xScale=newCapsuleScale, yScale=0.001, alpha=1, transition=easing.outExpo})
		wordCapsule_leftEnd_Img.anim=transition.to(wordCapsule_leftEnd_Img, {time=300, xScale=0.001, yScale=0.001, alpha=1, x=(-wordCapsule_body_Img.width*newCapsuleScale)/2+1, transition=easing.outExpo})
		wordCapsule_righEnd_Img.anim=transition.to(wordCapsule_righEnd_Img, {time=300, xScale=0.001, yScale=0.001, alpha=1, x=(wordCapsule_body_Img.width*newCapsuleScale)/2-1, transition=easing.outExpo, onComplete=alphaTheCap})
	
		wordCapsule_body_Img_Shadow.anim=transition.to(wordCapsule_body_Img_Shadow, {time=300, xScale=newCapsuleScale, yScale=0.001, alpha=0, transition=easing.outExpo})
		wordCapsule_leftEnd_Img_Shadow.anim=transition.to(wordCapsule_leftEnd_Img_Shadow, {time=300, xScale=0.001, yScale=0.001, alpha=0, x=(-wordCapsule_body_Img_Shadow.width*newCapsuleScale)/2+1, transition=easing.outExpo})
		wordCapsule_righEnd_Img_Shadow.anim=transition.to(wordCapsule_righEnd_Img_Shadow, {time=300, xScale=0.001, yScale=0.001, alpha=0, x=(wordCapsule_body_Img_Shadow.width*newCapsuleScale)/2-1, transition=easing.outExpo})
	end
end


word_Gp.x, word_Gp.y=0,100
word_Gp.xO, word_Gp.yO=0,100
word_Gp.xScale, word_Gp.yScale=2,2
wordCapsule_Gp:insert(word_Gp)

wordText_Txt=display.newText(currentWordString,0,0,native.systemFont, 34)
wordText_Txt:setFillColor(0/255)
wordText_Txt:addEventListener("touch", removeLetter)
wordText_Txt.x, wordText_Txt.y=0,-56
wordText_Txt.xScale, wordText_Txt.yScale=1,1
word_Gp.wordText_Txt=wordText_Txt
word_Gp:insert(wordText_Txt)

wordScore_Txt_Shadow=display.newText("",0,0,native.systemFont, 22)
wordScore_Txt_Shadow:setFillColor(255/255,255/255,255/255,200/255)
wordScore_Txt_Shadow.x, wordScore_Txt_Shadow.y=0,-30.5
gameStage.wordScore_Txt_Shadow=wordScore_Txt_Shadow
word_Gp:insert(wordScore_Txt_Shadow)

wordScore_Txt=display.newText("",0,0,native.systemFont, 22)
wordScore_Txt:setFillColor(0/255,0/255,0/255)
wordScore_Txt.x, wordScore_Txt.y=0,-31
gameStage.wordScore_Txt=wordScore_Txt
word_Gp:insert(wordScore_Txt)

totalScoreShadow_Gp=display.newGroup()
totalScoreShadow_Gp.x, totalScoreShadow_Gp.y=_W-75,-_H+25
totalScoreShadow_Gp.alpha=1
totalScoreShadow_Gp.anchorX=1
gameStage:insert(totalScoreShadow_Gp)

totalScoreShadow_Txt=display.newText(currentScore .. " /",0,0,native.systemFont, 44)
totalScoreShadow_Txt:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
totalScoreShadow_Txt.x, totalScoreShadow_Txt.y=0,.5
totalScoreShadow_Txt.anchorX=1
-- totalScore_Txt.xScale, totalScore_Txt.yScale=.9,1
totalScoreShadow_Gp.totalScoreShadow_Txt=totalScoreShadow_Txt
totalScoreShadow_Gp:insert(totalScoreShadow_Txt)

totalScoreShadowA_Txt=display.newText(currentScore  .. " /",0,0,native.systemFont, 44)
totalScoreShadowA_Txt:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
totalScoreShadowA_Txt.x, totalScoreShadowA_Txt.y=0,1
totalScoreShadowA_Txt.anchorX=1
-- totalScore_Txt.xScale, totalScore_Txt.yScale=.9,1
totalScoreShadow_Gp.totalScoreShadowA_Txt=totalScoreShadowA_Txt
totalScoreShadow_Gp:insert(totalScoreShadowA_Txt)

totalScore_Txt=display.newText(currentScore .. " /",0,0,native.systemFont, 44)
totalScore_Txt:setFillColor(70/255,70/255,70/255)
totalScore_Txt.x, totalScore_Txt.y=_W-75,-_H+25
totalScore_Txt.anchorX=1
-- totalScore_Txt.xScale, totalScore_Txt.yScale=.9,1
gameStage.totalScore_Txt=totalScore_Txt
gameStage:insert(totalScore_Txt)

highScore_Txt_Shadow=display.newText(_G.highScore[1],0,0,native.systemFont, 24)
highScore_Txt_Shadow:setFillColor(0/255,0/255,0/255)
highScore_Txt_Shadow.x, highScore_Txt_Shadow.y=_W-40,-_H+22.5
highScore_Txt_Shadow:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
-- highScore_Txt.xScale, highScore_Txt.yScale=.9,1
gameStage.highScore_Txt_Shadow=highScore_Txt_Shadow
gameStage:insert(highScore_Txt_Shadow)

highScore_Txt=display.newText(_G.highScore[1],0,0,native.systemFont, 24)
highScore_Txt:setFillColor(70/255,70/255,70/255)
highScore_Txt.x, highScore_Txt.y=_W-40,-_H+22
-- highScore_Txt.xScale, highScore_Txt.yScale=.9,1
gameStage.highScore_Txt=highScore_Txt
gameStage:insert(highScore_Txt)

multiplier_Txt_Shadow=display.newText("1x",0,0,native.systemFont, 44)
multiplier_Txt_Shadow:setFillColor(0/255,0/255,0/255)
multiplier_Txt_Shadow.x, multiplier_Txt_Shadow.y=-_W+20,-_H+25.5
multiplier_Txt_Shadow.anchorX=0
multiplier_Txt_Shadow:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
-- multiplier_Txt.xScale, multiplier_Txt.yScale=.9,1
gameStage.multiplier_Txt_Shadow=multiplier_Txt_Shadow
gameStage:insert(multiplier_Txt_Shadow)

multiplier_Txt=display.newText("1x",0,0,native.systemFont, 44)
multiplier_Txt:setFillColor(70/255,70/255,70/255)
multiplier_Txt.x, multiplier_Txt.y=-_W+20,-_H+25
multiplier_Txt.anchorX=0
-- multiplier_Txt.xScale, multiplier_Txt.yScale=.9,1
gameStage.multiplier_Txt=multiplier_Txt
gameStage:insert(multiplier_Txt)


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

	local timerArray={}

	function tapLetter(event)
		if	event.phase=="began" and _G.isGameOver==false then
			if	event.target.isTapped==false then
				display.getCurrentStage():setFocus(event.target)				
				event.target.isTapped=true
				event.target[5].alpha=.3
				function popLetterButton()
					function popLetterBackUp()
						transition.to(event.target, {time=50, xScale=event.target.xO_Scale, yScale=event.target.yO_Scale, transition=easing.outBounce})
					end
					transition.to(event.target, {time=30, xScale=event.target.xO_Scale-.15, yScale=event.target.yO_Scale-.15, onComplete=popLetterBackUp, transition=easing.outBounce})
				end
				popLetterButton()
				currentWordString=currentWordString .. event.target.letter
				word_Gp.wordText_Txt.text=string.upper(currentWordString)
				currentLetterArray[#currentLetterArray+1]=event.target.place
				totalWordScore=(totalWordScore+(letterTile_Gp[currentLetterArray[#currentLetterArray]].value*_G.currentLevel))

				if	string.len(currentWordString)>9 then
					wordScore_Txt.text="+" .. totalWordScore .. " +" .. (currentBonusArray[string.len(currentWordString)]*_G.currentLevel)
					currentBonus=(currentBonusArray[string.len(currentWordString)]*_G.currentLevel)
				elseif	string.len(currentWordString)>4 then
					wordScore_Txt.text="+".. totalWordScore .. " +" .. (currentBonusArray[string.len(currentWordString)]*_G.currentLevel)
					currentBonus=(currentBonusArray[string.len(currentWordString)]*_G.currentLevel)
				else
					wordScore_Txt.text="+".. totalWordScore
					currentBonus=0
				end
				wordScore_Txt_Shadow.text=wordScore_Txt.text

				manageWordCapsule(word_Gp.wordText_Txt.width)
			end
		end
		if	event.phase=="ended" then
			display.getCurrentStage():setFocus(nil)
		end
		return true
	end
	
	function gameOver(event)	
		transition.cancel("letterAlarm")
	
		transition.to(level_Gp, {time=1000, xScale=40, yScale=40, transition=easing.inExpo})		
		highScore_Txt.alpha=1
		highScore_Txt_Shadow.alpha=1

		letterTile_Gp[event.source.params.obj.place].isAlive=false
		local isNewHighScore=false
		if	#timerArray>0 then
			for i=1,#timerArray do
				timer.cancel(timerArray[1][2])
				table.remove(timerArray, 1)
			end
		end
	
		local gameOverAnim=4000
	
		_G.isGameOver=true
		currentWordString=""
		word_Gp.wordText_Txt.text=currentWordString
		manageWordCapsule(0)
		totalWordScore=0
		wordScore_Txt.text=""
		wordScore_Txt_Shadow.text=""
	
		_G.drumPattern=0
	
		switchMusic=0
		_G.switchCurrentScale=0
		_G.drumTime=_G.origDrumTime
		if	currentScore>_G.highScore[1] then					  	
			_G.highScore[1]=currentScore
			highScore_Txt.text=_G.highScore[1]
			highScore_Txt_Shadow.text=_G.highScore[1]
		
			highScore_Txt.alpha=1.0
			highScore_Txt_Shadow.alpha=1.0
		
			_G.saveScoresFile()			
			isNewHighScore=true
		end
		if	#bestWordArray>0 then
			bestWord_Text.text="BEST WORD: " .. string.upper(bestWordArray[1][2]) .. " (" .. bestWordArray[1][1] .. ")"
			bestWord_Text_Shadow.text="BEST WORD: " .. string.upper(bestWordArray[1][2]) .. " (" .. bestWordArray[1][1] .. ")"
			local wordPattern=bestWordArray[1][2]
			function showBestWordArt()
				function finishShowBestWordArt()
					function finishShowRestart()
						function setCanReset()
							canReset=true
						end
						transition.to(gameOverTile_Gp, {alpha=1, time=300, onComplete=setCanReset})
					end
					timer.performWithDelay(400, finishShowRestart, 1)						
					manageBestWordCapsule(bestWord_Text.width*1.6)
					wordCapsule_Gp.y=bestWord_Text.y-2
					-- wordCapsule_Gp.xScale, wordCapsule_Gp.yScale=.5,.5
					bestWord_Text.alpha=1
					bestWord_Text_Shadow.alpha=1
				end
				timer.performWithDelay(400, finishShowBestWordArt, 1)						
			end
			timer.performWithDelay(1200, showBestWordArt, 1)		
		else
			bestWord_Text.text=""
			bestWord_Text.alpha=0.0
		
			bestWord_Text_Shadow.text=""
			bestWord_Text_Shadow.alpha=0.0
		end
			
		if	#bestWordArray==0 then
			function finishShowRestart()
				function setCanReset()
					canReset=true
				end
				transition.to(gameOverTile_Gp, {alpha=1, delay=300, time=300, onComplete=setCanReset})
			end
			timer.performWithDelay(400, finishShowRestart, 1)						
		end
	
		function _G.alphaGameOverSlam_Anim()
			_G.gameOverSlam_Gp.alpha=.6
			_G.gameOverSlam_Gp.xScale, _G.gameOverSlam_Gp.yScale=.8, .8
			transition.to(_G.gameOverSlam_Gp, {time=_G.origDrumTime, xScale=.001, yScale=.001, alpha=0, transition=easing.inOutQuad})
		end
	
		if	isNewHighScore then
			gameOverSlamGame_Text.text=""
			gameOverSlamOver_Text.text=""
		else
			gameOverSlamGame_Text.text=""
			gameOverSlamOver_Text.text=""
		end

		_G.gameOverSlam_Gp.x, _G.gameOverSlam_Gp.y=0,0
		_G.gameOverSlam_Gp.alpha=0.0
		_G.gameOverSlam_Gp.xScale, _G.gameOverSlam_Gp.yScale=.8, .8
		
		_G.alphaGameOverSlam_Anim()
			
		for i=1,letterTile_Gp.numChildren do
			-- letterTile_Gp[i][5].alpha=.0
			if	letterTile_Gp[i][2].anim~=nil then
				if	letterTile_Gp[i].isAlive==false then
					local tempAnimArray={1,2,3,4,5,6,7,8,9}
					table.remove(tempAnimArray, i)
					transition.cancel(letterTile_Gp[i][2].anim)
					transition.to(letterTile_Gp[i], {delay=1000, time=100, y=_H-75, transition=easing.inOutExpo})
					for j=1,#tempAnimArray do
						if	letterTile_Gp[tempAnimArray[j]][2].anim~=nil  then
							transition.cancel(letterTile_Gp[tempAnimArray[j]][2].anim)
							transition.to(letterTile_Gp[tempAnimArray[j]], {delay=((j-1)*(1100/9)), time=100, y=_H-75, transition=easing.inOutQuad})
						end
					end			
				end
			end
		end
		transition.to(checkButton_Img, {time=100, alpha=0})				
	end

	function selectAvailableLetter()
		local isAcceptable
		local tempNum
		function checkVowelConsonantBalance()
			isAcceptable=true
			tempNum=math.random(#letterSelectArray)
			
			while (letterSelectArray[tempNum][1]=="a" or letterSelectArray[tempNum][1]=="e" or letterSelectArray[tempNum][1]=="i" or letterSelectArray[tempNum][1]=="o" or letterSelectArray[tempNum][1]=="u" or letterSelectArray[tempNum][1]=="y") and totalVowels==4 do
				tempNum=math.random(#letterSelectArray)
			end
		
			while (letterSelectArray[tempNum][1]~="a" and letterSelectArray[tempNum][1]~="e" and letterSelectArray[tempNum][1]~="i" and letterSelectArray[tempNum][1]~="o" and letterSelectArray[tempNum][1]~="u" and letterSelectArray[tempNum][1]~="y") and totalConsonants==5 do
				tempNum=math.random(#letterSelectArray)
			end
		end
		
		function updateTotalVowelConsonants()
			if	letterSelectArray[tempNum][1]=="a" or letterSelectArray[tempNum][1]=="e" or letterSelectArray[tempNum][1]=="i" or letterSelectArray[tempNum][1]=="o" or letterSelectArray[tempNum][1]=="u" or letterSelectArray[tempNum][1]=="y" then
				if	totalVowels<=4 then 
					totalVowels=totalVowels+1
				end
			end
		
			if	letterSelectArray[tempNum][1]~="a" and letterSelectArray[tempNum][1]~="e" and letterSelectArray[tempNum][1]~="i" and letterSelectArray[tempNum][1]~="o" and letterSelectArray[tempNum][1]~="u" and letterSelectArray[tempNum][1]~="y" then
				if	totalConsonants<=5 then 
					totalConsonants=totalConsonants+1
				end
			end
		end
				
		function checkDuplicates()
			local tempDup=0
			local totalDups=0
			local isDup=false
			
			local dupLetterRand=math.random(100)
			
			if	dupLetterRand>10 then
				for i=1,letterTile_Gp.numChildren do
					for j=1,letterTile_Gp.numChildren do
						if	letterTile_Gp[i].letter==letterTile_Gp[j].letter and i~=j then
							totalDups=totalDups+1
						end
					end
					if	letterTile_Gp[i].letter==letterSelectArray[tempNum][1] then
						totalDups=totalDups+1
						isDup=true
					end
				end
				if	totalDups>4 then
					isAcceptable=false
				end
			else
				for i=1,letterTile_Gp.numChildren do
					if	letterTile_Gp[i].letter==letterSelectArray[tempNum][1] then
						isAcceptable=false
					end
				end
			end
			
			for i=1,letterTile_Gp.numChildren do
				if	letterTile_Gp[i].letter==letterSelectArray[tempNum][1] then
					tempDup=tempDup+1
				end
			end
			local noDuplicatesEverArray={"Y","X","J","Z","Q","W","B", "V"}
			for i=1,letterTile_Gp.numChildren do
				for j=1,#noDuplicatesEverArray do
					if	isDup and letterSelectArray[tempNum][1]==noDuplicatesEverArray[j] then
						isAcceptable=false
					end
				end
				if	letterTile_Gp[i].letter==letterSelectArray[tempNum][1] then
					tempDup=tempDup+1
				end
			end
			if	tempDup>2 then
				isAcceptable=false
			end
			while isAcceptable==false do
				checkVowelConsonantBalance()
				checkDuplicates()
			end
		end
		
		checkVowelConsonantBalance()
		
		checkDuplicates()
		
		if	isAcceptable then
			updateTotalVowelConsonants()
		end
		
		return tempNum
	end
	
	function makeLetterTile(n)
		local tile_Gp=display.newGroup()
		tile_Gp.x, tile_Gp.y=letterTile_Gp.numChildren*62.5-(totalTilesOnScreen*62.5)/2+31.25-(_W*2.5),0
		tile_Gp.xScale, tile_Gp.yScale=.58,.58
		tile_Gp.xO_Scale, tile_Gp.yO_Scale=.58,.58
		tile_Gp:addEventListener("touch", tapLetter)
		local tempRandLetter=selectAvailableLetter()
		if	tempRandLetter~=0 then
			tile_Gp.letter=letterSelectArray[tempRandLetter][1]
			tile_Gp.value=letterSelectArray[tempRandLetter][2]
		end
		tile_Gp.place=n
		tile_Gp.speed=0
		tile_Gp.isAlive=true
		tile_Gp.isTapped=false
	
		local tileBase_Img
		tileBase_Img=display.newImageRect("img/tile.png", 110, 110)
		tileBase_Img.x, tileBase_Img.y=0,0
		tileBase_Img.alpha=1
		if	tempRandLetter==0 then
			tileBase_Img.alpha=0.0
		end
		tileBase_Img.xScale, tileBase_Img.yScale=.99,.99
		tile_Gp:insert(tileBase_Img)
		
		local tileAlert_Rect
		tileAlert_Rect=display.newImageRect("img/tile.png", 110, 110)
		tileAlert_Rect.x, tileAlert_Rect.y=0,00
		tileAlert_Rect.alpha=.1
		if	tempRandLetter==0 then
			tileAlert_Rect.alpha=0.0
		end
		tileAlert_Rect:setFillColor(252/255, 80/255, 80/255)
		tile_Gp:insert(tileAlert_Rect)
		
		if	tempRandLetter~=0 then
			if( display.imageSuffix == "@4x" ) then
				mask = graphics.newMask( "img/tileMask@4x.png" )
				tileAlert_Rect:setMask( mask )
				tileAlert_Rect.maskScaleX = 0.25
				tileAlert_Rect.maskScaleY = 0.25
				tileAlert_Rect.maskY=100
			elseif( display.imageSuffix == "@2x" ) then
				mask = graphics.newMask( "img/tileMask@2x.png" )
				tileAlert_Rect:setMask( mask )
				tileAlert_Rect.maskScaleX = 0.50
				tileAlert_Rect.maskScaleY = 0.50
				tileAlert_Rect.maskY=100
			else
				mask = graphics.newMask( "img/tileMask.png" )
				tileAlert_Rect:setMask( mask )
				tileAlert_Rect.maskY=100
			end
		end
		
		function tile_Gp.setTileAnim()
			tile_Gp.anim=transition.to(tile_Gp, {delay=((4000* (tile_Gp.value*(50 / _G.currentLevel)))*(tileAlert_Rect.maskY/100)/4)*2.5, time=100, y=tile_Gp.y-2, iterations=-1, transition=easing.continuousLoop, tag="letterAlarm"})
			
			tileAlert_Rect.anim=transition.to(tileAlert_Rect, {time=(4000* (tile_Gp.value*(50 / _G.currentLevel)))*(tileAlert_Rect.maskY/100), alpha=1, maskY=0, tag="letterAlert"})
			local newTileTimer=timer.performWithDelay((4000* (tile_Gp.value*(50 / _G.currentLevel)))*(tileAlert_Rect.maskY/100), gameOver, 1)
			newTileTimer.params = { obj = tile_Gp }
			timerArray[#timerArray+1]={tile_Gp.place, newTileTimer}
		end
		
		function tile_Gp.cancelTileAnim()
			if	tileAlert_Rect.anim~=nil then
				transition.cancel(tileAlert_Rect.anim)
			end
		end
		
		if	tempRandLetter~=0 then
			tile_Gp.setTileAnim()		
		
			tileLetter_Txt=display.newText(string.upper(tile_Gp.letter),0,0,native.systemFont, 64)
			tileLetter_Txt:setFillColor(0/255,0/255,0/255)
			tileLetter_Txt.x, tileLetter_Txt.y=0,10
			tileLetter_Txt.xScale, tileLetter_Txt.yScale=1,1
			tileLetter_Txt.alpha=1
			tile_Gp:insert(tileLetter_Txt)
				
			tileValue_Txt=display.newText(tile_Gp.value,0,0,native.systemFont, 24)
			tileValue_Txt:setFillColor(0/255,0/255,0/255)
			tileValue_Txt.x, tileValue_Txt.y=30,-30
			tile_Gp:insert(tileValue_Txt)
		
			local tileLetterSelected_Txt
			tileLetterSelected_Txt=display.newImageRect("img/tile.png", 110, 110)
			tileLetterSelected_Txt.x, tileLetterSelected_Txt.y=0,0
			tileLetterSelected_Txt.alpha=0
			tileLetterSelected_Txt.xScale, tileLetterSelected_Txt.yScale=.99,.99
			tileLetterSelected_Txt:setFillColor(0/255)
			tile_Gp:insert(tileLetterSelected_Txt)
		end						
		
		letterTile_Gp:insert(tile_Gp)
	end
			
	function incMultiplier()
		if	_G.currentLevel<10 then
			currentLevelProgress=currentLevelProgress+1
			baseColorSlider_Rect.alpha=1
			if	currentLevelProgress==3 then				
				_G.currentLevel=_G.currentLevel+1
				multiplier_Txt.text=_G.currentLevel .. "x"
				multiplier_Txt_Shadow.text=multiplier_Txt.text
			
				if	#timerArray>0 then
					for i=1,#timerArray do
						timer.cancel(timerArray[1][2])
						table.remove(timerArray, 1)
					end
				end
				for i=1,letterTile_Gp.numChildren do
					if	letterTile_Gp[i][2].anim~=nil then
						transition.cancel(letterTile_Gp[i][2].anim)
					end
					letterTile_Gp[i].setTileAnim()
				end
			end
			function swapColors()
				if	currentLevelProgress==3 then				
					currentLevelProgress=0
					tileAnim_Gp.alpha=0
					-- transition.to(tileAnim_Gp, {time=200, alpha=1, transition=easing.outExpo})
					baseColor_Rect.alpha=1
					local function fadeInScore()
						highScore_Txt_Shadow:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
						transition.to(highScore_Txt_Shadow, {time=100, alpha=1})
					
						multiplier_Txt_Shadow:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
						transition.to(multiplier_Txt_Shadow, {time=100, alpha=1})
					
						totalScoreShadow_Txt:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
						totalScoreShadowA_Txt:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
						transition.to(totalScoreShadow_Gp, {time=100, alpha=1})
					end
					transition.to(totalScoreShadow_Gp, {time=100, alpha=0, onComplete=fadeInScore})
					transition.to(multiplier_Txt_Shadow, {time=100, alpha=0})
					transition.to(highScore_Txt_Shadow, {time=100, alpha=0})
				
					baseColor_Rect:setFillColor(colorArray[_G.currentLevel][1], colorArray[_G.currentLevel][2], colorArray[_G.currentLevel][3])
					baseColorSlider_Rect:setFillColor(colorArray[_G.currentLevel+1][1], colorArray[_G.currentLevel+1][2], colorArray[_G.currentLevel+1][3])
					baseColorSlider_Rect.y=baseColorSlider_Rect.yO
					baseColorSlider_Rect.xScale=-.1
					baseColorSlider_Rect.yScale=1
					baseColorSlider_Rect.alpha=0.0
				end
			end
			if	currentLevelProgress==3 then
				transition.to(baseColorSlider_Rect, {delay=300, time=200, y=0, transition=easing.inExpo, onComplete=swapColors})
				transition.to(baseColorSlider_Rect, {time=500, xScale=currentLevelProgress/3, transition=easing.outElastic})
			else
				transition.to(baseColorSlider_Rect, {time=500, xScale=currentLevelProgress/3, transition=easing.outElastic, onComplete=swapColors})
			end
		else
			currentLevelProgress=currentLevelProgress+1
			if	currentLevelProgress==3 then
				_G.currentLevel=_G.currentLevel+1
				print("BOOM: " .. _G.currentLevel)
				multiplier_Txt.text=_G.currentLevel .. "x"
				multiplier_Txt_Shadow.text=multiplier_Txt.text
			
				if	#timerArray>0 then
					for i=1,#timerArray do
						timer.cancel(timerArray[1][2])
						table.remove(timerArray, 1)
					end
				end
				for i=1,letterTile_Gp.numChildren do
					if	letterTile_Gp[i][2].anim~=nil then
						transition.cancel(letterTile_Gp[i][2].anim)
					end
					letterTile_Gp[i].setTileAnim()
				end
			end
			function swapColors()
				if	currentLevelProgress==3 then				
					currentLevelProgress=0
					tileAnim_Gp.alpha=0
					-- transition.to(tileAnim_Gp, {time=200, alpha=1, transition=easing.outExpo})
					baseColor_Rect.alpha=1
					local function fadeInScore()
						highScore_Txt_Shadow:setFillColor(colorPatterArray[10][1], colorPatterArray[10][2], colorPatterArray[10][3])
						transition.to(highScore_Txt_Shadow, {time=100, alpha=1})
					
						multiplier_Txt_Shadow:setFillColor(colorPatterArray[10][1], colorPatterArray[10][2], colorPatterArray[10][3])
						transition.to(multiplier_Txt_Shadow, {time=100, alpha=1})
					
						totalScoreShadow_Txt:setFillColor(colorPatterArray[10][1], colorPatterArray[10][2], colorPatterArray[10][3])
						totalScoreShadowA_Txt:setFillColor(colorPatterArray[10][1], colorPatterArray[10][2], colorPatterArray[10][3])
						transition.to(totalScoreShadow_Gp, {time=100, alpha=1})
					end
					transition.to(totalScoreShadow_Gp, {time=100, alpha=0, onComplete=fadeInScore})
					transition.to(multiplier_Txt_Shadow, {time=100, alpha=0})
					transition.to(highScore_Txt_Shadow, {time=100, alpha=0})
				
					baseColor_Rect:setFillColor(colorArray[10][1], colorArray[10][2], colorArray[10][3])
					baseColorSlider_Rect:setFillColor(colorArray[10+1][1], colorArray[10+1][2], colorArray[10+1][3])
					baseColorSlider_Rect.y=baseColorSlider_Rect.yO
					baseColorSlider_Rect.xScale=-.1
					baseColorSlider_Rect.yScale=1
					baseColorSlider_Rect.alpha=0.0
				end
			end
			if	currentLevelProgress==3 then
				transition.to(baseColorSlider_Rect, {delay=300, time=200, y=0, transition=easing.inExpo, onComplete=swapColors})
				transition.to(baseColorSlider_Rect, {time=500, xScale=currentLevelProgress/3, transition=easing.outElastic})
			else
				transition.to(baseColorSlider_Rect, {time=500, xScale=currentLevelProgress/3, transition=easing.outElastic, onComplete=swapColors})
			end
		end
	end
	
	function resetMultiplier()
		local lastLevelAchieved=_G.currentLevel
		if	_G.currentLevel>1 then
			if	currentLevelProgress==0 then
				baseColor_Rect:setFillColor(colorArray[1][1], colorArray[1][2], colorArray[1][3])
				baseColorSlider_Rect:setFillColor(colorArray[_G.currentLevel][1], colorArray[_G.currentLevel][2], colorArray[_G.currentLevel][3])
				baseColorSlider_Rect.xScale=1
				baseColorSlider_Rect.alpha=1
				function pullBackNextColor()
					baseColorSlider_Rect:setFillColor(colorArray[_G.currentLevel+1][1], colorArray[_G.currentLevel+1][2], colorArray[_G.currentLevel+1][3])
				end
				transition.to(baseColorSlider_Rect, {time=200, xScale=-.01, transition=easing.inExpo, onComplete=pullBackNextColor})
			else
				function pullBackNextColor()
					baseColorSlider_Rect:setFillColor(colorArray[_G.currentLevel+1][1], colorArray[_G.currentLevel+1][2], colorArray[_G.currentLevel+1][3])
					baseColor_Rect:setFillColor(colorArray[1][1], colorArray[1][2], colorArray[1][3])
					baseColor_Rect.xScale=1	
					-- baseColorSlider_Rect1:setFillColor(colorArray[currentLevel+1][1], colorArray[currentLevel+1][2], colorArray[currentLevel+1][3])
				end
				transition.to(baseColorSlider_Rect, {time=200, xScale=-.01, transition=easing.inExpo})
				transition.to(baseColor_Rect, {delay=200, time=200, xScale=-.01, transition=easing.inExpo, onComplete=pullBackNextColor})					
			end
		else
			transition.to(baseColorSlider_Rect, {time=200, xScale=-.01, transition=easing.inExpo})
		end
	end
	
	function makeGameOverTiles()
		local function restartGame(event)
			if event.phase=="began" and canReset then
				if	_G.currentLevel<10 then
					highScore_Txt_Shadow:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
					multiplier_Txt_Shadow:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
					totalScoreShadow_Txt:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
					totalScoreShadowA_Txt:setFillColor(colorPatterArray[_G.currentLevel][1], colorPatterArray[_G.currentLevel][2], colorPatterArray[_G.currentLevel][3])
				else
					highScore_Txt_Shadow:setFillColor(colorPatterArray[10][1], colorPatterArray[10][2], colorPatterArray[10][3])
					multiplier_Txt_Shadow:setFillColor(colorPatterArray[10][1], colorPatterArray[10][2], colorPatterArray[10][3])
					totalScoreShadow_Txt:setFillColor(colorPatterArray[10][1], colorPatterArray[10][2], colorPatterArray[10][3])
					totalScoreShadowA_Txt:setFillColor(colorPatterArray[10][1], colorPatterArray[10][2], colorPatterArray[10][3])
				end
				
				newHighScore_Img_Top.anim=transition.to(newHighScore_Img_Top, {time=100, alpha=0})
				bestWordArray={}
				isHighScoreEvent=false

				for i=1,letterTile_Gp.numChildren do
					letterTile_Gp[1].cancelTileAnim()
					letterTile_Gp[1]:removeSelf()
				end
				gameOverTile_Gp.alpha=0.0
				
				bestWord_Text.alpha=0.0
				bestWord_Text_Shadow.alpha=0.0
				
				canReset=false
				
				currentWordString=""
				currentLetterArray={}
								
				totalWordScore=0
				currentScore=0
				totalScore_Txt.text=currentScore .. " /"
				totalScoreShadow_Txt.text=currentScore .. " /"
				totalScoreShadowA_Txt.text=currentScore .. " /"
				
				_G.isGameOver=false
				
				resetMultiplier()
				
				_G.currentLevel=1
				currentLevelProgress=0
				
				multiplier_Txt.text=_G.currentLevel .. "x"
				multiplier_Txt_Shadow.text=multiplier_Txt.text
				
				totalVowels=0
				totalConsonants=0
				
				function resetLetterTiles()
					for i=1,totalTilesOnScreen do
						makeLetterTile(i)
					end
					setTileLocations()
				end
				
				timer.performWithDelay(200, resetLetterTiles, 1)
								
				transition.to(checkButton_Img, {time=200, alpha=1})
				
				manageWordCapsule(0)
				wordCapsule_Gp.y=wordCapsule_Gp.yO
			end
		end
		
		restart_Img=display.newImageRect("img/reset.png", 50, 50)
		restart_Img.x, restart_Img.y=0,-gameOverTile_Gp.y
		restart_Img.rotation=-90
		
		restart_Img_Under=display.newImageRect("img/reset.png", 50, 50)
		restart_Img_Under.x, restart_Img_Under.y=0,-gameOverTile_Gp.y+1
		restart_Img_Under.rotation=-90
		
		
		function rotateRestartBtn()
			transition.to(restart_Img, {time=10000, rotation=restart_Img.rotation-360, onComplete=rotateRestartBtn})
			transition.to(restart_Img_Under, {time=10000, rotation=restart_Img.rotation-360})
			
		end
		rotateRestartBtn()
		
		restart_Img_Under:setFillColor(255/255)
		gameOverTile_Gp:insert(restart_Img_Under)
		
		restart_Img:setFillColor(0)
		restart_Img:addEventListener("touch", restartGame)
		gameOverTile_Gp:insert(restart_Img)
		
		gameOverTile_Gp.alpha=0.0
	end
	
	makeGameOverTiles()
	
	function setTileLocations()
		for i=1,letterTile_Gp.numChildren do
			letterTile_Gp[i].xO, letterTile_Gp[i].yO=(9-(i))*62.5-(totalTilesOnScreen*62.5)/2+31.25,0
			function settleTile()
				transition.to(letterTile_Gp[i], {time=50, x=letterTile_Gp[i].xO, transition=easing.inOutQuad})
			end

			transition.to(letterTile_Gp[i], {delay=(i-9)*15, time=200, x=letterTile_Gp[i].xO+10, transition=easing.inOutQuad, onComplete=settleTile})
		end
	end

	for i=1,totalTilesOnScreen do
		makeLetterTile(i)
	end

	setTileLocations()

	function organizeLetterPlace()	
		for i=1,letterTile_Gp.numChildren do
			letterTile_Gp[i].place=i
		end
	end
	
	function organizeTimerPlace()
		for i=1,#timerArray do
			timerArray[i][1]=i
		end	
	end	
			
	function submitWord()
		if  _G.WordGameDictionary:containsWord(currentWordString) and string.len(currentWordString)>2 and _G.isGameOver==false and isClear==false then			
				currentWordNum=currentWordNum+1
			if	currentWordNum>3 then
				currentWordNum=1
			end
			local tempLength=string.len(currentWordString)			
			
			currentScore=currentScore+totalWordScore+currentBonus
			if	#bestWordArray>0 then
				if	bestWordArray[1][1]<totalWordScore+currentBonus then
					bestWordArray[1]={totalWordScore+currentBonus, currentWordString}
				end
			else
				bestWordArray[#bestWordArray+1]={totalWordScore+currentBonus, currentWordString}
			end
			if	_G.highScore[1]>0 and currentScore>_G.highScore[1] and isHighScoreEvent==false then
				isHighScoreEvent=true
				-- highScore_Txt.text="NEW HIGH SCORE"
				newHighScore_Img_Top.anim=transition.to(newHighScore_Img_Top, {time=100, alpha=.1})
			end
			currentBonus=0
			wordScore_Txt.text=""
			wordScore_Txt_Shadow.text=""
			totalWordScore=0
			totalScore_Txt.text=currentScore .. " /"
			totalScoreShadow_Txt.text=currentScore .. " /"
			totalScoreShadowA_Txt.text=currentScore .. " /"
		
			function compare(a,b)
			  return a < b
			end
			table.sort(currentLetterArray, compare)

			function compare1(a,b)
			  return a[1] < b[1]
			end
			table.sort(timerArray, compare1)
		
			for i=#currentLetterArray, 1, -1 do
				for j=#timerArray, 1, -1 do
					if	timerArray[j][1]==currentLetterArray[i] then
						timer.cancel(timerArray[j][2])
						table.remove(timerArray, j)
					end
				end
			end

			for i=#currentLetterArray, 1, -1 do
				if	letterTile_Gp[currentLetterArray[i]].letter=="a" or letterTile_Gp[currentLetterArray[i]].letter=="e" or letterTile_Gp[currentLetterArray[i]].letter=="i" or letterTile_Gp[currentLetterArray[i]].letter=="o" or letterTile_Gp[currentLetterArray[i]].letter=="u" or letterTile_Gp[currentLetterArray[i]].letter=="y" then
					totalVowels=totalVowels-1
				else
					totalConsonants=totalConsonants-1
				end
				letterTile_Gp[currentLetterArray[i]]:removeSelf()
				table.remove(currentLetterArray, i)
			end
		
			organizeLetterPlace()
		
			organizeTimerPlace()
							
			currentWordString=""
			word_Gp.wordText_Txt.text=currentWordString
		
			for i=1,tempLength do
				makeLetterTile(letterTile_Gp.numChildren+1)
			end
		
			setTileLocations()
			
			switchMusic=switchMusic+1
			
			incMultiplier()
			
			manageWordCapsule(0)
						
			if switchMusic==3 then
				if	_G.currentLevel<10 then
					title_Text.text=_G.switchCurrentScale+2
					title_Text.x, title_Text.y=0,15
					title_Text:setFillColor(colorArray[_G.switchCurrentScale+1][1], colorArray[_G.switchCurrentScale+1][2], colorArray[_G.switchCurrentScale+1][3])
					title_Text.alpha=0
					title_Text.xScale, title_Text.yScale=4, 4

					function alphaTitle()
						title_Text.alpha=1
						title_Text.xScale, title_Text.yScale=4, 4
						transition.to(title_Text, {time=5000+1000, xScale=0.001, yScale=0.001, alpha=0, transition=easing.outExpo})
					end
				
					timer.performWithDelay(350, alphaTitle, 1)				
				else
					title_Text.text=_G.currentLevel
					title_Text.x, title_Text.y=0,15
					title_Text:setFillColor(colorArray[_G.switchCurrentScale+1][1], colorArray[_G.switchCurrentScale+1][2], colorArray[_G.switchCurrentScale+1][3])
					title_Text.alpha=0
					title_Text.xScale, title_Text.yScale=4, 4

					function alphaTitle()
						title_Text.alpha=1
						title_Text.xScale, title_Text.yScale=4, 4
						transition.to(title_Text, {time=_G.origDrumTime+1000, xScale=0.001, yScale=0.001, alpha=0, transition=easing.outExpo})
					end
				
					timer.performWithDelay(350, alphaTitle, 1)
					switchMusic=0
				end
			end
		else
			currentBonus=0
			isClear=false
			 if	#currentLetterArray>0 then
				local tempStringLength=string.len(currentWordString)
				currentWordString=""
				word_Gp.wordText_Txt.text=currentWordString
				function compare(a,b)
				  return a < b
				end
				table.sort(currentLetterArray, compare)
		
				for i=#currentLetterArray, 1, -1 do
					letterTile_Gp[currentLetterArray[i]].isTapped=false
					letterTile_Gp[currentLetterArray[i]][5].alpha=0.0
					table.remove(currentLetterArray, i)
				end
				totalWordScore=0
				wordScore_Txt.text=""
				wordScore_Txt_Shadow.text=""
				if	totalWordScore==0 then
					wordScore_Txt.text=""
					wordScore_Txt_Shadow.text=""
				end
				manageWordCapsule(0)
			end
		end
	end
	
	function popSubmitButton(event)
		if	event.phase=="began" then
			if	string.len(currentWordString)>0 then
				function unpopButton()
					transition.to(checkButton_Img, {time=75, xScale=1, yScale=1, transition=easing.inOutBounce})
				end
				submitWord()
				transition.to(checkButton_Img, {time=75, xScale=.5, yScale=.5, transition=easing.inOutBounce, onComplete=unpopButton})
			end
		end
		return true
	end
		
	checkButton_Img=display.newImageRect("img/checkButton.png", 125, 75)
	checkButton_Img.x, checkButton_Img.y=0,115
	checkButton_Img.xO, checkButton_Img.yO=0,115
	checkButton_Img:addEventListener("touch", popSubmitButton)
	gameStage:insert(checkButton_Img)
			
	group:insert(gameStage)
	
	checkButton_Img.alpha=1.0
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