--// Services
local Players = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RunService = cloneref(game:GetService('RunService'))
local GuiService = cloneref(game:GetService('GuiService'))
local UserInputService = cloneref(game:GetService('UserInputService'))

--// Variables
local flags = {}
local characterposition
local lp = Players.LocalPlayer
local fishabundancevisible = false
local deathcon
local tooltipmessage

-- Default delay values
flags['autocastdelay'] = 0.5
flags['autoreeldelay'] = 0.5
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
        ['Atlantis'] = CFrame.new(-4465, -604, 1874)
    },
    ['Rods'] = {
        ['Heaven Rod'] = CFrame.new(20025.0508, -467.665955, 7114.40234, -0.9998191, -2.41349773e-10, 0.0190212391, -4.76249762e-10, 1, -1.23448247e-08, -0.0190212391, -1.23516495e-08, -0.9998191),
        ['Summit Rod'] = CFrame.new(20213.334, 736.668823, 5707.8208, -0.274440169, 3.53429606e-08, 0.961604178, -1.52819659e-08, 1, -4.11156122e-08, -0.961604178, -2.59789772e-08, -0.274440169),
        ['Kings Rod'] = CFrame.new(1380.83862, -807.198608, -304.22229, -0.692510426, 9.24755454e-08, 0.72140789, 4.86611427e-08, 1, -8.1475676e-08, -0.72140789, -2.13182219e-08, -0.692510426),
        ['Training Rod'] = CFrame.new(465, 150, 235),
        ['Long Rod'] = CFrame.new(480, 180, 150),
        ['Fortune Rod'] = CFrame.new(-1515, 141, 765),
        ['Depthseeker Rod'] = CFrame.new(-4465, -604, 1874),
        ['Champions Rod'] = CFrame.new(-4277, -606, 1838),
        ['Tempest Rod'] = CFrame.new(-4928, -595, 1857),
        ['Abyssal Specter Rod'] = CFrame.new(-3804, -567, 1870),
        ['Poseidon Rod'] = CFrame.new(-4086, -559, 895),
        ['Zeus Rod'] = CFrame.new(-4272, -629, 2665),
        ['Kraken Rod'] = CFrame.new(-4415, -997, 2055),
        ['Reinforced Rod'] = CFrame.new(-975, -245, -2700),
        ['Trident Rod'] = CFrame.new(-1485, -225, -2195),
        ['Scurvy Rod'] = CFrame.new(-2830, 215, 1510),
        ['Stone Rod'] = CFrame.new(5487, 143, -316),
        ['Magnet Rod'] = CFrame.new(-200, 130, 1930)
    },
    ['Items'] = {
        ['Fish Radar'] = CFrame.new(365, 135, 275),
        ['Basic Diving Gear'] = CFrame.new(370, 135, 250),
        ['Bait Crate (Moosewood)'] = CFrame.new(315, 135, 335),
        ['Meteor Totem'] = CFrame.new(-1945, 275, 230),
        ['Glider'] = CFrame.new(-1710, 150, 740),
        ['Bait Crate (Roslit)'] = CFrame.new(-1465, 130, 680),
        ['Crab Cage (Roslit)'] = CFrame.new(-1485, 130, 640),
        ['Poseidon Wrath Totem'] = CFrame.new(-3953, -556, 853),
        ['Zeus Storm Totem'] = CFrame.new(-4325, -630, 2687),
        ['Quality Bait Crate (Atlantis)'] = CFrame.new(-177, 144, 1933),
        ['Flippers'] = CFrame.new(-4462, -605, 1875),
        ['Super Flippers'] = CFrame.new(-4463, -603, 1876),
        ['Advanced Diving Gear (Atlantis)'] = CFrame.new(-4452, -603, 1877),
        ['Conception Conch (Atlantis)'] = CFrame.new(-4450, -605, 1874),
        ['Advanced Diving Gear (Desolate)'] = CFrame.new(-790, 125, -3100),
        ['Basic Diving Gear (Desolate)'] = CFrame.new(-1655, -210, -2825),
        ['Tidebreaker'] = CFrame.new(-1645, -210, -2855),
        ['Conception Conch (Desolate)'] = CFrame.new(-1630, -210, -2860),
        ['Aurora Totem'] = CFrame.new(-1800, -135, -3280),
        ['Bait Crate (Forsaken)'] = CFrame.new(-2490, 130, 1535),
        ['Crab Cage (Forsaken)'] = CFrame.new(-2525, 135, -1575),
        ['Eclipse Totem'] = CFrame.new(5966, 274, 846),
        ['Bait Crate (Ancient)'] = CFrame.new(6075, 195, 260),
        ['Smokescreen Totem'] = CFrame.new(2790, 140, -625),
        ['Crab Cage (Mushgrove)'] = CFrame.new(2520, 135, -895),
        ['Windset Totem'] = CFrame.new(2845, 180, 2700),
        ['Sundial Totem'] = CFrame.new(-1145, 135, -1075),
        ['Bait Crate (Sunstone)'] = CFrame.new(-1045, 200, -1100),
        ['Crab Cage (Sunstone)'] = CFrame.new(-920, 130, -1105),
        ['Quality Bait Crate (Terrapin)'] = CFrame.new(-175, 145, 1935),
        ['Tempest Totem'] = CFrame.new(35, 130, 1945)
    },
    ['Fishing Spots'] = {
        ['Trout Spot'] = CFrame.new(390, 132, 345),
        ['Anchovy Spot'] = CFrame.new(130, 135, 630),
        ['Yellowfin Tuna Spot'] = CFrame.new(705, 136, 340),
        ['Carp Spot'] = CFrame.new(560, 145, 600),
        ['Goldfish Spot'] = CFrame.new(525, 145, 310),
        ['Flounder Spot'] = CFrame.new(285, 133, 215),
        ['Pike Spot'] = CFrame.new(540, 145, 330),
        ['Perch Spot'] = CFrame.new(-1805, 140, 595),
        ['Blue Tang Spot'] = CFrame.new(-1465, 125, 525),
        ['Clownfish Spot'] = CFrame.new(-1520, 125, 520),
        ['Clam Spot'] = CFrame.new(-2028, 130, 541),
        ['Angelfish Spot'] = CFrame.new(-1500, 135, 615),
        ['Arapaima Spot'] = CFrame.new(-1765, 140, 600),
        ['Suckermouth Catfish Spot'] = CFrame.new(-1800, 140, 620),
        ['Phantom Ray Spot'] = CFrame.new(-1685, -235, -3090),
        ['Cockatoo Squid Spot'] = CFrame.new(-1645, -205, -2790),
        ['Banditfish Spot'] = CFrame.new(-1500, -235, -2855),
        ['Scurvy Sailfish Spot'] = CFrame.new(-2430, 130, 1450),
        ['Cutlass Fish Spot'] = CFrame.new(-2645, 130, 1410),
        ['Shipwreck Barracuda Spot'] = CFrame.new(-3597, 140, 1604),
        ['Golden Seahorse Spot'] = CFrame.new(-3100, 127, 1450),
        ['Anomalocaris Spot'] = CFrame.new(5504, 143, -321),
        ['Cobia Spot'] = CFrame.new(5983, 125, 1007),
        ['Hallucigenia Spot'] = CFrame.new(6015, 190, 339),
        ['Leedsichthys Spot'] = CFrame.new(6052, 394, 648),
        ['Deep Sea Fragment Spot'] = CFrame.new(5841, 81, 388),
        ['Solar Fragment Spot'] = CFrame.new(6073, 443, 684),
        ['Earth Fragment Spot'] = CFrame.new(5972, 274, 845),
        ['White Perch Spot'] = CFrame.new(2475, 125, -675),
        ['Grey Carp Spot'] = CFrame.new(2665, 125, -815),
        ['Bowfin Spot'] = CFrame.new(2445, 125, -795),
        ['Marsh Gar Spot'] = CFrame.new(2520, 125, -815),
        ['Alligator Spot'] = CFrame.new(2670, 130, -710),
        ['Pollock Spot'] = CFrame.new(2550, 135, 2385),
        ['Bluegill Spot'] = CFrame.new(3070, 130, 2600),
        ['Herring Spot'] = CFrame.new(2595, 140, 2500),
        ['Red Drum Spot'] = CFrame.new(2310, 135, 2545),
        ['Arctic Char Spot'] = CFrame.new(2350, 130, 2230),
        ['Lingcod Spot'] = CFrame.new(2820, 125, 2805),
        ['Glacierfish Spot'] = CFrame.new(2860, 135, 2620),
        ['Sweetfish Spot'] = CFrame.new(-940, 130, -1105),
        ['Glassfish Spot'] = CFrame.new(-905, 130, -1000),
        ['Longtail Bass Spot'] = CFrame.new(-860, 135, -1205),
        ['Red Tang Spot'] = CFrame.new(-1195, 123, -1220),
        ['Chinfish Spot'] = CFrame.new(-625, 130, -950),
        ['Trumpetfish Spot'] = CFrame.new(-790, 125, -1340),
        ['Mahi Mahi Spot'] = CFrame.new(-730, 130, -1350),
        ['Sunfish Spot'] = CFrame.new(-975, 125, -1430),
        ['Walleye Spot'] = CFrame.new(-225, 125, 2150),
        ['White Bass Spot'] = CFrame.new(-50, 130, 2025),
        ['Redeye Bass Spot'] = CFrame.new(-35, 125, 2285),
        ['Chinook Salmon Spot'] = CFrame.new(-305, 125, 1625),
        ['Golden Smallmouth Bass Spot'] = CFrame.new(65, 135, 2140),
        ['Olm Spot'] = CFrame.new(95, 125, 1980)
    },
    ['NPCs'] = {
        ['Angler'] = CFrame.new(480, 150, 295),
        ['Appraiser'] = CFrame.new(445, 150, 210),
        ['Arnold'] = CFrame.new(320, 134, 264),
        ['Bob'] = CFrame.new(420, 145, 260),
        ['Brickford Masterson'] = CFrame.new(412, 132, 365),
        ['Captain Ahab'] = CFrame.new(441, 135, 358),
        ['Challenges'] = CFrame.new(337, 138, 312),
        ['Clover McRich'] = CFrame.new(345, 136, 330),
        ['Daisy'] = CFrame.new(580, 165, 220),
        ['Dr. Blackfin'] = CFrame.new(355, 136, 329),
        ['Egg Salesman'] = CFrame.new(404, 135, 312),
        ['Harry Fischer'] = CFrame.new(396, 134, 381),
        ['Henry'] = CFrame.new(484, 152, 236),
        ['Inn Keeper'] = CFrame.new(490, 150, 245),
        ['Lucas'] = CFrame.new(450, 180, 175),
        ['Marlon Friend'] = CFrame.new(405, 135, 248),
        ['Merchant'] = CFrame.new(465, 150, 230),
        ['Paul'] = CFrame.new(382, 137, 347),
        ['Phineas'] = CFrame.new(470, 150, 275),
        ['Pierre'] = CFrame.new(390, 135, 200),
        ['Pilgrim'] = CFrame.new(402, 134, 257),
        ['Ringo'] = CFrame.new(410, 135, 235),
        ['Shipwright'] = CFrame.new(360, 135, 260),
        ['Skin Merchant'] = CFrame.new(415, 135, 194),
        ['Smurfette'] = CFrame.new(334, 135, 327),
        ['Tom Elf'] = CFrame.new(404, 136, 317),
        ['Witch'] = CFrame.new(410, 135, 310),
        ['Wren'] = CFrame.new(368, 135, 286),
        ['Mike'] = CFrame.new(210, 115, 640),
        ['Ryder Vex'] = CFrame.new(233, 116, 746),
        ['Ocean'] = CFrame.new(1230, 125, 575),
        ['Lars Timberjaw'] = CFrame.new(1217, 87, 574),
        ['Sporey'] = CFrame.new(1245, 86, 425),
        ['Sporey Mom'] = CFrame.new(1262, 129, 663),
        ['Oscar IV'] = CFrame.new(1392, 116, 493),
        ['Angus McBait'] = CFrame.new(236, 222, 461),
        ['Waveborne'] = CFrame.new(360, 90, 780),
        ['Boone Tiller'] = CFrame.new(390, 87, 764),
        ['Clark'] = CFrame.new(443, 84, 703),
        ['Jak'] = CFrame.new(474, 84, 758),
        ['Willow'] = CFrame.new(501, 134, 125),
        ['Marley'] = CFrame.new(505, 134, 120),
        ['Sage'] = CFrame.new(513, 134, 125),
        ['Meteoriticist'] = CFrame.new(5922, 262, 596),
        ['Chiseler'] = CFrame.new(6087, 195, 294),
        ['Sea Traveler'] = CFrame.new(140, 150, 2030),
        ['Wilson'] = CFrame.new(2935, 280, 2565),
        ['Agaric'] = CFrame.new(2931, 4268, 3039),
        ['Sunken Chest'] = CFrame.new(798, 130, 1667),
        ['Daily Shopkeeper'] = CFrame.new(229, 139, 42),
        ['AFK Rewards'] = CFrame.new(233, 139, 38),
        ['Travelling Merchant'] = CFrame.new(2, 500, 0),
        ['Silas'] = CFrame.new(1545, 1690, 6310),
        ['Nick'] = CFrame.new(50, 0, 0),
        ['Hollow'] = CFrame.new(25, 0, 0),
        ['Shopper Girl'] = CFrame.new(1000, 140, 9932),
        ['Sandy Finn'] = CFrame.new(1015, 140, 9911),
        ['Red NPC'] = CFrame.new(1020, 173, 9857),
        ['Thomas'] = CFrame.new(1062, 140, 9890),
        ['Shawn'] = CFrame.new(1068, 157, 9918),
        ['Axel'] = CFrame.new(883, 132, 9905),
        ['Joey'] = CFrame.new(906, 132, 9962),
        ['Jett'] = CFrame.new(925, 131, 9883),
        ['Lucas (Fischfest)'] = CFrame.new(946, 132, 9894),
        ['Shell Merchant'] = CFrame.new(972, 132, 9921),
        ['Barnacle Bill'] = CFrame.new(989, 143, 9975)
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
    child = parent:FindFirstChild(childname)
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

--// UI
local library
local Window
local isMinimized = false
local floatingButton = nil
local LibName = "FischScript" .. tostring(math.random(1, 100000))

-- Load Kavo UI from GitHub repository or local file
local kavoUrl = 'https://raw.githubusercontent.com/MELLISAEFFENDY/chfish/main/new/Kavo.lua'

-- Simple and reliable UI loading
local success = false
library = nil

-- Try to load Kavo UI
pcall(function()
    library = loadstring(game:HttpGet(kavoUrl))()
    if library and library.CreateLib then
        success = true
        print("Kavo UI loaded successfully")
    end
end)

-- Simple fallback UI if Kavo fails
if not success or not library then
    print("Using fallback UI")
    library = {}
    
    function library.CreateLib(name, theme)
        print("Creating fallback UI:", name)
        
        -- Create simple GUI
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = LibName
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "Main"
        mainFrame.Size = UDim2.new(0, 500, 0, 400)
        mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
        mainFrame.BackgroundColor3 = Color3.fromRGB(26, 32, 58)
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = mainFrame
        
        -- Header
        local header = Instance.new("Frame")
        header.Name = "MainHeader"
        header.Size = UDim2.new(1, 0, 0, 40)
        header.BackgroundColor3 = Color3.fromRGB(38, 45, 71)
        header.BorderSizePixel = 0
        header.Parent = mainFrame
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 8)
        headerCorner.Parent = header
        
        local coverFrame = Instance.new("Frame")
        coverFrame.Size = UDim2.new(1, 0, 0, 20)
        coverFrame.Position = UDim2.new(0, 0, 1, -20)
        coverFrame.BackgroundColor3 = Color3.fromRGB(38, 45, 71)
        coverFrame.BorderSizePixel = 0
        coverFrame.Parent = header
        
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -40, 1, 0)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 16
        title.Font = Enum.Font.SourceSansBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = header
        
        -- Close button
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseButton"
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 5)
        closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        closeBtn.Text = "×"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 20
        closeBtn.Font = Enum.Font.SourceSansBold
        closeBtn.BorderSizePixel = 0
        closeBtn.Parent = header
        
        local closeBtnCorner = Instance.new("UICorner")
        closeBtnCorner.CornerRadius = UDim.new(0, 4)
        closeBtnCorner.Parent = closeBtn
        
        closeBtn.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
        
        -- Content area
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Name = "Content"
        contentFrame.Size = UDim2.new(1, -20, 1, -60)
        contentFrame.Position = UDim2.new(0, 10, 0, 50)
        contentFrame.BackgroundTransparency = 1
        contentFrame.BorderSizePixel = 0
        contentFrame.ScrollBarThickness = 6
        contentFrame.Parent = mainFrame
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = contentFrame
        
        -- Add to PlayerGui
        screenGui.Parent = lp.PlayerGui
        
        -- Make draggable
        local dragging = false
        local dragInput = nil
        local dragStart = nil
        local startPos = nil
        
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
            end
        end)
        
        header.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        header.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        local lib = {}
        local tabCount = 0
        
        function lib:NewTab(tabName)
            tabCount = tabCount + 1
            
            -- Create tab button
            local tabBtn = Instance.new("TextButton")
            tabBtn.Name = "Tab" .. tabCount
            tabBtn.Size = UDim2.new(1, 0, 0, 35)
            tabBtn.BackgroundColor3 = Color3.fromRGB(86, 76, 251)
            tabBtn.Text = tabName or "Tab " .. tabCount
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabBtn.TextSize = 14
            tabBtn.Font = Enum.Font.SourceSansBold
            tabBtn.BorderSizePixel = 0
            tabBtn.Parent = contentFrame
            
            local tabCorner = Instance.new("UICorner")
            tabCorner.CornerRadius = UDim.new(0, 6)
            tabCorner.Parent = tabBtn
            
            -- Hover effects
            tabBtn.MouseEnter:Connect(function()
                tabBtn.BackgroundColor3 = Color3.fromRGB(106, 96, 255)
            end)
            
            tabBtn.MouseLeave:Connect(function()
                tabBtn.BackgroundColor3 = Color3.fromRGB(86, 76, 251)
            end)
            
            local tab = {}
            local sectionCount = 0
            
            function tab:NewSection(sectionName)
                sectionCount = sectionCount + 1
                
                local section = {}
                local elementCount = 0
                
                function section:NewToggle(name, desc, callback)
                    elementCount = elementCount + 1
                    if callback then callback(false) end
                    return section
                end
                
                function section:NewDropdown(name, desc, options, callback)
                    elementCount = elementCount + 1
                    if callback and options and #options > 0 then 
                        callback(options[1]) 
                    end
                    return section
                end
                
                function section:NewButton(name, desc, callback)
                    elementCount = elementCount + 1
                    return section
                end
                
                function section:NewSlider(name, desc, min, max, default, callback)
                    elementCount = elementCount + 1
                    if callback then callback(default or min or 0) end
                    return section
                end
                
                return section
            end
            
            return tab
        end
        
        return lib
    end
