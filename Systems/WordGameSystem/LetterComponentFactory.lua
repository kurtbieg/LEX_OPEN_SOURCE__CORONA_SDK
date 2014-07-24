module(..., package.seeall)

local json = require "json";

local Log = require("Systems.Log");
local ComponentFactory = require("Systems.ComponentFactory");
local WordGameDictionary = require("Systems.WordGameSystem.WordGameDictionary");

function newLetterComponent(self, name)
	name = name or "Letter";
	local component = ComponentFactory:newComponent(name);
	
	component._owner = nil;
	component._letter = nil;
	component._selected = false;
	
	function component:getOwner()
		return self._owner;
	end
	
	function component:setLetter(letter)
		self._letter = letter;
		self:getGameObject():broadcastEvent({name="setLetter", component=self, letter=letter});
	end
	
	function component:getLetter()
		return self._letter;
	end
	
	function component:select(value)
		if (self:isSelected() == value) then
			return;
		end
		self._selected = value;
		self:getGameObject():broadcastEvent({name="selectLetter", component=self, selected=value});
	end
	
	function component:isSelected()
		return self._selected;
	end
	
	function component:getSelectedIndex()
		return self._owner:getSelectedIndexOf(self);
	end
	
	function component:getIndex()
		return self._owner:getIndexOf(self);
	end
	
	return component;
end
