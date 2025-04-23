local player_kudo = game:GetService("Players").LocalPlayer
local replicatedStorage_kudo = game:GetService("ReplicatedStorage")
local gui_kudo = Instance.new("ScreenGui", player_kudo:WaitForChild("PlayerGui"))
gui_kudo.Name = "WaveToggleGUI_kudo"
gui_kudo.ResetOnSpawn = false

-- Toggle Button UI
local toggle_kudo = Instance.new("TextButton")
toggle_kudo.Size = UDim2.new(0, 160, 0, 40)
toggle_kudo.Position = UDim2.new(0, 10, 0, 10)
toggle_kudo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggle_kudo.TextColor3 = Color3.new(1, 1, 1)
toggle_kudo.Text = "▶️ Start Monitoring"
toggle_kudo.Font = Enum.Font.GothamBold
toggle_kudo.TextSize = 14
toggle_kudo.Parent = gui_kudo

local toggle_corner_kudo = Instance.new("UICorner", toggle_kudo)
toggle_corner_kudo.CornerRadius = UDim.new(0, 8)

-- State variables
local monitoring_kudo = false
local lastWave_kudo = nil
local wave99Count_kudo = 0
local monitorThread_kudo = nil

-- Monitoring logic
local function startMonitoring_kudo()
    print("[✅] Wave monitoring started.")
    monitoring_kudo = true
    toggle_kudo.Text = "⏸️ Stop Monitoring"

    monitorThread_kudo = task.spawn(function()
        while monitoring_kudo do
            task.wait(2)

            local waveLabel_kudo
            pcall(function()
                waveLabel_kudo = player_kudo.PlayerGui:FindFirstChild("MainUI", true)
                    and player_kudo.PlayerGui.MainUI:FindFirstChild("Top", true)
                    and player_kudo.PlayerGui.MainUI.Top:FindFirstChild("Wave", true)
                    and player_kudo.PlayerGui.MainUI.Top.Wave:FindFirstChild("Value", true)
            end)

            if waveLabel_kudo and waveLabel_kudo:IsA("TextLabel") then
                local text_kudo = waveLabel_kudo.Text
                local waveNum_kudo = tonumber(text_kudo)

                if waveNum_kudo then
                    if waveNum_kudo ~= lastWave_kudo then
                        lastWave_kudo = waveNum_kudo
                        print("[🔁] New Wave:", waveNum_kudo)

                        if waveNum_kudo == 99 then
                            print("[⚔️] Wave 99 reached! Sending Ability remote...")
                            local args_kudo = {
                                [1] = workspace:WaitForChild("Towers"):WaitForChild("GojoEvo2EZA"),
                                [2] = 2
                            }
                            replicatedStorage_kudo:WaitForChild("Remotes"):WaitForChild("Ability"):InvokeServer(unpack(args_kudo))
                        elseif waveNum_kudo == 100 then
                            print("[🔥] Wave 100 reached! Sending SellAll remote...")
                            replicatedStorage_kudo:WaitForChild("Remotes"):WaitForChild("UnitManager"):WaitForChild("SellAll"):FireServer()

                            wave99Count_kudo += 1
                            print("[📊] Wave 100 count:", wave99Count_kudo)

                            if wave99Count_kudo >= 4 then
                                print("[⏳] 4x Wave 99 reached. Waiting 30 seconds to RestartMatch...")
                                task.delay(60, function()
                                    print("[🔁] Sending RestartMatch remote.")
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RestartMatch"):FireServer()
                                end)
                            end
                        end
                    end
                else
                    print("[❌] Cannot convert to number:", text_kudo)
                end
            else
                print("[⏳] waveLabel_kudo not found.")
            end
        end
    end)
end

local function stopMonitoring_kudo()
    print("[🛑] Wave monitoring stopped.")
    monitoring_kudo = false
    toggle_kudo.Text = "▶️ Start Monitoring"
end

-- Toggle behavior
toggle_kudo.MouseButton1Click:Connect(function()
    if monitoring_kudo then
        stopMonitoring_kudo()
    else
        startMonitoring_kudo()
    end
end)

-- Start monitoring by default
startMonitoring_kudo()
