local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/PapaDusty/VapeV4ForRoblox/'..readfile('vapev4/profiles/commit.txt')..'/'..select(1, path:gsub('vapev4/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'vapev4', 'vapev4/games', 'vapev4/games/bedwars', 'vapev4/profiles', 'vapev4/assets', 'vapev4/libraries', 'vapev4/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/PapaDusty/VapeV4ForRoblox')
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('vapev4/profiles/commit.txt') and readfile('vapev4/profiles/commit.txt') or '') ~= commit then
		wipeFolder('vapev4')
		wipeFolder('vapev4/games')
		wipeFolder('vapev4/guis')
		wipeFolder('vapev4/libraries')
	end
	writefile('vapev4/profiles/commit.txt', commit)
end

return loadstring(downloadFile('vapev4/main.lua'), 'main')()
