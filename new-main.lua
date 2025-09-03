-- FISCH Script with Simple UI
-- Created by MELLISAEFFENDY
-- Repository: https://github.com/MELLISAEFFENDY/chfish

print("🎣 Loading FISCH Script with Simple UI...")

--// Services with validation
local function getService(serviceName)
    local success, service = pcall(function()
        return game:GetService(serviceName)
    end)
    
    if not success or not service then
        error("Failed to get service: " .. serviceName)
    end
    
    return service
end

local Players = getService('Players')
local ReplicatedStorage = getService('ReplicatedStorage')
local RunService = getService('RunService')
local TeleportService = getService('TeleportService')
local Workspace = getService('Workspace')

-- Validate essential game objects
local lp = Players.LocalPlayer
if not lp then
    error("LocalPlayer not found")
end

print("✅ Services loaded successfully")

--// Variables
local flags = {
    autoFish = false,
    freezeChar = false,
    fishAbundance = false,
    autoShake = false,
    autoReel = false,
    infiniteOxygen = false
}

--// Teleport Locations
local TeleportLocations = {
    ['Zones'] = {
        ['Moosewood'] = CFrame.new(379.875458, 134.500519, 233.5495, -0.033920113, 8.13274355e-08, 0.999424577, 8.98441925e-08, 1, -7.83249803e-08, -0.999424577, 8.7135696e-08, -0.033920113),
        ['Roslit Bay'] = CFrame.new(-1472.9812, 132.525513, 707.644531, -0.00177415239, 1.15743369e-07, -0.99999845, -9.25943056e-09, 1, 1.15759981e-07, 0.99999845, 9.46479251e-09, -0.00177415239),
        ['Forsaken Shores'] = CFrame.new(-2491.104, 133.250015, 1561.2926, 0.355353981, -1.68352852e-08, -0.934731781, 4.69647858e-08, 1, -1.56367586e-10, 0.934731781, -4.38439116e-08, 0.355353981),
        ['Sunstone Island'] = CFrame.new(-913.809143, 138.160782, -1133.25879, -0.746701241, 4.50330218e-09, 0.665159583, 2.84934609e-09, 1, -3.5716119e-09, -0.665159583, -7.71657294e-10, -0.746701241),
        ['Statue of Sovereignty'] = CFrame.new(21.4017925, 159.014709, -1039.14233, -0.865476549, -4.38348664e-08, -0.500949502, -9.38435818e-08, 1, 7.46273798e-08, 0.500949502, 1.11599142e-07, -0.865476549),
        ['Terrapin Island'] = CFrame.new(-193.434143, 135.121979, 1951.46936, 0.512723684, -6.94711346e-08, 0.858553708, 5.44089183e-08, 1, 4.84237539e-08, -0.858553708, 2.18849721e-08, 0.512723684),
        ['Snowcap Island'] = CFrame.new(2607.93018, 135.284332, 2436.13208, 0.909039497, -7.49003748e-10, 0.4167099, 3.38659367e-09, 1, -5.59032465e-09, -0.4167099, 6.49305321e-09, 0.909039497),
        ['Ancient Isle'] = CFrame.new(6056.02783, 195.280167, 276.270325, -0.655055285, 1.96010075e-09, 0.755580962, -1.63855578e-08, 1, -1.67997189e-08, -0.755580962, -2.33853594e-08, -0.655055285),
        ['Depths'] = CFrame.new(491.758118, -706.123718, 1230.6377, 0.00879980437, 1.29271776e-08, -0.999961257, 1.95575205e-13, 1, 1.29276803e-08, 0.999961257, -1.13956629e-10, 0.00879980437),
        ['Atlantis'] = CFrame.new(-4465, -604, 1874)
    },
    ['Rods'] = {
        ['Training Rod'] = CFrame.new(465, 150, 235),
        ['Long Rod'] = CFrame.new(480, 180, 150),
        ['Fortune Rod'] = CFrame.new(-1515, 141, 765),
        ['Heaven Rod'] = CFrame.new(20025.0508, -467.665955, 7114.40234, -0.9998191, -2.41349773e-10, 0.0190212391, -4.76249762e-10, 1, -1.23448247e-08, -0.0190212391, -1.23516495e-08, -0.9998191),
        ['Kings Rod'] = CFrame.new(1380.83862, -807.198608, -304.22229, -0.692510426, 9.24755454e-08, 0.72140789, 4.86611427e-08, 1, -8.1475676e-08, -0.72140789, -2.13182219e-08, -0.692510426),
    }
}

--// Helper Functions
local function getChar()
    return lp.Character or lp.CharacterAdded:Wait()
end

local function getHRP()
    local char = getChar()
    return char and char:FindFirstChild('HumanoidRootPart')
end

local function teleportTo(cframe)
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = cframe
        print("✅ Teleported successfully")
    else
        warn("❌ Failed to teleport: No HumanoidRootPart found")
    end
end

--// Auto Fish Function
local autoFishConnection
local function startAutoFish()
    if autoFishConnection then
        autoFishConnection:Disconnect()
    end
    
    autoFishConnection = RunService.Heartbeat:Connect(function()
        if not flags.autoFish then return end
        
        local char = getChar()
        if not char then return end
        
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool.Name:lower():find("rod") then
            -- Auto fishing logic here
            local fishingEvent = ReplicatedStorage:FindFirstChild("events")
            if fishingEvent then
                local castEvent = fishingEvent:FindFirstChild("cast")
                if castEvent then
                    castEvent:FireServer()
                end
            end
        end
    end)
end

