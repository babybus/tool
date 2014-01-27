module(...,package.seeall)

function str2obj()
    local data = io.open("data.ini",'r')
    assert(data)
    local tmp_data = io.open("tmp_data.lua",'w+')
    local content = data:read("*a")

    tmp_data:write("module(...,package.seeall)\ndata=\n")
    tmp_data:write(content)

    tmp_data:close()
end

str2obj()

local pro_data = require("tmp_data").data

if not pro_data then
    assert(nil)
end

pro_name = pro_data.name
app_list = {}
for _,mod in pairs(pro_data.children) do
    app_list[mod.name] = mod
end



