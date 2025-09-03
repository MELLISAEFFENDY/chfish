--// Services
local Players = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RunService = cloneref(game:GetService('RunService'))
local GuiService = cloneref(game:GetService('GuiService'))

--// Variables
local flags = {}
local characterposition
local lp = Players.LocalPlayer
local fishabundancevisible = false
local deathcon
local tooltipmessage
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
        ['Atlantis'] = CFrame.new(-4465, -604, 1874)
    },
    ['Rods'] = {
        ['Heaven Rod'] = CFrame.new(20025.0508, -467.665955, 7114.40234, -0.9998191, -2.41349773e-10, 0.0190212391, -4.76249762e-10, 1, -1.23448247e-08, -0.0190212391, -1.23516495e-08, -0.9998191),
        ['Training Rod'] = CFrame.new(465, 150, 235),
        ['Fortune Rod'] = CFrame.new(-1515, 141, 765),
        ['Kings Rod'] = CFrame.new(1380.83862, -807.198608, -304.22229, -0.692510426, 9.24755454e-08, 0.72140789, 4.86611427e-08, 1, -8.1475676e-08, -0.72140789, -2.13182219e-08, -0.692510426)
    },
    ['Items'] = {
        ['Fish Radar'] = CFrame.new(365, 135, 275),
        ['Basic Diving Gear'] = CFrame.new(370, 135, 250),
        ['Bait Crate'] = CFrame.new(315, 135, 335),
        ['Glider'] = CFrame.new(-1710, 150, 740)
    },
    ['Fishing Spots'] = {
        ['Trout Spot'] = CFrame.new(390, 132, 345),
        ['Anchovy Spot'] = CFrame.new(130, 135, 630),
        ['Perch Spot'] = CFrame.new(-1805, 140, 595),
        ['Blue Tang Spot'] = CFrame.new(-1465, 125, 525)
    },
    ['NPCs'] = {
        ['Angler'] = CFrame.new(480, 150, 295),
        ['Merchant'] = CFrame.new(465, 150, 230),
        ['Appraiser'] = CFrame.new(445, 150, 210)
    }
}

local ZoneNames = {}
local RodNames = {}
local ItemNames = {}
local FishingSpotNames = {}
local NPCNames = {}
local RodColors = {}
local RodMaterials = {}

for i,v in pairs(TeleportLocations['Zones']) do table.insert(ZoneNames, i) end
for i,v in pairs(TeleportLocations['Rods']) do table.insert(RodNames, i) end
for i,v in pairs(TeleportLocations['Items']) do table.insert(ItemNames, i) end
for i,v in pairs(TeleportLocations['Fishing Spots']) do table.insert(FishingSpotNames, i) end
for i,v in pairs(TeleportLocations['NPCs']) do table.insert(NPCNames, i) end

--// Functions
FindChildOfClass = function(parent, classname)
    return parent:FindFirstChildOfClass(classname)
end
FindChild = function(parent, child)
    return parent:FindFirstChild(child)
end
FindChildOfType = function(parent, childname, classname)
    local child = parent:FindFirstChild(childname)
    if child and child.ClassName == classname then
        return child
    end
end
CheckFunc = function(func)
    return typeof(func) == 'function'
end

--// Custom Functions
getchar = function()
    return lp.Character or lp.CharacterAdded:Wait()
end
gethrp = function()
    return getchar():WaitForChild('HumanoidRootPart')
end
gethum = function()
    return getchar():WaitForChild('Humanoid')
end
FindRod = function()
    if FindChildOfClass(getchar(), 'Tool') and FindChild(FindChildOfClass(getchar(), 'Tool'), 'values') then
        return FindChildOfClass(getchar(), 'Tool')
    else
        return nil
    end
end
message = function(text, time)
    if tooltipmessage then tooltipmessage:Remove() end
    tooltipmessage = require(lp.PlayerGui:WaitForChild("GeneralUIModule")):GiveToolTip(lp, text)
    task.spawn(function()
        task.wait(time)
        if tooltipmessage then tooltipmessage:Remove(); tooltipmessage = nil end
    end)
end

--// UI Loading
local ReGui
local function loadReGui()
    local httpSuccess, httpResult = pcall(function()
        return game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/chfish/refs/heads/main/ReGui.lua')
    end)
    
    if httpSuccess and httpResult and httpResult ~= "" then
        local loadedReGui = loadstring(httpResult)()
        if type(loadedReGui) == "table" and loadedReGui.Init then
            return loadedReGui
        end
    end
    error("Failed to load ReGui")
end

ReGui = loadReGui()
print("✅ ReGui loaded successfully")

ReGui.Init()
print("✅ ReGui initialized successfully")

-- Create main window
local MainWindow = ReGui.Window({
    Title = 'FISCH Script',
    Size = UDim2.fromOffset(500, 600)
})
print("✅ Main window created successfully")