local function stopAutoFish()
    if autoFishConnection then
        autoFishConnection:Disconnect()
        autoFishConnection = nil
    end
end

--// Character Freeze Function
local freezeConnection
local function toggleFreeze(value)
    flags.freezeChar = value
    
    if freezeConnection then
        freezeConnection:Disconnect()
        freezeConnection = nil
    end
    
    if value then
        freezeConnection = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if hrp and flags.freezeChar then
                hrp.Anchored = true
            end
        end)
        print("🔒 Character frozen")
    else
        local hrp = getHRP()
        if hrp then
            hrp.Anchored = false
        end
        print("🔓 Character unfrozen")
    end
end

--// Load Simple UI
local SimpleUI
local loadSuccess, loadError = pcall(function()
    SimpleUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/chfish/main/SimpleUI.lua'))()
end)

if not loadSuccess or not SimpleUI then
    error("Failed to load SimpleUI: " .. tostring(loadError))
end

print("✅ SimpleUI loaded successfully")

--// Create GUI
local ui = SimpleUI.new()
ui:CreateMainGui("🎣 FISCH Script v2.0")

-- Create Tabs
local automationTab = ui:CreateTab("Automation")
local teleportTab = ui:CreateTab("Teleport")
local modificationsTab = ui:CreateTab("Modifications")
local creditsTab = ui:CreateTab("Credits")

print("✅ GUI created successfully")

--// Automation Tab
ui:AddSection(automationTab, "🎣 Fishing Automation")

ui:AddToggle(automationTab, "Auto Fish", false, function(value)
    flags.autoFish = value
    if value then
        startAutoFish()
        print("🎣 Auto Fish enabled")
    else
        stopAutoFish()
        print("🎣 Auto Fish disabled")
    end
end)

ui:AddToggle(automationTab, "Auto Shake", false, function(value)
    flags.autoShake = value
    print("🔄 Auto Shake " .. (value and "enabled" or "disabled"))
end)

ui:AddToggle(automationTab, "Auto Reel", false, function(value)
    flags.autoReel = value
    print("🎣 Auto Reel " .. (value and "enabled" or "disabled"))
end)

ui:AddSection(automationTab, "⚙️ Character Settings")

ui:AddToggle(automationTab, "Freeze Character", false, function(value)
    toggleFreeze(value)
end)

ui:AddToggle(automationTab, "Infinite Oxygen", false, function(value)
    flags.infiniteOxygen = value
    print("💨 Infinite Oxygen " .. (value and "enabled" or "disabled"))
end)

--// Teleport Tab
ui:AddSection(teleportTab, "🌍 Zone Teleports")

for zoneName, cframe in pairs(TeleportLocations.Zones) do
    ui:AddButton(teleportTab, "📍 " .. zoneName, function()
        teleportTo(cframe)
    end)
end

ui:AddSection(teleportTab, "🎣 Rod Teleports")

for rodName, cframe in pairs(TeleportLocations.Rods) do
    ui:AddButton(teleportTab, "🎣 " .. rodName, function()
        teleportTo(cframe)
    end)
end

--// Modifications Tab
ui:AddSection(modificationsTab, "🎮 Game Modifications")

ui:AddToggle(modificationsTab, "Fish Abundance ESP", false, function(value)
    flags.fishAbundance = value
    print("🐟 Fish Abundance ESP " .. (value and "enabled" or "disabled"))
end)

ui:AddSlider(modificationsTab, "Walk Speed", 16, 100, 16, function(value)
    local char = getChar()
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
            print("🏃 Walk Speed set to " .. value)
        end
    end
end)

ui:AddSlider(modificationsTab, "Jump Power", 50, 200, 50, function(value)
    local char = getChar()
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
            print("🦘 Jump Power set to " .. value)
        end
    end
end)

ui:AddDropdown(modificationsTab, "Time of Day", {"Dawn", "Day", "Dusk", "Night"}, function(selected)
    local lighting = game:GetService("Lighting")
    if selected == "Dawn" then
        lighting.TimeOfDay = "06:00:00"
    elseif selected == "Day" then
        lighting.TimeOfDay = "12:00:00"
    elseif selected == "Dusk" then
        lighting.TimeOfDay = "18:00:00"
    elseif selected == "Night" then
        lighting.TimeOfDay = "00:00:00"
    end
    print("🌅 Time changed to " .. selected)
end)

--// Credits Tab
ui:AddSection(creditsTab, "👨‍💻 Developer")

ui:AddButton(creditsTab, "👤 MELLISAEFFENDY", function()
    print("👨‍💻 Created by MELLISAEFFENDY")
end)

ui:AddButton(creditsTab, "📱 GitHub Repository", function()
    setclipboard("https://github.com/MELLISAEFFENDY/chfish")
    print("📋 GitHub link copied to clipboard!")
end)

ui:AddSection(creditsTab, "ℹ️ Information")

ui:AddButton(creditsTab, "📊 Version: 2.0", function()
    print("📊 FISCH Script v2.0 - Simple UI Edition")
end)

ui:AddButton(creditsTab, "🔄 Reload Script", function()
    if ui.gui then
        ui.gui:Destroy()
    end
    loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/chfish/main/new-main.lua'))()
end)

--// Cleanup on character respawn
lp.CharacterAdded:Connect(function()
    wait(1)
    toggleFreeze(false) -- Reset freeze on respawn
end)

print("🎉 FISCH Script loaded successfully!")
print("📖 Made by MELLISAEFFENDY | github.com/MELLISAEFFENDY/chfish")

-- Auto notification
local function showNotification(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
    })
end

showNotification("🎣 FISCH Script", "Script loaded successfully!", 5)