end

-- Function to create floating button
local function createFloatingButton()
    if floatingButton then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FischFloatingButton"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Name = "FloatingFrame"
    frame.Size = UDim2.new(0, 60, 0, 60)
    frame.Position = UDim2.new(1, -80, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(45, 65, 95)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 30)
    corner.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Name = "MinimizeButton"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundTransparency = 1
    button.Text = "🎣"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 24
    button.Font = Enum.Font.SourceSansBold
    button.Parent = frame
    
    -- Gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 99, 135)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 65, 95))
    }
    gradient.Rotation = 45
    gradient.Parent = frame
    
    -- Shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 30)
    shadowCorner.Parent = shadow
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        -- Restore main UI
        local restored = false
        
        -- Try to restore known UI
        if game.CoreGui:FindFirstChild(LibName) then
            game.CoreGui[LibName].Enabled = true
            restored = true
        elseif lp.PlayerGui:FindFirstChild(LibName) then
            lp.PlayerGui[LibName].Enabled = true
            restored = true
        end
        
        -- Try to restore any Fisch or Kavo UI
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui.Name:find("Fisch") or gui.Name:find("Kavo") then
                gui.Enabled = true
                restored = true
            end
        end
        for _, gui in pairs(lp.PlayerGui:GetChildren()) do
            if gui.Name:find("Fisch") or gui.Name:find("Kavo") then
                gui.Enabled = true
                restored = true
            end
        end
        
        -- Show standalone minimize button if it exists
        local minimizeGui = lp.PlayerGui:FindFirstChild("FischMinimize")
        if minimizeGui and minimizeGui:FindFirstChild("MinimizeFrame") then
            minimizeGui.MinimizeFrame.Visible = true
        end
        
        isMinimized = false
        
        -- Remove floating button
        if floatingButton then
            floatingButton:Destroy()
            floatingButton = nil
        end
        
        if restored then
            print("UI restored successfully")
        else
            print("No UI found to restore")
        end
    end)
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    button.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Add to CoreGui or PlayerGui
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = game.CoreGui
    else
        screenGui.Parent = lp.PlayerGui
    end
    
    floatingButton = screenGui
