-- Create screen GUI
local player = game.Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoBattleToggleGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create the toggle button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "Auto Battle: ON"
button.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = screenGui

-- RemoteEvent to communicate with server
local remote = Instance.new("RemoteEvent", game.ReplicatedStorage)
remote.Name = "AutoBattleToggle"

local isEnabled = true

button.MouseButton1Click:Connect(function()
	isEnabled = not isEnabled
	button.Text = "Auto Battle: " .. (isEnabled and "ON" or "OFF")
	button.BackgroundColor3 = isEnabled and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)

	-- Tell server to update battle state
	remote:FireServer(isEnabled)
end)
