module(..., package.seeall)

local Utils = require("Systems.Utils");

local _dictionary = {};
local _lang = "en";

local _numWords = 0;
local _letterValues = {};
local _onLoadComplete = nil;

function getLetterValue(self, letter)
	return _letterValues[letter:upper()] or 0;
end

function getWordValue(self, word)
	if (containsWord(self, word) == false) then
		return 0;
	end
	
	local value = 0;
	for i = 1, #word, 1 do
		value = value + getLetterValue(self, word:sub(i, i));
	end
	return value;
end

function count()
	return _numWords;
end

function load(self, lang, onLoadComplete)
	_onLoadComplete = onLoadComplete;
	_lang = lang or userDefinedLanguage or system.getPreference("ui", "language");
	
	-- default to en if not supported
	if (_lang ~= "en" and _lang ~= "fr" and _lang ~= "it" and _land ~= "es") then
		_lang = "en";
	end
	
	_loadLetters();
	_loadWords();
	
	
	if (_onLoadComplete ~= nil) then
		_onLoadComplete();
	end
end

function _loadLetters()
	local rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/letters.txt");
	for line in string.gmatch(rawText, "[^\n]+") do
		local letters = {};
		for token in string.gmatch(line, "[^,]+") do
			letters[#letters+1] = token;
		end
		_letterValues[letters[1]:upper()] = letters[2]; 
	end
end

function _loadWords()
	local rawText
	local numTokens
	
	function loadText()
		numTokens = 0;
		-- print (rawText)
		for token in string.gmatch(rawText, "[^\n]+") do
			-- print("token " .. token);
		--for token in string.gmatch(rawText, "[^,]+") do
			if (_dictionary[#token] == nil) then
				_dictionary[#token] = {count=0, words={}};
			end
		
			if (_dictionary[#token].words[token:upper()] ~= true) then
				_dictionary[#token].count = _dictionary[#token].count + 1;
			end
			
			_dictionary[#token].words[token:upper()] = true;
			_numWords = _numWords + 1;
		end
	end
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/a.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/b.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/c.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/d.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/e.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/f.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/g.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/h.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/i.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/j.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/k.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/l.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/m.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/n.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/o.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/p.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/q.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/r.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/s.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/t.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/u.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/v.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/w.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/x.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/y.txt");
	loadText()
	
	rawText = Utils:loadText("Systems/WordGameSystem/" .. _lang .. "/z.txt");
	loadText()
end

function containsWord(self, word)
	if (_dictionary[#word] == nil) then
		return false;
	end
	return _dictionary[#word].words[word:upper()] ~= nil;
end

function getSubwords(self, word, min, max)
	if (word == nil) then
		return {};
	end
	
	min = min or 0;
	if (min == 0) then
		max = max or 999;
	else
		max = max or min;
	end
	
	local result = {};
	result.wordsByLength = {};
	result.words = {};
	result.min = min;
	result.max = max;
	result._completedWords = {};
	
	function result:setCompletedWord(word)
		self._completedWords[word:upper()] = true;
	end
	
	function result:isWordCompleted(word)
		return self._completedWords[word:upper()] == true;
	end
	
	function result:getUncompletedWords()
		local words = {};
		for i = 1, #words, i do
			local word = self.words[i]
			if (sel:isWordCompleted(word) == false) then
				words[#words+1] = word;
			end
		end
		return words;
	end
	
	function result:getCompletedWords()
		return self._completedWords;
	end
	
	function result:containsWord(word) 
		return self.words[word] == true;
	end
	
	function result:getWords(min, max)
		min = min or 0;
		if (min == 0) then
			max = max or 999;
		else
			max = max or min;
		end
		
		local words = {};
		for i = math.max(min, self.min), math.min(max, self.max), 1 do
			local wordsByLength = self.wordsByLength[i];
			for j = 1, #wordsByLength, 1 do
				words[#words+1] = wordsByLength[j];
			end
		end
		return words;
	end
	
	for i = min, max, 1 do
		result.wordsByLength[i] = {};
	end
	
	local letters = {};
	for i = 1, #word, 1 do
		letters[#letters+1] = word:sub(i, i);
	end

	local usedIndices = {};
	
	_recursiveFindAllWords(result, letters, usedIndices, "", min, max)
	
	return result;
end

function _recursiveFindAllWords(result, letters, usedIndices, word, min, max)
	local numLetters;
	for i = 1, #letters, 1 do
		if (usedIndices[i] ~= true) then
			usedIndices[i] = true;
			 
			if (containsWord(nil, word .. letters[i])) then
				numLetters = #word+1;
				local realWord = word .. letters[i];
				if (numLetters >= min and numLetters <= max and result.words[realWord:upper()] ~= true) then
					result.wordsByLength[numLetters][#result.wordsByLength[numLetters]+1] = realWord:upper();
					result.words[realWord:upper()] = true;
				end
			end
			
			_recursiveFindAllWords(result, letters, usedIndices, word .. letters[i], min, max);
			
			usedIndices[i] = false;
		end
	end
end


function getRandomWord(self, min, max)
	max = max or min;
	
	local numLetters = min + math.round(math.random() * (max-min));
	
	if (_dictionary[numLetters] == nil) then
		return "";
	end
	
	local index = math.floor(math.random() * _dictionary[numLetters].count);
	
	local lookup = _dictionary[numLetters].words;
	
	for key,value in pairs(lookup) do
		index = index - 1;
		
		if (index == 0) then
			return key;
		end
	end
	return nil;
end