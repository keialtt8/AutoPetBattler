-- GUI Toggle
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "AutoBattleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 150, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.Text = "Auto Battle: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 0

-- Core Auto Battle
local ATTACK_DAMAGE = 10
local ATTACK_INTERVAL = 1

local pet = workspace:WaitForChild("Pet")
local wildMonstersFolder = workspace:WaitForChild("WildMons")

local battling = false

local function getAliveMonsters()
	local alive = {}
	for _, mon in ipairs(wildMonstersFolder:GetChildren()) do
		local hum = mon:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health > 0 and (mon.Name == "Snowpebble" or mon.Name == "Blizzrock" or mon.Name == "Mechshell") then
			table.insert(alive, mon)
		end
	end
	return alive
end

local function battle(mon)
	local humanoid = mon:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	while humanoid.Health > 0 and battling do
		humanoid:TakeDamage(ATTACK_DAMAGE)
		wait(ATTACK_INTERVAL)
	end
end

local function startAutoBattle()
	while battling do
		local monsters = getAliveMonsters()
		if #monsters == 0 then
			battling = false
			ToggleButton.Text = "Auto Battle: OFF"
			break
		end
		local target = monsters[math.random(1, #monsters)]
		battle(target)
		wait(1)
	end
end

ToggleButton.MouseButton1Click:Connect(function()
	battling = not battling
	ToggleButton.Text = battling and "Auto Battle: ON" or "Auto Battle: OFF"
	if battling then
		coroutine.wrap(startAutoBattle)()
	end
end)