end

-- Function to add minimize button to main UI
local function addMinimizeButton()
    task.spawn(function()
        task.wait(1) -- Wait for UI to load
        
        print("Looking for UI to add minimize button...")
        
        -- Find the UI
        local targetGui = nil
        local targetFrame = nil
        local targetHeader = nil
        
        -- Check PlayerGui first
        for _, gui in pairs(lp.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and (gui.Name == LibName or gui.Name:find("Fisch")) then
                local main = gui:FindFirstChild("Main")
                if main then
                    local header = main:FindFirstChild("MainHeader") or main:FindFirstChild("Header") or main:FindFirstChild("TopBar")
                    if header then
                        targetGui = gui
                        targetFrame = main  
                        targetHeader = header
                        break
                    end
                end
            end
        end
        
        -- Check CoreGui if not found in PlayerGui
        if not targetGui then
            for _, gui in pairs(game.CoreGui:GetChildren()) do
                if gui:IsA("ScreenGui") and (gui.Name == LibName or gui.Name:find("Fisch") or gui.Name:find("Kavo")) then
                    local main = gui:FindFirstChild("Main")
                    if main then
                        local header = main:FindFirstChild("MainHeader") or main:FindFirstChild("Header") or main:FindFirstChild("TopBar")
                        if header then
                            targetGui = gui
                            targetFrame = main
                            targetHeader = header
                            break
                        end
                    end
                end
            end
        end
        
        if targetGui and targetHeader then
            print("Found UI, adding minimize button...")
            
            -- Check if minimize button already exists
            if targetHeader:FindFirstChild("MinimizeButton") then
                print("Minimize button already exists")
                return
            end
            
            -- Create minimize button
            local minimizeBtn = Instance.new("TextButton")
            minimizeBtn.Name = "MinimizeButton"
            minimizeBtn.Size = UDim2.new(0, 30, 0, 25)
            minimizeBtn.Position = UDim2.new(1, -35, 0, 7)
            minimizeBtn.BackgroundColor3 = Color3.fromRGB(86, 76, 251)
            minimizeBtn.Text = "—"
            minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            minimizeBtn.TextSize = 16
            minimizeBtn.Font = Enum.Font.SourceSansBold
            minimizeBtn.BorderSizePixel = 0
            minimizeBtn.ZIndex = 100
            minimizeBtn.Parent = targetHeader
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = minimizeBtn
            
            -- Minimize functionality
            minimizeBtn.MouseButton1Click:Connect(function()
                targetGui.Enabled = false
                isMinimized = true
                createFloatingButton()
                print("UI minimized successfully")
            end)
            
            -- Hover effects
            minimizeBtn.MouseEnter:Connect(function()
                minimizeBtn.BackgroundColor3 = Color3.fromRGB(106, 96, 255)
            end)
            
            minimizeBtn.MouseLeave:Connect(function()
                minimizeBtn.BackgroundColor3 = Color3.fromRGB(86, 76, 251)
            end)
            
            print("Minimize button added successfully!")
        else
            print("Could not find suitable UI to add minimize button")
        end
    end)
end
end

-- Create UI Window
Window = library.CreateLib("🎣 Fisch Script", "Ocean")

-- Debug: Check if UI was created
task.spawn(function()
    task.wait(1)
    print("=== Fisch UI Debug Info ===")
    print("LibName:", LibName)
    print("Library loaded:", library ~= nil)
    print("Window created:", Window ~= nil)
    
    -- Check CoreGui
    local coreGuiCount = 0
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            print("CoreGui:", gui.Name)
            coreGuiCount = coreGuiCount + 1
        end
    end
    print("Total CoreGui ScreenGuis:", coreGuiCount)
    
    -- Check PlayerGui  
    local playerGuiCount = 0
    for _, gui in pairs(lp.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            print("PlayerGui:", gui.Name)
            playerGuiCount = playerGuiCount + 1
        end
    end
    print("Total PlayerGui ScreenGuis:", playerGuiCount)
    print("=========================")
end)

-- Alternative minimize button approach - add directly after window creation
task.spawn(function()
    task.wait(0.5)
    
    -- Create standalone minimize button if Kavo method fails
    local screenGui = lp.PlayerGui:FindFirstChild("ScreenGui") or game.CoreGui:FindFirstChild("ScreenGui")
    
    if not screenGui then
        -- Create our own minimize button GUI
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FischMinimize"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local minimizeFrame = Instance.new("Frame")
        minimizeFrame.Name = "MinimizeFrame"
        minimizeFrame.Size = UDim2.new(0, 120, 0, 30)
        minimizeFrame.Position = UDim2.new(1, -140, 0, 10)
        minimizeFrame.BackgroundColor3 = Color3.fromRGB(26, 32, 58)
        minimizeFrame.BorderSizePixel = 0
        minimizeFrame.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = minimizeFrame
        
        local minimizeBtn = Instance.new("TextButton")
        minimizeBtn.Name = "MinimizeButton"
        minimizeBtn.Size = UDim2.new(1, 0, 1, 0)
        minimizeBtn.Position = UDim2.new(0, 0, 0, 0)
        minimizeBtn.BackgroundTransparency = 1
        minimizeBtn.Text = "— Minimize Fisch UI"
        minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        minimizeBtn.TextSize = 12
        minimizeBtn.Font = Enum.Font.SourceSansBold
        minimizeBtn.Parent = minimizeFrame
        
        -- Minimize functionality
        minimizeBtn.MouseButton1Click:Connect(function()
            -- Hide any visible Fisch UI
            for _, gui in pairs(game.CoreGui:GetChildren()) do
                if gui.Name:find("Fisch") or gui.Name:find("Kavo") or gui.Name == LibName then
                    gui.Enabled = false
                end
            end
            for _, gui in pairs(lp.PlayerGui:GetChildren()) do
                if gui.Name:find("Fisch") or gui.Name:find("Kavo") or gui.Name == LibName then
                    gui.Enabled = false
                end
            end
            
            minimizeFrame.Visible = false
            isMinimized = true
            createFloatingButton()
            print("UI minimized via standalone button")
        end)
        
        -- Hover effects
        minimizeBtn.MouseEnter:Connect(function()
            minimizeFrame.BackgroundColor3 = Color3.fromRGB(46, 52, 78)
        end)
        
        minimizeBtn.MouseLeave:Connect(function()
            minimizeFrame.BackgroundColor3 = Color3.fromRGB(26, 32, 58)
        end)
        
        -- Add to PlayerGui
        screenGui.Parent = lp.PlayerGui
        print("Standalone minimize button created")
    end
end)

-- Add dragging functionality and minimize button after UI loads
task.spawn(function()
    task.wait(1) -- Wait for UI to fully load
    
    -- Add dragging functionality
    local gui = game.CoreGui:FindFirstChild(LibName) or lp.PlayerGui:FindFirstChild(LibName)
    if gui then
        local mainFrame = gui:FindFirstChild("Main")
        local header = mainFrame and mainFrame:FindFirstChild("MainHeader")
        
        if mainFrame and header then
            -- Enable dragging using Kavo's built-in dragging if available
            if library and library.DraggingEnabled then
                pcall(function()
                    library:DraggingEnabled(header, mainFrame)
                end)
            else
                -- Custom dragging implementation
                local dragging = false
                local dragInput = nil
                local dragStart = nil
                local startPos = nil
                
                header.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        dragStart = input.Position
                        startPos = mainFrame.Position
                        
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                    end
                end)
                
                header.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        dragInput = input
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if input == dragInput and dragging then
                        local delta = input.Position - dragStart
                        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    end
                end)
            end
        end
    end
    
    -- Add minimize button
    addMinimizeButton()
end)

