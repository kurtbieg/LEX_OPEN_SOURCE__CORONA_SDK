module(..., package.seeall)

local json = require "json";

local Utils = require("System.Utils");
local Log = require("Systems.Log");
local ComponentFactory = require("Systems.ComponentFactory");
local WordGameDictionary = require("Systems.WordGameSystem.WordGameDictionary");

function newWordComponent(self, name)
	name = name or "Word";
	local component = ComponentFactory:newComponent(name);
	
	component._word = nil;
	component._scrambledWord = nil;
	component._subwordsResult = nil;
	component._letterComponents = {};
	component._selectedLetterComponents = {};
	component.autosetLetters = true;
	
	function component:getSubwordsResult()
		return self._subwordsResult;
	end
	
	function component:getWord()
		return self._word;
	end
	
	function component:getScrambledWord()
		return self._scrambledWord;
	end
	
	function component:getWordValue()
		return WordGameDictionary:getWordValue(self._word);
	end
	
	function component:getSelectedWordValue()
		return WordGameDictionary:getWordValue(self:getSelectedWord());
	end
	
	function component:setWord(word)
		self:deselectAllLetterComponents();
		self._word = word;
		self._subwordsResult = WordGameDictionary:getSubwords(word);
		self:scramble();
	end
	
	function component:randomWord(minLetters, maxLetters)
		local word = WordGameDictionary:getRandomWord(minLetters, maxLetters);
		self:setWord(word);
	end
	
	function component:scramble()
		if (self._word == nil) then
			return;
		end

		--break string into char array
		local chars = {}

		for n = 1, #self._word do
			chars[n] = self._word:sub(n, n);
		end

		Utils:shuffle(chars);

		local shuffledWord = "";

		for n = 1, #self._word do
			shuffledWord = shuffledWord .. chars[n];
			--bubble.setLetter( bub, chars[n] - 64 )  -- turn 'A' into #1
		end
		
		self._scrambledWord = shuffledWord;
		
		if (self.autosetLetters == true) then
			for i = 1, #self._letterComponents, 1 do
				local letterComp = self._letterComponents[i];
				if (i <= #self._scrambledWord) then
					letterComp:setLetter(self._scrambledWord:sub(i, i));
					letterComp:getGameObject().isVisible = true;
				else
					letterComp:getGameObject().isVisible = false;
				end
			end
		end
	end
	
	function component:addLetterComponent(letterComp)
		letterComp._owner = self;
		self._letterComponents[#self._letterComponents+1] = letterComp;
		letterComp:addEventListener("selectLetter", self._onSelectLetter);
	end
	
	function component:getLetterComponentAt(index)
		return self._letterComponents[index];
	end
	
	function component:getNumLetterComponents()
		return #self._letterComponents;
	end
	
	function component:removeAllLetterComponents()
		self._letterComponents = {};
		self._selectedLetterComponents = {};
	end
	
	function component:deselectAllLetterComponents()
		while (#self._selectedLetterComponents > 0) do
			local letterComp = self._selectedLetterComponents[1];
			letterComp:select(false);
		end
	end
	
	function component:deselectLastLetterComponent()
		if (#self._selectedLetterComponents == 0) then
			return;
		end
		self._selectedLetterComponents[#self._selectedLetterComponents]:select(false);
	end
	
	function component:getSelectedLetterComponents()
		return self._selectedLetterComponents;
	end
	
	function component:getIndexOf(letterComp)
		for i = 1, #self._letterComponents, 1 do
			if (letterComp == self._letterComponents[i]) then
				return i;
			end
		end
		return -1;
	end
	
	function component:getSelectedIndexOf(letterComp)
		for i = 1, #self._selectedLetterComponents, 1 do
			if (letterComp == self._selectedLetterComponents[i]) then
				return i;
			end
		end
		return -1;
	end
	
	function component:getSelectedWord()
		local word = "";
		for i = 1, #self._selectedLetterComponents, 1 do
			local letterComp = self._selectedLetterComponents[i];
			word = word .. letterComp:getLetter();
		end
		return word;
	end
	
	function component:submit()
		local isValid = self._subwordsResult:containsWord(self:getSelectedWord());
		
		self:getGameObject():broadcastEvent({name="submit", isValid=isValid, selectedWord=self:getSelectedWord(), word=self:getWord()})
		
		return isValid;
	end
	
	function component._onSelectLetter(event)
		local letter = event.component;
		local self = event.self:getOwner();
		
		if (event.selected == true) then
			for i = 1, #self._selectedLetterComponents, 1 do
				local sel = self._selectedLetterComponents[i];
				
				if (sel == letter) then
					return;
				end
			end
			
			self._selectedLetterComponents[#self._selectedLetterComponents+1] = letter;
		else
			local newSelectedLetters = {};
			
			local found = false;
			for i = 1, #self._selectedLetterComponents, 1 do
				local sel = self._selectedLetterComponents[i];
				
				if (sel ~= letter) then
					newSelectedLetters[#newSelectedLetters+1] = sel;
				end
			end
			
			if (#newSelectedLetters == #self._selectedLetterComponents) then
				return;
			end
			
			self._selectedLetterComponents = newSelectedLetters;
			
			for i = 1, #self._selectedLetterComponents, 1 do
				local letterComp = self._selectedLetterComponents[i];
				letterComp:getGameObject():broadcastEvent({name="selectedIndexChange", index=i});
			end
		end
		
		letter:getOwner():getGameObject():broadcastEvent({name="selectLetter", selected=event.selected, component=event.component});
		
	end
	
	return component;
end
