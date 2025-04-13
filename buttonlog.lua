-- Theo dõi nút có thể nhấn trong PlayerGui và ghi log khi xuất hiện
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local logFile = "ClickableButtonsLog.txt"

-- Khởi tạo log file nếu cần
if not isfile(logFile) then
    writefile(logFile, "")
end

-- Hàm ghi log
local function logButton(button)
    local line = "[Nút mới] " .. button:GetFullName()
    print(line)

    if appendfile then
        appendfile(logFile, line .. "\\n")
    else
        -- fallback nếu thiếu appendfile
        local content = readfile(logFile)
        writefile(logFile, content .. line .. "\\n")
    end
end

-- Kiểu nút cần theo dõi
local clickableTypes = {
    "TextButton",
    "ImageButton"
}

-- Kiểm tra có phải là nút có thể nhấn không
local function isClickableButton(obj)
    for _, t in ipairs(clickableTypes) do
        if obj:IsA(t) and obj.Visible and obj.Active then
            return true
        end
    end
    return false
end

-- Theo dõi khi thuộc tính thay đổi (visible/active trở thành true)
local function watchProperties(btn)
    if btn:IsA("GuiButton") then
        local function check()
            if isClickableButton(btn) then
                logButton(btn)
            end
        end

        btn:GetPropertyChangedSignal("Visible"):Connect(check)
        btn:GetPropertyChangedSignal("Active"):Connect(check)
        -- Lần đầu kiểm tra luôn
        check()
    end
end

-- Theo dõi tất cả nút đang có
for _, obj in ipairs(playerGui:GetDescendants()) do
    if obj:IsA("GuiButton") then
        watchProperties(obj)
    end
end

-- Theo dõi nút mới được thêm vào GUI
playerGui.DescendantAdded:Connect(function(obj)
    if obj:IsA("GuiButton") then
        watchProperties(obj)
    end
end)

print("[✅ Logger] Đang theo dõi các nút nhấn trong PlayerGui. Log lưu vào:", logFile)
