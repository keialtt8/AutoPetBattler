--[[
    Auto Pet Battler System
    ------------------------
    Click any wild monster (Snowpebble, Blizzrock, or Mechshell) to start auto battling.
    Your pet will fight the clicked monster, then continue until all are defeated.

    Requirements:
    - A model named "Pet" in workspace.
    - A folder named "WildMons" in workspace.
    - Each wild monster must:
        - Be a Model with a Humanoid.
        - Have a ClickDetector (or one will be added).

    Author: Your Name
    Date: 2025-07-29
]]

local ALLOWED_MONSTERS = {
    Snowpebble = true,
    Blizzrock = true,
    Mechshell = true
}

local ATTACK_DAMAGE = 10
local ATTACK_INTERVAL = 1

local pet = workspace:WaitForChild("Pet")
local wildMonstersFolder = workspace:WaitForChild("WildMons")

local battling = false

-- Get list of alive, allowed monsters
local function getAliveMonsters()
    local alive = {}
    for _, mon in ipairs(wildMonstersFolder:GetChildren()) do
        local hum = mon:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and ALLOWED_MONSTERS[mon.Name] then
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

-- Battle loop through all valid monsters
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
    if not ALLOWED_MONSTERS[monster.Name] then return end

    local click = monster:FindFirstChildOfClass("ClickDetector")
    if not click then
        click = Instance.new("ClickDetector")
        click.Parent = monster
    end

    click.MouseClick:Connect(function(player)
        print("🖱️ Monster clicked: " .. monster.Name)
        if not battling then
            startAutoBattle()
        else
            print("⛔ Already battling.")
        end
    end)
end

-- Setup all existing valid monsters
for _, monster in ipairs(wildMonstersFolder:GetChildren()) do
    setupClick(monster)
end

-- Setup new monsters added later (if they match allowed list)
wildMonstersFolder.ChildAdded:Connect(function(mon)
    setupClick(mon)
end)
