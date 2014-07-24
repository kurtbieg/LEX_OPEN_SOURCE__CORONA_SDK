module(..., package.seeall)

local json = require "json";

local Log = require("Systems.Log");
local ComponentFactory = require("Systems.ComponentFactory");
local WordGameDictionary = require("Systems.WordGameSystem.WordGameDictionary");

function newLetterTileComponent(self)
	local component = ComponentFactory:newComponent("Tile");
	
	component._bgGroup = display.newGroup();
	component:insert(component._bgGroup);
	
	component._textGroup = display.newGroup();
	component:insert(component._textGroup);
	
	component._valueGroup = display.newGroup();
	component:insert(component._valueGroup);
	
	function component:showValue(show)
		self._showValue = show;
		self._valueGroup.isVisible = show;
	end
	
	function component:setBackground(background)
		while (#self._bgGroup > 0) do
			self._bgGroup:remove(1);
		end
		self._bgGroup:insert(background);
		self._bg = background;
	end
	
	function component:setLetterTextField(textField)
		while (#self._textGroup > 0) do
			self._textGroup:remove(1);
		end
		self._textGroup:insert(textField);
		self._text = textField;
	end
	
	function component:setValueTextField(textField)
		while (#self._valueGroup > 0) do
			self._valueGroup:remove(1);
		end
		self._valueGroup:insert(textField);
		self._value = textField;
	end
	
	function component._onSetLetter(event)
		event.self._text.text = event.letter;
		if (event.self._value ~= nil) then
			event.self._value.text = WordGameDictionary:getLetterValue(event.letter);
		end
	end
	
	component:setBackground(display.newRoundedRect( 0, 0, 60, 60, 5 ));
	local text = display.newText( "", 0, 0, native.systemFont, 25 );
	text:setFillColor(1, 0, 0);
	component:setLetterTextField(text);
	
	text = display.newText( "", 18, 18, native.systemFont, 12 );
	text:setFillColor(1, 0, 0);
	component:setValueTextField(text);
	
	component:addEventListener("setLetter", component._onSetLetter);
	
	return component;
end
