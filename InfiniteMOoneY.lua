function setreadyonly(tbl,bool)
 return setreadonly(tbl,bool)
end

local mt = getrawmetatable(game);
local old = mt.__namecall
setreadyonly(mt,false)

mt.__namecall = newcclosure(function(remote,...)
    args = {...}
    method = tostring(getnamecallmethod())
    if method == "FireServer" and tostring(remote) == "Event" and tonumber(args[1]) then 
        args[1] = -10000000
        return old(remote,unpack(args))
    end
    return old(remote,...)
end)
setreadyonly(mt,true)