-- Create Tabs
local AutoTab = Window:NewTab("🎣 Automation")
local ModTab = Window:NewTab("⚙️ Modifications") 
local TeleTab = Window:NewTab("🌍 Teleports")
local VisualTab = Window:NewTab("👁️ Visuals")

-- Automation Section
local AutoSection = AutoTab:NewSection("Autofarm")
AutoSection:NewToggle("Freeze Character", "Freeze your character in place", function(state)
    flags['freezechar'] = state
end)
AutoSection:NewDropdown("Freeze Character Mode", "Select freeze mode", {"Rod Equipped", "Toggled"}, function(currentOption)
    flags['freezecharmode'] = currentOption
end)

local CastSection = AutoTab:NewSection("Auto Cast Settings")
CastSection:NewToggle("Auto Cast", "Automatically cast fishing rod", function(state)
    flags['autocast'] = state
end)
CastSection:NewSlider("Auto Cast Delay", "Delay between auto casts (seconds)", 0.1, 5, 0.5, function(value)
    flags['autocastdelay'] = value
end)

local ShakeSection = AutoTab:NewSection("Auto Shake Settings")
ShakeSection:NewToggle("Auto Shake", "Automatically shake when fish bites", function(state)
    flags['autoshake'] = state
end)

local ReelSection = AutoTab:NewSection("Auto Reel Settings") 
ReelSection:NewToggle("Auto Reel", "Automatically reel in fish", function(state)
    flags['autoreel'] = state
end)
ReelSection:NewSlider("Auto Reel Delay", "Delay between auto reels (seconds)", 0.1, 5, 0.5, function(value)
    flags['autoreeldelay'] = value
end)

