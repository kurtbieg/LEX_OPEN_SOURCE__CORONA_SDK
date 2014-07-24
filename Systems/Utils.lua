module(..., package.seeall)

local json = require "json";

function loadText(self, fileName, base)
	if not base then
		base = system.ResourceDirectory
	end
		
	local path = system.pathForFile( fileName, base )
	local hFile, err = io.open(path,"r");
	
	
	if hFile and not err then
		local text=hFile:read("*a"); -- read file content
		io.close(hFile);
		return text;
	else
		print( err )
		return nil
	end
end

function loadJson(self, fileName)
	local raw = loadText(self, fileName);
	return json.decode(raw);
end

function shuffle(self, array)
	local rand = math.random 
    local iterations = #array;
    local j;

    for i = iterations, 2, -1 do
        j = rand(i)
        array[i], array[j] = array[j], array[i]
    end
end