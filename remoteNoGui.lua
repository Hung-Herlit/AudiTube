-- KudoHub: Script kết hợp theo dõi biến và remote, có blacklist remote

-- Tạo thư mục nếu chưa có
if not isfolder("KudoHub") then makefolder("KudoHub") end
if not isfolder("KudoHub/RemoteLogs") then makefolder("KudoHub/RemoteLogs") end

----------------------------------------
-- 📌 1. Theo dõi mọi biến Value thay đổi
----------------------------------------
local player = game.Players.LocalPlayer

if hookfunction and getrawmetatable and writefile and isfile and makefolder and isfolder then
    local blacklist = {
        ["GetSpecificPlayerDat"] = true,
        ["ChangeState"] = true
    }

    local function valToString(v)
        if typeof(v) == "string" then
            return string.format("%q", v)
        elseif typeof(v) == "Instance" then
            return 'game.' .. v:GetFullName()
        else
            return tostring(v)
        end
    end

    local function argsToScript(remote, args)
        local lines = { "local args = {" }
        for i, v in ipairs(args) do
            table.insert(lines, string.format("    [%d] = %s,", i, valToString(v)))
        end
        table.insert(lines, "}")
        table.insert(lines, remote .. "(unpack(args))")
        return table.concat(lines, "\n")
    end

    local function saveRemoteToFile(name, args, script)
        local function sanitize(str)
            return tostring(str):gsub("[^%w]", "_"):sub(1, 20)
        end
        local parts = { sanitize(name) }
        for _, v in ipairs(args) do table.insert(parts, sanitize(v)) end
        local base = table.concat(parts, "_")
        local i = 1
        local file = "KudoHub/RemoteLogs/" .. base .. "_" .. i .. ".lua"
        while isfile(file) do
            i += 1
            file = "KudoHub/RemoteLogs/" .. base .. "_" .. i .. ".lua"
        end
        writefile(file, script)
    end

    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if (method == "FireServer" or method == "InvokeServer") and not blacklist[self.Name] then
            local remoteStr = 'game.' .. self:GetFullName() .. ':' .. method
            local script = argsToScript(remoteStr, args)
            saveRemoteToFile(self.Name, args, script)
        end
        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
else
    warn("⚠️ Không thể hook remote: thiếu quyền hoặc chức năng.")
end

----------------------------------------
print("[✅ KudoHub] Theo dõi biến + remote call (đã có blacklist) đã kích hoạt!")