-- Modifications Section
if CheckFunc(hookmetamethod) then
    local HookSection = ModTab:NewSection("Hooks")
    HookSection:NewToggle("No AFK Text", "Remove AFK notifications", function(state)
        flags['noafk'] = state
    end)
    HookSection:NewToggle("Perfect Cast", "Always get perfect cast", function(state)
        flags['perfectcast'] = state
    end)
    HookSection:NewToggle("Always Catch", "Always catch fish", function(state)
        flags['alwayscatch'] = state
    end)
end

local ClientSection = ModTab:NewSection("Client")
ClientSection:NewToggle("Infinite Oxygen", "Never run out of oxygen", function(state)
    flags['infoxygen'] = state
end)
ClientSection:NewToggle("No Temp & Oxygen", "Disable temperature and oxygen systems", function(state)
    flags['nopeakssystems'] = state
end)

-- Teleports Section
local LocationSection = TeleTab:NewSection("Locations")
LocationSection:NewDropdown("Select Zone", "Choose a zone to teleport to", ZoneNames, function(currentOption)
    flags['zones'] = currentOption
end)
LocationSection:NewButton("Teleport To Zone", "Teleport to selected zone", function()
    if flags['zones'] then
        gethrp().CFrame = TeleportLocations['Zones'][flags['zones']]
    end
end)