-- Create tabs
local AutomationTab = MainWindow:CreateTab({Name = 'Automation'})
local ModificationsTab = MainWindow:CreateTab({Name = 'Modifications'})
local TeleportsTab = MainWindow:CreateTab({Name = 'Teleports'})
local VisualsTab = MainWindow:CreateTab({Name = 'Visuals'})
print("✅ All tabs created successfully")

-- Automation Section
AutomationTab:CollapsingHeader({Title = 'Autofarm'})
AutomationTab:Checkbox({
    Label = 'Freeze Character',
    Value = false,
    Callback = function(self, value)
        flags.freezechar = value
    end
})
AutomationTab:Combo({
    Label = 'Freeze Character Mode',
    Items = {'Rod Equipped', 'Toggled'},
    Selected = 'Rod Equipped',
    Callback = function(self, value)
        flags.freezecharmode = value
    end
})
AutomationTab:Checkbox({
    Label = 'Auto Cast',
    Value = false,
    Callback = function(self, value)
        flags.autocast = value
    end
})
AutomationTab:Checkbox({
    Label = 'Auto Shake',
    Value = false,
    Callback = function(self, value)
        flags.autoshake = value
    end
})
AutomationTab:Checkbox({
    Label = 'Auto Reel',
    Value = false,
    Callback = function(self, value)
        flags.autoreel = value
    end
})

-- Modifications Section
ModificationsTab:CollapsingHeader({Title = 'Client Modifications'})
ModificationsTab:Checkbox({
    Label = 'Infinite Oxygen',
    Value = false,
    Callback = function(self, value)
        flags.infoxygen = value
    end
})
ModificationsTab:Checkbox({
    Label = 'No Temperature & Oxygen',
    Value = false,
    Callback = function(self, value)
        flags.nopeakssystems = value
    end
})

if CheckFunc(hookmetamethod) then
    ModificationsTab:CollapsingHeader({Title = 'Game Hooks'})
    ModificationsTab:Checkbox({
        Label = 'No AFK Kick',
        Value = false,
        Callback = function(self, value)
            flags.noafk = value
        end
    })
    ModificationsTab:Checkbox({
        Label = 'Perfect Cast',
        Value = false,
        Callback = function(self, value)
            flags.perfectcast = value
        end
    })
    ModificationsTab:Checkbox({
        Label = 'Always Catch Fish',
        Value = false,
        Callback = function(self, value)
            flags.alwayscatch = value
        end
    })
end

-- Teleports Section
TeleportsTab:CollapsingHeader({Title = 'Locations'})
TeleportsTab:Combo({
    Label = 'Select Zone',
    Items = ZoneNames,
    Selected = ZoneNames[1] or '',
    Callback = function(self, value)
        flags.selectedzone = value
    end
})
TeleportsTab:Button({
    Text = 'Teleport To Zone',
    Callback = function()
        if flags.selectedzone and TeleportLocations['Zones'][flags.selectedzone] then
            gethrp().CFrame = TeleportLocations['Zones'][flags.selectedzone]
            message('Teleported to ' .. flags.selectedzone, 3)
        end
    end
})

TeleportsTab:CollapsingHeader({Title = 'Rods & Equipment'})
TeleportsTab:Combo({
    Label = 'Select Rod',
    Items = RodNames,
    Selected = RodNames[1] or '',
    Callback = function(self, value)
        flags.selectedrod = value
    end
})
TeleportsTab:Button({
    Text = 'Teleport To Rod',
    Callback = function()
        if flags.selectedrod and TeleportLocations['Rods'][flags.selectedrod] then
            gethrp().CFrame = TeleportLocations['Rods'][flags.selectedrod]
            message('Teleported to ' .. flags.selectedrod, 3)
        end
    end
})

TeleportsTab:CollapsingHeader({Title = 'Items'})
TeleportsTab:Combo({
    Label = 'Select Item',
    Items = ItemNames,
    Selected = ItemNames[1] or '',
    Callback = function(self, value)
        flags.selecteditem = value
    end
})
TeleportsTab:Button({
    Text = 'Teleport To Item',
    Callback = function()
        if flags.selecteditem and TeleportLocations['Items'][flags.selecteditem] then
            gethrp().CFrame = TeleportLocations['Items'][flags.selecteditem]
            message('Teleported to ' .. flags.selecteditem, 3)
        end
    end
})

-- Visuals Section
VisualsTab:CollapsingHeader({Title = 'Rod Visuals'})
VisualsTab:Checkbox({
    Label = 'Rod Chams',
    Value = false,
    Callback = function(self, value)
        flags.rodchams = value
    end
})
VisualsTab:Combo({
    Label = 'Rod Material',
    Items = {'ForceField', 'Neon'},
    Selected = 'ForceField',
    Callback = function(self, value)
        flags.rodmaterial = value
    end
})

VisualsTab:CollapsingHeader({Title = 'Fish Radar'})
VisualsTab:Checkbox({
    Label = 'Show Fish Abundance',
    Value = false,
    Callback = function(self, value)
        flags.fishabundance = value
    end
})

print("✅ UI setup completed successfully")

