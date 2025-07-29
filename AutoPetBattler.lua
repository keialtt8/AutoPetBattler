--[[
    Auto Pet Battler System with GUI Toggle
    ---------------------------------------
    Click any wild monster (Snowpebble, Blizzrock, or Mechshell) to start auto battling.
    GUI button allows you to enable or disable the feature.

    Requirements:
    - A model named "Pet" in workspace.
    - A folder named "WildMons" in workspace.
    - Each wild monster must:
        - Be a Model with a Humanoid.
        - Have a ClickDetector (or one will be added).
--]]

-- CONFIG
local ALLOWED_MONSTERS = {
    Snowpebble = true,
    Blizzrock = true,
    Mechshell = true
}

local ATTACK_DAMAGE = 10
local ATTACK_INTERVAL = 1

-- STATE
local battling = false
local enabled = true

-- OBJECTS
local pet = workspace:WaitForChild("Pet")
local wildMonstersFolder = workspace:WaitForChild("WildMons")
local player = game.Players.LocalPlayer or game:GetService("Players").LocalPlayer

-- GUI
local function createToggleGui()
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "AutoBattleGUI"

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleAutoBattle"
    toggleButton.Size = UDim2.new(0, 160, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 20
    toggleButton.Text = "AutoBattle: ON"
    toggleButton.Parent = screenGui

    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleButton.Text = "AutoBattle: " .. (enabled and "ON" or "OFF")
        toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(100, 20, 20)
    end)
end

-- MONSTER FUNCTIONS
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

local function battle(mon)
    local humanoid = mon:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    print("⚔️ Pet starts battling " .. mon.Name)

    while humanoid and humanoid.Health > 0 and enabled do
        humanoid:TakeDamage(ATTACK_DAMAGE)
        print("👉 Pet hits " .. mon.Name .. " for " .. ATTACK_DAMAGE .. " damage. HP left: " .. math.max(humanoid.Health, 0))
        task.wait(ATTACK_INTERVAL)
    end

    print("✅ " .. mon.Name .. " defeated!")
end

local function startAutoBattle()
    battling = true

    while enabled do
        local monsters = getAliveMonsters()
        if #monsters == 0 then
            print("🎉 All monsters defeated!")
            battling = false
            break
        end

        local target = monsters[math.random(1, #monsters)]
        battle(target)
        task.wait(1)
    end
end

local function setupClick(monster)
    if not ALLOWED_MONSTERS[monster.Name] then return end

    local click = monster:FindFirstChildOfClass("ClickDetector")
    if not click then
        click = Instance.new("ClickDetector")
        click.Parent = monster
    end

    click.MouseClick:Connect(function(player)
        print("🖱️ Monster clicked: " .. monster.Name)
        if enabled and not battling then
            startAutoBattle()
        elseif not enabled then
            print("⚠️ AutoBattle is disabled.")
        else
            print("⛔ Already battling.")
        end
    end)
end

-- SETUP
for _, monster in ipairs(wildMonstersFolder:GetChildren()) do
    setupClick(monster)
end

wildMonstersFolder.ChildAdded:Connect(setupClick)

createToggleGui()
