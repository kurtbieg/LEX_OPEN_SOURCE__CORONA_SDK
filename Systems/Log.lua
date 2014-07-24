module(..., package.seeall)

local json = require "json";

local _logs = {};
_logs["TRACE"] = {suppress=false, messages={}, indent=0};
_logs["WARNING"] = {suppress=false, messages={}, indent=0};
_logs["ERROR"] = {suppress=false, messages={}, indent=0};

local _messages = {};

local _suppressAll = false;
local _defaultEmail = nil;

function setDefaultEmail(self, email)
	_defaultEmail = email;
end

function setIndent(self, indent, type)
	type = type or "TRACE";

	if (_logs[type:upper()] == nil) then
		return;
	end
	
	_logs[type:upper()].indent = indent;
end

function suppressAll(self, suppress)
	_suppressAll = suppress;
end

function suppressTraces(self, value, type)
	type = type or "TRACE";

	if (_logs[type:upper()] == nil) then
		return;
	end
	
	_logs[type:upper()].suppress = value;
end

function suppressWarnings(self, value)
	suppressTraces(self, value, "WARNING");
end

function suppressErrors(self, value)
	suppressTraces(self, value, "ERROR");
end

function trace(self, message, type)
	type = type or "TRACE";
	
	if (_logs[type:upper()] == nil) then
		_logs[type:upper()] = {suppress=false, messages={}, indent=0};
	end
	
	local log = _logs[type:upper()];
	
	for i = 1, log.indent, 1 do
		message = "   " .. message;
	end
		
	local messages = log.messages;
	messages[#messages+1] = message;
	
	_messages[#_messages+1] = message;
	
	if (_suppressAll == false and log.suppress == false) then
		print(message);
	end
end

function warning(self, message)
	trace(self, "* WARNING: " .. message .. " *", "WARNING");
end

function error(self, message)
	trace(self, "*** ERROR: " .. message .. " ***", "ERROR");
end

function printAll()
	for i = 1, #_messages, 1 do
		print (_messages[i]);
	end
end

function printTraces(self, type)
	type = type or "TRACE";
	local log = _logs[type:upper()];
	local messages = log.messages;
	messages[#messages+1] = message;
	
	for i = 1, #messages, 1 do
		print (messages[i]);
	end
end

function printWarnings(self)
	printTraces(self, "WARNING");
end

function printErrors(self)
	printTraces(self, "ERROR");
end

function getAllMessages()
	return _messages;
end

function createJson(self)
	return json.encode(_logs);
end

function mailTo(self, email)
	email = email or _defaultEmail;
	if (email == nil) then
		return;
	end
	
	system.openURL( "mailto:" .. email .. "?subject=CoronaLog&body=" .. createJson() );
end