local RodSection = TeleTab:NewSection("Rod Locations")
RodSection:NewDropdown("Rod Locations", "Choose a rod location", RodNames, function(currentOption)
    flags['rodlocations'] = currentOption
end)
RodSection:NewButton("Teleport To Rod", "Teleport to selected rod location", function()
    if flags['rodlocations'] then
        gethrp().CFrame = TeleportLocations['Rods'][flags['rodlocations']]
    end
end)

local ItemSection = TeleTab:NewSection("Items & Tools")
ItemSection:NewDropdown("Select Item", "Choose an item location", ItemNames, function(currentOption)
    flags['items'] = currentOption
end)
ItemSection:NewButton("Teleport To Item", "Teleport to selected item", function()
    if flags['items'] then
        gethrp().CFrame = TeleportLocations['Items'][flags['items']]
    end
end)

local FishSection = TeleTab:NewSection("Fishing Spots")
FishSection:NewDropdown("Select Fishing Spot", "Choose a fishing spot", FishingSpotNames, function(currentOption)
    flags['fishingspots'] = currentOption
end)
FishSection:NewButton("Teleport To Fishing Spot", "Teleport to selected fishing spot", function()
    if flags['fishingspots'] then
        gethrp().CFrame = TeleportLocations['Fishing Spots'][flags['fishingspots']]
    end
end)

