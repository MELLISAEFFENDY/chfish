-- FISCH Script with Simple UI
-- Created by MELLISAEFFENDY
-- Repository: https://github.com/MELLISAEFFENDY/chfish

print("🎣 Loading FISCH Script with Simple UI...")

--// Services with validation
local function getService(serviceName)
    local success, service =//Teleport Tab
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

ui:AddSection(teleportTab, "👥 NPC Teleports")

for npcName, cframe in pairs(TeleportLocations.NPCs) do
    ui:AddButton(teleportTab, "👤 " .. npcName, function()
        teleportTo(cframe)
    end)
end)
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

--//Teleport Locations
local TeleportLocations = {
    ['Zones'] = {
        ['Moosewood'] = CFrame.new(379.875458, 134.500519, 233.5495, -0.033920113, 8.13274355e-08, 0.999424577, 8.98441925e-08, 1, -7.83249803e-08, -0.999424577, 8.7135696e-08, -0.033920113),
        ['Roslit Bay'] = CFrame.new(-1472.9812, 132.525513, 707.644531, -0.00177415239, 1.15743369e-07, -0.99999845, -9.25943056e-09, 1, 1.15759981e-07, 0.99999845, 9.46479251e-09, -0.00177415239),
        ['Forsaken Shores'] = CFrame.new(-2491.104, 133.250015, 1561.2926, 0.355353981, -1.68352852e-08, -0.934731781, 4.69647858e-08, 1, -1.56367586e-10, 0.934731781, -4.38439116e-08, 0.355353981),
        ['Sunstone Island'] = CFrame.new(-913.809143, 138.160782, -1133.25879, -0.746701241, 4.50330218e-09, 0.665159583, 2.84934609e-09, 1, -3.5716119e-09, -0.665159583, -7.71657294e-10, -0.746701241),
        ['Statue of Sovereignty'] = CFrame.new(21.4017925, 159.014709, -1039.14233, -0.865476549, -4.38348664e-08, -0.500949502, -9.38435818e-08, 1, 7.46273798e-08, 0.500949502, 1.11599142e-07, -0.865476549),
        ['Terrapin Island'] = CFrame.new(-193.434143, 135.121979, 1951.46936, 0.512723684, -6.94711346e-08, 0.858553708, 5.44089183e-08, 1, 4.84237539e-08, -0.858553708, 2.18849721e-08, 0.512723684),
        ['Snowcap Island'] = CFrame.new(2607.93018, 135.284332, 2436.13208, 0.909039497, -7.49003748e-10, 0.4167099, 3.38659367e-09, 1, -5.59032465e-09, -0.4167099, 6.49305321e-09, 0.909039497),
        ['Mushgrove Swamp'] = CFrame.new(2434.29785, 131.983276, -691.930542, -0.123090521, -7.92820209e-09, -0.992395461, -9.05862692e-08, 1, 3.2467995e-09, 0.992395461, 9.02970569e-08, -0.123090521),
        ['Ancient Isle'] = CFrame.new(6056.02783, 195.280167, 276.270325, -0.655055285, 1.96010075e-09, 0.755580962, -1.63855578e-08, 1, -1.67997189e-08, -0.755580962, -2.33853594e-08, -0.655055285),
        ['Northern Expedition'] = CFrame.new(-1701.02979, 187.638779, 3944.81494, 0.918493569, -8.5804345e-08, 0.395435959, 8.59132356e-08, 1, 1.74328942e-08, -0.395435959, 1.7961181e-08, 0.918493569),
        ['Northern Summit'] = CFrame.new(19608.791, 131.420105, 5222.15283, 0.462794542, -2.64426987e-08, 0.886465549, -4.47066562e-08, 1, 5.31692343e-08, -0.886465549, -6.42373408e-08, 0.462794542),
        ['Vertigo'] = CFrame.new(-102.40567, -513.299377, 1052.07104, -0.999989033, 5.36423439e-09, 0.00468267547, 5.85247495e-09, 1, 1.04251647e-07, -0.00468267547, 1.04277916e-07, -0.999989033),
        ['Depths Entrance'] = CFrame.new(-15.4965982, -706.123718, 1231.43494, 0.0681341439, 1.15903154e-08, -0.997676194, 7.1017638e-08, 1, 1.64673093e-08, 0.997676194, -7.19745898e-08, 0.0681341439),
        ['Depths'] = CFrame.new(491.758118, -706.123718, 1230.6377, 0.00879980437, 1.29271776e-08, -0.999961257, 1.95575205e-13, 1, 1.29276803e-08, 0.999961257, -1.13956629e-10, 0.00879980437),
        ['Overgrowth Caves'] = CFrame.new(19746.2676, 416.00293, 5403.5752, 0.488031536, -3.30940715e-08, -0.87282598, -3.24267696e-11, 1, -3.79341323e-08, 0.87282598, 1.85413569e-08, 0.488031536),
        ['Frigid Cavern'] = CFrame.new(20253.6094, 756.525818, 5772.68555, -0.781508088, 1.85673343e-08, 0.623895109, 5.92671467e-09, 1, -2.23363816e-08, -0.623895109, -1.3758414e-08, -0.781508088),
        ['Cryogenic Canal'] = CFrame.new(19958.5176, 917.195923, 5332.59375, 0.758922458, -7.29783434e-09, 0.651180983, -4.58880756e-09, 1, 1.65551253e-08, -0.651180983, -1.55522013e-08, 0.758922458),
        ['Glacial Grotto'] = CFrame.new(20003.0273, 1136.42798, 5555.95996, 0.983130038, -3.94455064e-08, 0.182907909, 3.45229765e-08, 1, 3.0096718e-08, -0.182907909, -2.32744615e-08, 0.983130038),
        ["Keeper's Altar"] = CFrame.new(1297.92285, -805.292236, -284.155823, -0.99758029, 5.80044706e-08, -0.0695239156, 6.16549869e-08, 1, -5.03615105e-08, 0.0695239156, -5.45261436e-08, -0.99758029),
        ['Atlantis'] = CFrame.new(-4465, -604, 1874),
        ['Brine Pool'] = CFrame.new(-3123, -642, 2085),
        ['Solar Fragments'] = CFrame.new(-16, 129, -1061),
        ['Wilson Point'] = CFrame.new(2899.5, 136.5, 1143.5),
        ['Scallop Shoal'] = CFrame.new(391, 134.5, 1808.5),
        ['The Arch'] = CFrame.new(1080, 134.5, -960),
        ['Harvesters Spike'] = CFrame.new(-3374, 126, 1152),
        ['Desolate Deep'] = CFrame.new(-1715, -231, 1234),
        ['Hadal Blacksite'] = CFrame.new(-4850, -662, 1548)
    },
    ['Rods'] = {
        ['Training Rod'] = CFrame.new(465, 150, 235),
        ['Plastic Rod'] = CFrame.new(472.4, 150.1, 245.3),
        ['Lucky Rod'] = CFrame.new(468.3, 151.2, 248.7),
        ['Kings Rod'] = CFrame.new(1380.83862, -807.198608, -304.22229, -0.692510426, 9.24755454e-08, 0.72140789, 4.86611427e-08, 1, -8.1475676e-08, -0.72140789, -2.13182219e-08, -0.692510426),
        ['Flimsy Rod'] = CFrame.new(471.8, 148.5, 239.2),
        ['Nocturnal Rod'] = CFrame.new(-2842.3, 135.2, 1539.8),
        ['Fast Rod'] = CFrame.new(450.7, 149.8, 232.1),
        ['Carbon Rod'] = CFrame.new(-1472.8, 133.5, 707.3),
        ['Long Rod'] = CFrame.new(480, 180, 150),
        ['Mythical Rod'] = CFrame.new(-909.8, 139.4, -1134.2),
        ['Midas Rod'] = CFrame.new(-909.8, 139.4, -1134.2),
        ['Trident Rod'] = CFrame.new(-193.4, 135.1, 1951.5),
        ['Enchanted Altar'] = CFrame.new(1297.9, -805.3, -284.2),
        ['Rod of the Depths'] = CFrame.new(1380.8, -807.2, -304.2),
        ['Heaven Rod'] = CFrame.new(20025.0508, -467.665955, 7114.40234, -0.9998191, -2.41349773e-10, 0.0190212391, -4.76249762e-10, 1, -1.23448247e-08, -0.0190212391, -1.23516495e-08, -0.9998191),
        ['Summit Rod'] = CFrame.new(20213.334, 736.668823, 5707.8208, -0.274440169, 3.53429606e-08, 0.961604178, -1.52819659e-08, 1, -4.11156122e-08, -0.961604178, -2.59789772e-08, -0.274440169),
        ['Fortune Rod'] = CFrame.new(-1515, 141, 765),
        ['Destiny Rod'] = CFrame.new(-1472.8, 133.5, 707.3),
        ['No-Life Rod'] = CFrame.new(467.2, 149.5, 241.8),
        ['Stone Rod'] = CFrame.new(465.8, 150.3, 236.4),
        ['Crystal Rod'] = CFrame.new(2607.9, 135.3, 2436.1),
        ['Magnet Rod'] = CFrame.new(379.9, 134.5, 233.5),
        ['Tempest Rod'] = CFrame.new(-4928, -595, 1857),
        ['Smokescreen Rod'] = CFrame.new(-2491.1, 133.3, 1561.3),
        ['Steady Rod'] = CFrame.new(465.2, 150.8, 238.9),
        ['Auto Fisher'] = CFrame.new(21.4, 159.0, -1039.1),
        ['Big Chungus Rod'] = CFrame.new(6056.0, 195.3, 276.3),
        ['Krampus Rod'] = CFrame.new(2607.9, 135.3, 2436.1),
        ['Candy Cane Rod'] = CFrame.new(2607.9, 135.3, 2436.1)
    },
    ['NPCs'] = {
        ['Merchant'] = CFrame.new(471, 150.1, 240),
        ['Shipwright'] = CFrame.new(372, 134.5, 205),
        ['Appraiser'] = CFrame.new(454, 150.1, 204),
        ['Innkeeper'] = CFrame.new(490, 150.1, 230),
        ['Angler'] = CFrame.new(487, 150.1, 279),
        ['Captain Goldbeard'] = CFrame.new(-2842, 135.2, 1539),
        ['Pierre'] = CFrame.new(392, 134.5, 1808),
        ['Phineas'] = CFrame.new(-193.4, 135.1, 1951.5),
        ['Henry'] = CFrame.new(-1472.8, 133.5, 707.3),
        ['Jack Marrow'] = CFrame.new(-2491.1, 133.3, 1561.3),
        ['Latern Keeper'] = CFrame.new(-909.8, 139.4, -1134.2),
        ['Daisy'] = CFrame.new(2607.9, 135.3, 2436.1),
        ['Quiet Synph'] = CFrame.new(2434.3, 132.0, -691.9),
        ['Cryptic Scholar'] = CFrame.new(6056.0, 195.3, 276.3),
        ['Keeper'] = CFrame.new(1297.9, -805.3, -284.2),
        ['The Depths - Keeper'] = CFrame.new(1380.8, -807.2, -304.2)
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

--//Modifications Tab
ui:AddSection(modificationsTab, "🎮 Player Modifications")

ui:AddToggle(modificationsTab, "God Mode", false, function(value)
    local char = getChar()
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            if value then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                print("🛡️ God Mode enabled")
            else
                humanoid.MaxHealth = 100
                humanoid.Health = 100
                print("🛡️ God Mode disabled")
            end
        end
    end
end)

ui:AddToggle(modificationsTab, "No Clip", false, function(value)
    flags.noclip = value
    if value then
        local noclipConnection
        noclipConnection = RunService.Stepped:Connect(function()
            if flags.noclip then
                local char = getChar()
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            else
                noclipConnection:Disconnect()
            end
        end)
        print("👻 No Clip enabled")
    else
        print("👻 No Clip disabled")
    end
end)

ui:AddToggle(modificationsTab, "Fish Abundance ESP", false, function(value)
    flags.fishAbundance = value
    print("🐟 Fish Abundance ESP " .. (value and "enabled" or "disabled"))
end)

ui:AddSlider(modificationsTab, "Walk Speed", 16, 500, 16, function(value)
    local char = getChar()
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
            print("🏃 Walk Speed set to " .. value)
        end
    end
end)

ui:AddSlider(modificationsTab, "Jump Power", 50, 500, 50, function(value)
    local char = getChar()
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
            print("🦘 Jump Power set to " .. value)
        end
    end
end)

ui:AddSlider(modificationsTab, "Field of View (FOV)", 70, 120, 70, function(value)
    local camera = Workspace.CurrentCamera
    if camera then
        camera.FieldOfView = value
        print("👁️ FOV set to " .. value)
    end
end)

ui:AddSection(modificationsTab, "🌍 World Modifications")

ui:AddDropdown(modificationsTab, "Time of Day", {"Dawn", "Day", "Dusk", "Night", "Midnight"}, function(selected)
    local lighting = game:GetService("Lighting")
    if selected == "Dawn" then
        lighting.TimeOfDay = "06:00:00"
    elseif selected == "Day" then
        lighting.TimeOfDay = "12:00:00"
    elseif selected == "Dusk" then
        lighting.TimeOfDay = "18:00:00"
    elseif selected == "Night" then
        lighting.TimeOfDay = "20:00:00"
    elseif selected == "Midnight" then
        lighting.TimeOfDay = "00:00:00"
    end
    print("🌅 Time changed to " .. selected)
end)

ui:AddToggle(modificationsTab, "Full Bright", false, function(value)
    local lighting = game:GetService("Lighting")
    if value then
        lighting.Brightness = 2
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        print("💡 Full Bright enabled")
    else
        lighting.Brightness = 1
        lighting.Ambient = Color3.fromRGB(70, 70, 70)
        lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        print("💡 Full Bright disabled")
    end
end)

ui:AddToggle(modificationsTab, "Anti AFK", false, function(value)
    flags.antiAFK = value
    if value then
        local antiAFKConnection
        antiAFKConnection = RunService.Heartbeat:Connect(function()
            if flags.antiAFK then
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            else
                antiAFKConnection:Disconnect()
            end
        end)
        print("⏰ Anti AFK enabled")
    else
        print("⏰ Anti AFK disabled")
    end
end)

ui:AddSection(modificationsTab, "🎣 Fishing Enhancements")

ui:AddToggle(modificationsTab, "Auto Sell Fish", false, function(value)
    flags.autoSell = value
    print("💰 Auto Sell Fish " .. (value and "enabled" or "disabled"))
end)

ui:AddToggle(modificationsTab, "Perfect Cast", false, function(value)
    flags.perfectCast = value
    print("🎯 Perfect Cast " .. (value and "enabled" or "disabled"))
end)

ui:AddToggle(modificationsTab, "Instant Catch", false, function(value)
    flags.instantCatch = value
    print("⚡ Instant Catch " .. (value and "enabled" or "disabled"))
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
