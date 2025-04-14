-- KudoHub: Script kết hợp 3 chức năng theo dõi giá trị, nút nhấn, và remote call

-- Tạo thư mục nếu chưa có
if not isfolder("KudoHub") then makefolder("KudoHub") end
if not isfolder("KudoHub/RemoteLogs") then makefolder("KudoHub/RemoteLogs") end

----------------------------------------
-- 📌 1. Theo dõi mọi biến Value thay đổi
----------------------------------------
local player = game.Players.LocalPlayer
local valueLogFile = "KudoHub/ValueChangesLog.txt"
if not isfile(valueLogFile) then writefile(valueLogFile, "") end

local valueTypes = {
    "BoolValue", "IntValue", "StringValue", "NumberValue", "ObjectValue", "Vector3Value", "CFrameValue"
}

local function isValueObject(obj)
    for _, t in ipairs(valueTypes) do
        if obj:IsA(t) then return true end
    end
    return false
end

local function appendValueLog(text)
    if appendfile then
        appendfile(valueLogFile, text .. "\n")
    else
        local current = readfile(valueLogFile)
        writefile(valueLogFile, current .. text .. "\n")
    end
end

local function watchValue(obj)
    if isValueObject(obj) then
        local path = obj:GetFullName()
        appendValueLog("[Theo dõi] " .. path .. " = " .. tostring(obj.Value))
        obj.Changed:Connect(function()
            local line = "[Thay đổi] " .. path .. " => " .. tostring(obj.Value)
            print(line)
            appendValueLog(line)
        end)
    end
end

for _, v in ipairs(player:GetDescendants()) do watchValue(v) end
player.DescendantAdded:Connect(watchValue)

----------------------------------------
-- 📌 2. Theo dõi các nút nhấn trong GUI
----------------------------------------
local playerGui = player:WaitForChild("PlayerGui")
local buttonLogFile = "KudoHub/ClickableButtonsLog.txt"
if not isfile(buttonLogFile) then writefile(buttonLogFile, "") end

local function logButton(button)
    local line = "[Nút mới] " .. button:GetFullName()
    print(line)
    if appendfile then
        appendfile(buttonLogFile, line .. "\n")
    else
        local content = readfile(buttonLogFile)
        writefile(buttonLogFile, content .. line .. "\n")
    end
end

local clickableTypes = { "TextButton", "ImageButton" }

local function isClickableButton(obj)
    for _, t in ipairs(clickableTypes) do
        if obj:IsA(t) and obj.Visible and obj.Active then return true end
    end
    return false
end

local function watchProperties(btn)
    if btn:IsA("GuiButton") then
        local function check()
            if isClickableButton(btn) then logButton(btn) end
        end
        btn:GetPropertyChangedSignal("Visible"):Connect(check)
        btn:GetPropertyChangedSignal("Active"):Connect(check)
        check()
    end
end

for _, obj in ipairs(playerGui:GetDescendants()) do
    if obj:IsA("GuiButton") then watchProperties(obj) end
end

playerGui.DescendantAdded:Connect(function(obj)
    if obj:IsA("GuiButton") then watchProperties(obj) end
end)

----------------------------------------
-- 📌 3. Theo dõi Remote Call và log lại
----------------------------------------
if hookfunction and getrawmetatable and writefile and isfile and makefolder and isfolder then
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
        if method == "FireServer" or method == "InvokeServer" then
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
print("[✅ KudoHub] Theo dõi biến | nút nhấn | remote đã kích hoạt!")