local NPCSection = TeleTab:NewSection("NPCs")
NPCSection:NewDropdown("Select NPC", "Choose an NPC location", NPCNames, function(currentOption)
    flags['npcs'] = currentOption
end)
NPCSection:NewButton("Teleport To NPC", "Teleport to selected NPC", function()
    if flags['npcs'] then
        gethrp().CFrame = TeleportLocations['NPCs'][flags['npcs']]
    end
end)

-- Visuals Section
local RodSection = VisualTab:NewSection("Rod")
RodSection:NewToggle("Body Rod Chams", "Apply chams to body rod", function(state)
    flags['bodyrodchams'] = state
end)
RodSection:NewToggle("Rod Chams", "Apply chams to equipped rod", function(state)
    flags['rodchams'] = state
end)
RodSection:NewDropdown("Material", "Select rod material", {"ForceField", "Neon"}, function(currentOption)
    flags['rodmaterial'] = currentOption
end)

local FishSection = VisualTab:NewSection("Fish Abundance")
FishSection:NewToggle("Free Fish Radar", "Show fish abundance zones", function(state)
    flags['fishabundance'] = state
end)

-- Add keybind to toggle UI
UserInputService.InputBegan:Connect(function(key, gameProcessed)
    if gameProcessed then return end
    if key.KeyCode == Enum.KeyCode.RightControl then
        if game.CoreGui:FindFirstChild(LibName) then
            local gui = game.CoreGui[LibName]
            if gui.Enabled then
                gui.Enabled = false
                isMinimized = true
                createFloatingButton()
            else
                gui.Enabled = true
                isMinimized = false
                if floatingButton then
                    floatingButton:Destroy()
                    floatingButton = nil
                end
            end
        elseif lp.PlayerGui:FindFirstChild(LibName) then
            local gui = lp.PlayerGui[LibName]
            if gui.Enabled then
                gui.Enabled = false
                isMinimized = true
                createFloatingButton()
            else
                gui.Enabled = true
                isMinimized = false
                if floatingButton then
                    floatingButton:Destroy()
                    floatingButton = nil
                end
            end
        end
    end
end)

