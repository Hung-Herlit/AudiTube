local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeleportTimerGUI"
gui.ResetOnSpawn = false

-- Main 
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 160)  
main.Position = UDim2.new(0.5, -140, 0.5, -80) 
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)


local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)  
title.BackgroundTransparency = 1
title.Text = "Restart Match Timer"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextStrokeTransparency = 0.8
title.TextYAlignment = Enum.TextYAlignment.Center


local timeLabel = Instance.new("TextLabel", main)
timeLabel.Position = UDim2.new(0.5, -50, 0, 60)  
timeLabel.Size = UDim2.new(0, 100, 0, 25) 
timeLabel.BackgroundTransparency = 1
timeLabel.Text = "Time: 3450s"
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 16  
timeLabel.TextStrokeTransparency = 0.8
timeLabel.TextYAlignment = Enum.TextYAlignment.Center


local sliderBG = Instance.new("Frame", main)
sliderBG.Position = UDim2.new(0.5, -110, 0, 90)  
sliderBG.Size = UDim2.new(0, 220, 0, 5)  
sliderBG.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
sliderBG.BorderSizePixel = 0
sliderBG.Name = "SliderBG"

Instance.new("UICorner", sliderBG).CornerRadius = UDim.new(0, 3)

local knob = Instance.new("Frame", sliderBG)
knob.Size = UDim2.new(0, 10, 0, 20)  
knob.Position = UDim2.new(0, 0, 0.5, -10)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.BorderSizePixel = 0
knob.Name = "Knob"

Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

local credit = Instance.new("TextLabel", main)
credit.Size = UDim2.new(1, -10, 0, 15)
credit.Position = UDim2.new(0, 5, 1, -15)  
credit.Text = "made by: vxq"
credit.Font = Enum.Font.Gotham
credit.TextColor3 = Color3.fromRGB(100, 100, 100)
credit.TextSize = 10  -- Reduced text size
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Right


local running = false
local selectedTime = 3450  -- change if you want

local function updateSliderPosition(timeLeft)
    local percentLeft = timeLeft / selectedTime
    local knobPos = (1 - percentLeft) * sliderBG.AbsoluteSize.X
    knob.Position = UDim2.new(0, knobPos - knob.AbsoluteSize.X / 2, knob.Position.Y.Scale, knob.Position.Y.Offset)
end


local function startCountdown()
    running = true


    sliderBG.Active = false
    knob.Active = false

    for i = selectedTime, 0, -1 do
        timeLabel.Text = "Time: " .. i .. "s"
        updateSliderPosition(i)  
        task.wait(1)
    end

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RestartMatch"):FireServer()


    timeLabel.Text = "Time: " .. selectedTime .. "s"
    sliderBG.Active = true
    knob.Active = true
    running = false
end

startCountdown()