--// Main Loop
RunService.Heartbeat:Connect(function()
    -- Character Freezing
    if flags.freezechar then
        if flags.freezecharmode == 'Toggled' then
            if characterposition == nil then
                characterposition = gethrp().CFrame
            else
                gethrp().CFrame = characterposition
            end
        elseif flags.freezecharmode == 'Rod Equipped' then
            local rod = FindRod()
            if rod and characterposition == nil then
                characterposition = gethrp().CFrame
            elseif rod and characterposition ~= nil then
                gethrp().CFrame = characterposition
            else
                characterposition = nil
            end
        end
    else
        characterposition = nil
    end
    
    -- Auto Shake
    if flags.autoshake then
        local shakeUI = FindChild(lp.PlayerGui, 'shakeui')
        if shakeUI then
            local safeZone = FindChild(shakeUI, 'safezone')
            if safeZone then
                local button = FindChild(safeZone, 'button')
                if button then
                    GuiService.SelectedObject = button
                    if GuiService.SelectedObject == button then
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    end
                end
            end
        end
    end
    
    -- Auto Cast
    if flags.autocast then
        local rod = FindRod()
        if rod and rod.values and rod.values.lure then
            if rod.values.lure.Value <= 0.001 then
                task.wait(0.5)
                if rod.events and rod.events.cast then
                    rod.events.cast:FireServer(100, 1)
                end
            end
        end
    end
    
    -- Auto Reel
    if flags.autoreel then
        local rod = FindRod()
        if rod and rod.values and rod.values.lure then
            if rod.values.lure.Value >= 99.9 then
                task.wait(0.5)
                if ReplicatedStorage.events and ReplicatedStorage.events.reelfinished then
                    ReplicatedStorage.events.reelfinished:FireServer(100, true)
                end
            end
        end
    end
    
    -- Rod Chams
    if flags.rodchams then
        local rod = FindRod()
        if rod and FindChild(rod, 'handle') then
            rod.handle.Color = Color3.fromRGB(100, 100, 255)
            if flags.rodmaterial and Enum.Material[flags.rodmaterial] then
                rod.handle.Material = Enum.Material[flags.rodmaterial]
            end
        end
    end
    
    -- Fish Abundance
    if flags.fishabundance then
        if not fishabundancevisible then
            message('Fish Abundance Zones are now visible', 5)
            fishabundancevisible = true
        end
        
        if workspace:FindFirstChild('zones') and workspace.zones:FindFirstChild('fishing') then
            for _, zone in pairs(workspace.zones.fishing:GetChildren()) do
                if FindChildOfType(zone, 'Abundance', 'StringValue') then
                    local radar1 = FindChildOfType(zone, 'radar1', 'BillboardGui')
                    local radar2 = FindChildOfType(zone, 'radar2', 'BillboardGui')
                    if radar1 then radar1.Enabled = true end
                    if radar2 then radar2.Enabled = true end
                end
            end
        end
    else
        if fishabundancevisible then
            message('Fish Abundance Zones are no longer visible', 5)
            fishabundancevisible = false
        end
        
        if workspace:FindFirstChild('zones') and workspace.zones:FindFirstChild('fishing') then
            for _, zone in pairs(workspace.zones.fishing:GetChildren()) do
                if FindChildOfType(zone, 'Abundance', 'StringValue') then
                    local radar1 = FindChildOfType(zone, 'radar1', 'BillboardGui')
                    local radar2 = FindChildOfType(zone, 'radar2', 'BillboardGui')
                    if radar1 then radar1.Enabled = false end
                    if radar2 then radar2.Enabled = false end
                end
            end
        end
    end
    
    -- Infinite Oxygen
    if flags.infoxygen then
        if not getchar():FindFirstChild('DivingTank') then
            local oxygentank = Instance.new('Decal')
            oxygentank.Name = 'DivingTank'
            oxygentank:SetAttribute('Tier', math.huge)
            oxygentank.Parent = getchar()
        end
    else
        local tank = getchar():FindFirstChild('DivingTank')
        if tank then tank:Destroy() end
    end
    
    -- No Temperature & Oxygen Systems
    if flags.nopeakssystems then
        getchar():SetAttribute('WinterCloakEquipped', true)
        getchar():SetAttribute('Refill', true)
    else
        getchar():SetAttribute('WinterCloakEquipped', nil)
        getchar():SetAttribute('Refill', false)
    end
end)

--// Hooks
if CheckFunc(hookmetamethod) then
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method, args = getnamecallmethod(), {...}
        
        if method == 'FireServer' and self.Name == 'afk' and flags.noafk then
            args[1] = false
            return old(self, unpack(args))
        elseif method == 'FireServer' and self.Name == 'cast' and flags.perfectcast then
            args[1] = 100
            return old(self, unpack(args))
        elseif method == 'FireServer' and self.Name == 'reelfinished' and flags.alwayscatch then
            args[1] = 100
            args[2] = true
            return old(self, unpack(args))
        end
        
        return old(self, ...)
    end)
end

print("🎣 FISCH Script loaded successfully!")
print("Click the floating button to open/close the GUI")
