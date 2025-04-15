-- KudoHub: Script chỉ theo dõi RemoteEvent/RemoteFunction và in ra console
-- Không ghi file, chỉ print ra các remote được gọi (trừ những cái trong blacklist)

local blacklist = {
    ["GetSpecificPlayerDat"] = true,
    ["ChangeState"] = true
}

if hookfunction and getrawmetatable then
    local function valToString(v)
        if typeof(v) == "string" then
            return string.format("%q", v)
        elseif typeof(v) == "Instance" then
            return 'game.' .. v:GetFullName()
        else
            return tostring(v)
        end
    end

    local function argsToString(args)
        local list = {}
        for i, v in ipairs(args) do
            table.insert(list, string.format("[%d] = %s", i, valToString(v)))
        end
        return "{ " .. table.concat(list, ", ") .. " }"
    end

    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if (method == "FireServer" or method == "InvokeServer") and not blacklist[self.Name] then
            print("[📡 Remote Call]", self:GetFullName(), ":" .. method)
            print("   Args:", argsToString(args))
        end
        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
else
    warn("⚠️ Không thể hook remote: thiếu quyền hoặc chức năng.")
end

print("[✅ KudoHub] Đang theo dõi remote và in ra console (không ghi file).")
