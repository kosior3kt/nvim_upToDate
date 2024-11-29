local number_of_files = 0

local function scandir(directory)
    local t, popen = {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        number_of_files = number_of_files + 1
        t[number_of_files] = filename
    end
    pfile:close()
    return t
end

local array_of_files = scandir("./local");

vim.print(array_of_files[1])

-- TODO: take care of this later on

-- for i = 1, number_of_files do
-- 	if array_of_files ~= nil then
-- 		require(array_of_files[i])
-- 	end
-- end

