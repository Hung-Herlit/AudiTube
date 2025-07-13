local player = game.Players.LocalPlayer
local gui_kudo = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui_kudo.Name = "KudoAbilityHub"
gui_kudo.ResetOnSpawn = false

-- Main Frame
local main_kudo = Instance.new("Frame", gui_kudo)
main_kudo.Size = UDim2.new(0, 250, 0, 150)
main_kudo.Position = UDim2.new(0.5, -125, 0.5, -75)
main_kudo.AnchorPoint = Vector2.new(0.5, 0.5)
main_kudo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main_kudo.BorderSizePixel = 0
main_kudo.Active = true
main_kudo.Draggable = true
Instance.new("UICorner", main_kudo).CornerRadius = UDim.new(0, 8)

-- Name TextBox
local name_kudo = Instance.new("TextBox", main_kudo)
name_kudo.PlaceholderText = "Tower Name"
name_kudo.Size = UDim2.new(1, -20, 0, 30)
name_kudo.Position = UDim2.new(0, 10, 0, 10)
name_kudo.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
name_kudo.TextColor3 = Color3.fromRGB(255, 255, 255)
name_kudo.Text = ""
name_kudo.ClearTextOnFocus = false
Instance.new("UICorner", name_kudo).CornerRadius = UDim.new(0, 6)

-- Skill TextBox
local skill_kudo = Instance.new("TextBox", main_kudo)
skill_kudo.PlaceholderText = "Skill Name"
skill_kudo.Size = UDim2.new(1, -20, 0, 30)
skill_kudo.Position = UDim2.new(0, 10, 0, 50)
skill_kudo.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
skill_kudo.TextColor3 = Color3.fromRGB(255, 255, 255)
skill_kudo.Text = ""
skill_kudo.ClearTextOnFocus = false
Instance.new("UICorner", skill_kudo).CornerRadius = UDim.new(0, 6)

-- Toggle Button
local toggleButton_kudo = Instance.new("TextButton", main_kudo)
toggleButton_kudo.Size = UDim2.new(1, -20, 0, 30)
toggleButton_kudo.Position = UDim2.new(0, 10, 0, 100)
toggleButton_kudo.Text = "AUTO: OFF"
toggleButton_kudo.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
toggleButton_kudo.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton_kudo.Font = Enum.Font.Gotham
toggleButton_kudo.TextSize = 14
Instance.new("UICorner", toggleButton_kudo).CornerRadius = UDim.new(0, 6)

-- Toggle state
local autoEnabled_kudo = false

toggleButton_kudo.MouseButton1Click:Connect(function()
	autoEnabled_kudo = not autoEnabled_kudo
	toggleButton_kudo.Text = autoEnabled_kudo and "AUTO: ON" or "AUTO: OFF"
	toggleButton_kudo.BackgroundColor3 = autoEnabled_kudo and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(120, 40, 40)
end)

-- Debug: in ra mỗi lần Enemies có child mới
local enemiesFolder_kudo = workspace:FindFirstChild("Enemies")
if enemiesFolder_kudo then
	enemiesFolder_kudo.ChildAdded:Connect(function(newChild)
		if newChild and newChild:IsA("Instance") then
			print("[👾] New enemy detected:", newChild:GetFullName())
		end
	end)
end

-- Auto check + cast remote khi có Boss
task.spawn(function()
	while true do
		task.wait(1)
		if autoEnabled_kudo then
			local enemies = workspace:FindFirstChild("Enemies")
			local boss_kudo = enemies and enemies:FindFirstChild("Boss")

			if boss_kudo then
				local towerName = name_kudo.Text
				local skillName = skill_kudo.Text

				if towerName ~= "" and skillName ~= "" then
					local tower = workspace:FindFirstChild("Towers") and workspace.Towers:FindFirstChild(towerName)
					if tower then
						local args = {
							[1] = tower,
							[2] = skillName
						}
						game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Ability"):InvokeServer(unpack(args))
						warn("[🌀] Sent Ability remote:", towerName, skillName)
					else
						warn("[❌] Tower not found:", towerName)
					end
				end
			end
		end
	end
end)

print("✅ Kudo Ability Hub loaded.")