--// Loops
RunService.Heartbeat:Connect(function()
    -- Autofarm
    if flags['freezechar'] then
        if flags['freezecharmode'] == 'Toggled' then
            if characterposition == nil then
                characterposition = gethrp().CFrame
            else
                gethrp().CFrame = characterposition
            end
        elseif flags['freezecharmode'] == 'Rod Equipped' then
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
    if flags['autoshake'] then
        if FindChild(lp.PlayerGui, 'shakeui') and FindChild(lp.PlayerGui['shakeui'], 'safezone') and FindChild(lp.PlayerGui['shakeui']['safezone'], 'button') then
            GuiService.SelectedObject = lp.PlayerGui['shakeui']['safezone']['button']
            if GuiService.SelectedObject == lp.PlayerGui['shakeui']['safezone']['button'] then
                game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end
    if flags['autocast'] then
        local rod = FindRod()
        if rod ~= nil and rod['values']['lure'].Value <= .001 and task.wait(flags['autocastdelay'] or 0.5) then
            rod.events.cast:FireServer(100, 1)
        end
    end
    if flags['autoreel'] then
        local rod = FindRod()
        if rod ~= nil and rod['values']['lure'].Value == 100 and task.wait(flags['autoreeldelay'] or 0.5) then
            ReplicatedStorage.events.reelfinished:FireServer(100, true)
        end
    end

    -- Visuals
    if flags['rodchams'] then
        local rod = FindRod()
        if rod ~= nil and FindChild(rod, 'Details') then
            local rodColor = flags['rodcolor'] or Color3.new(1, 0, 0)
            local rodMaterial = flags['rodmaterial'] or 'ForceField'
            for i,v in pairs(rod.Details:GetChildren()) do
                if v.ClassName == 'MeshPart' then
                    v.Color = rodColor
                    v.Material = rodMaterial
                end
            end
        end
    elseif not flags['rodchams'] then
        local rod = FindRod()
        if rod ~= nil and FindChild(rod, 'Details') then
            for i,v in pairs(rod.Details:GetChildren()) do
                if v.ClassName == 'MeshPart' then
                    v.Color = Color3.fromRGB(139, 138, 133)
                    v.Material = 'Metal'
                end
            end
        end
    end
    if flags['bodyrodchams'] then
        for i,v in pairs(getchar():GetChildren()) do
            if v:IsA('Tool') and FindChild(v, 'Details') then
                local rodColor = flags['rodcolor'] or Color3.new(1, 0, 0)
                local rodMaterial = flags['rodmaterial'] or 'ForceField'
                for x,z in pairs(v.Details:GetChildren()) do
                    if z.ClassName == 'MeshPart' then
                        z.Color = rodColor
                        z.Material = rodMaterial
                    end
                end
            end
        end
    elseif not flags['bodyrodchams'] then
        for i,v in pairs(getchar():GetChildren()) do
            if v:IsA('Tool') and FindChild(v, 'Details') then
                for x,z in pairs(v.Details:GetChildren()) do
                    if z.ClassName == 'MeshPart' then
                        z.Color = Color3.fromRGB(139, 138, 133)
                        z.Material = 'Metal'
                    end
                end
            end
        end
    end
    if flags['fishabundance'] then
        if FindChild(lp.PlayerGui, 'FishDetect') then
            lp.PlayerGui.FishDetect.Enabled = true
            fishabundancevisible = true
        end
    else
        if FindChild(lp.PlayerGui, 'FishDetect') then
            lp.PlayerGui.FishDetect.Enabled = false
            fishabundancevisible = false
        end
    end

    -- Modifications
    if flags['infoxygen'] then
        if FindChild(lp.PlayerGui, 'oxygen') and FindChild(lp.PlayerGui['oxygen'], 'overlay') then
            lp.PlayerGui.oxygen.overlay.Visible = false
        end
    else
        if FindChild(lp.PlayerGui, 'oxygen') and FindChild(lp.PlayerGui['oxygen'], 'overlay') then
            lp.PlayerGui.oxygen.overlay.Visible = true
        end
    end
    if flags['nopeakssystems'] then
        getchar():SetAttribute('Refill', true)
    else
        getchar():SetAttribute('Refill', false)
    end
end)

--// Hooks
if CheckFunc(hookmetamethod) then
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if flags['noafk'] and method == 'kick' then
            return
        end
        
        if flags['perfectcast'] and method == 'FireServer' and tostring(self) == 'cast' then
            args[1] = 100
            args[2] = 1
        end
        
        if flags['alwayscatch'] and method == 'FireServer' and tostring(self) == 'reelfinished' then
            args[1] = 100
            args[2] = true
        end
        
        return old(self, unpack(args))
    end)
end
