--[[
    Auto Pet Battler System
    ------------------------
    Click any wild monster to start an auto battle chain.
    Your pet will fight that monster, then automatically
    move on to fight all remaining monsters until none are left.

    Requirements:
    - A model named "Pet" in workspace.
    - A folder named "WildMons" in workspace.
    - Each wild monster should:
        - Be a Model with a Humanoid.
        - Have a ClickDetector (or it will be added automatically).

    Author: [Your Name]
    Created: [YYYY-MM-DD]
]]

local ATTACK_DAMAGE = 10
local ATTACK_INTERVAL = 1

local pet = workspace:WaitForChild("Pet")
local wildMonstersFolder = workspace:WaitForChild("WildMons")

local battling = false

-- Get list of alive monsters
local function getAliveMonsters()
	local alive = {}
	for _, mon in ipairs(wildMonstersFolder:GetChildren()) do
		local hum = mon:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health > 0 then
			table.insert(alive, mon)
		end
	end
	return alive
end

-- Fight one monster
local function battle(mon)
	local humanoid = mon:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	print("⚔️ Pet starts battling " .. mon.Name)

	while humanoid and humanoid.Health > 0 do
		humanoid:TakeDamage(ATTACK_DAMAGE)
		print("👉 Pet hits " .. mon.Name .. " for " .. ATTACK_DAMAGE .. " damage. HP left: " .. math.max(humanoid.Health, 0))
		wait(ATTACK_INTERVAL)
	end

	print("✅ " .. mon.Name .. " defeated!")
end

-- Battle loop through all monsters
local function startAutoBattle()
	battling = true

	while true do
		local monsters = getAliveMonsters()
		if #monsters == 0 then
			print("🎉 All monsters defeated!")
			battling = false
			break
		end

		local target = monsters[math.random(1, #monsters)]
		battle(target)
		wait(1)
	end
end

-- Add click detection to a monster
local function setupClick(monster)
	local click = monster:FindFirstChildOfClass("ClickDetector")
	if not click then
		click = Instance.new("ClickDetector", monster)
	end

	click.MouseClick:Connect(function(player)
		if not battling then
			startAutoBattle()
		else
			print("⛔ Already battling.")
		end
	end)
end

-- Setup all existing monsters
for _, monster in ipairs(wildMonstersFolder:GetChildren()) do
	setupClick(monster)
end

-- Setup new monsters added later
wildMonstersFolder.ChildAdded:Connect(setupClick)
