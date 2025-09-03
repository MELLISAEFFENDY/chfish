--[[
    FISCH Script dengan UI Sederhana
    Integrated ReGui - No external loading needed
]]

--// Services
local Players = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RunService = cloneref(game:GetService('RunService'))
local GuiService = cloneref(game:GetService('GuiService'))
local TweenService = cloneref(game:GetService('TweenService'))
local UserInputService = cloneref(game:GetService('UserInputService'))

--// Variables
local flags = {}
local characterposition
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")
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
    }
}

local ZoneNames = {}
local RodNames = {}
local ItemNames = {}

for i,v in pairs(TeleportLocations['Zones']) do table.insert(ZoneNames, i) end
for i,v in pairs(TeleportLocations['Rods']) do table.insert(RodNames, i) end
for i,v in pairs(TeleportLocations['Items']) do table.insert(ItemNames, i) end

--// Helper Functions
local function getchar()
    return lp.Character or lp.CharacterAdded:Wait()
end

local function gethrp()
    return getchar():WaitForChild('HumanoidRootPart')
end

local function FindRod()
    if getchar():FindFirstChildOfClass('Tool') and getchar():FindFirstChildOfClass('Tool'):FindFirstChild('values') then
        return getchar():FindFirstChildOfClass('Tool')
    else
        return nil
    end
end

local function message(text, time)
    if tooltipmessage then tooltipmessage:Remove() end
    tooltipmessage = require(lp.PlayerGui:WaitForChild("GeneralUIModule")):GiveToolTip(lp, text)
    task.spawn(function()
        task.wait(time)
        if tooltipmessage then tooltipmessage:Remove(); tooltipmessage = nil end
    end)
end

--// Create Simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FISCHScript"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Colors
local Colors = {
    Primary = Color3.fromRGB(35, 35, 40),
    Secondary = Color3.fromRGB(45, 45, 50),
    Accent = Color3.fromRGB(0, 162, 255),
    AccentHover = Color3.fromRGB(30, 180, 255),
    Success = Color3.fromRGB(76, 175, 80),
    Warning = Color3.fromRGB(255, 193, 7),
    Error = Color3.fromRGB(244, 67, 54),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Background = Color3.fromRGB(25, 25, 30),
    Border = Color3.fromRGB(60, 60, 65)
}

-- Floating Button
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Parent = ScreenGui
FloatingButton.Size = UDim2.fromOffset(60, 60)
FloatingButton.Position = UDim2.new(0, 20, 0.5, -30)
FloatingButton.BackgroundColor3 = Colors.Accent
FloatingButton.BorderSizePixel = 0
FloatingButton.Text = "🎣"
FloatingButton.TextColor3 = Colors.Text
FloatingButton.TextSize = 20
FloatingButton.Font = Enum.Font.SourceSansBold
FloatingButton.ZIndex = 1000

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0, 30)
FloatingCorner.Parent = FloatingButton

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.fromOffset(500, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Colors.Primary
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Colors.Secondary
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleCover = Instance.new("Frame")
TitleCover.Parent = TitleBar
TitleCover.Size = UDim2.new(1, 0, 0, 10)
TitleCover.Position = UDim2.new(0, 0, 1, -10)
TitleCover.BackgroundColor3 = Colors.Secondary
TitleCover.BorderSizePixel = 0

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.fromOffset(15, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "FISCH Script"
TitleText.TextColor3 = Colors.Text
TitleText.TextSize = 16
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.Size = UDim2.fromOffset(30, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Colors.Error
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Colors.Text
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.SourceSansBold

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = TitleBar
MinimizeButton.Size = UDim2.fromOffset(30, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = Colors.Warning
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "─"
MinimizeButton.TextColor3 = Colors.Text
MinimizeButton.TextSize = 14
MinimizeButton.Font = Enum.Font.SourceSansBold

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 5)
MinimizeCorner.Parent = MinimizeButton

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Colors.Background
TabContainer.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 5)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabContainer
TabPadding.PaddingLeft = UDim.new(0, 10)

-- Content Area
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -20, 1, -100)
ContentArea.Position = UDim2.fromOffset(10, 80)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ScrollBarThickness = 8
ContentArea.ScrollBarImageColor3 = Colors.Accent
ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentArea
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)

-- Tab System
local Tabs = {}
local CurrentTab = nil
local isMinimized = false

-- Window Functions
local function ShowWindow()
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(500, 600)}):Play()
end

local function HideWindow()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
    end)
end

local function MinimizeWindow()
    if not isMinimized then
        isMinimized = true
        MinimizeButton.Text = "□"
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 500, 0, 40)}):Play()
    else
        isMinimized = false
        MinimizeButton.Text = "─"
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(500, 600)}):Play()
    end
end

-- Button Events
CloseButton.MouseButton1Click:Connect(HideWindow)
MinimizeButton.MouseButton1Click:Connect(MinimizeWindow)
FloatingButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then HideWindow() else ShowWindow() end
end)

-- Dragging
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Create Tab Function
local function CreateTab(name)
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabContainer
    TabButton.Size = UDim2.fromOffset(100, 30)
    TabButton.BackgroundColor3 = Colors.Secondary
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.TextColor3 = Colors.TextSecondary
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.SourceSans
    
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 5)
    TabButtonCorner.Parent = TabButton
    
    -- Tab Content
    local TabContent = Instance.new("Frame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentArea
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    
    local TabContentLayout = Instance.new("UIListLayout")
    TabContentLayout.Parent = TabContent
    TabContentLayout.Padding = UDim.new(0, 8)
    TabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.Size = UDim2.new(1, 0, 0, TabContentLayout.AbsoluteContentSize.Y)
    end)
    
    -- Tab Switching
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = Colors.Secondary
            tab.Button.TextColor3 = Colors.TextSecondary
        end
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Colors.Accent
        TabButton.TextColor3 = Colors.Text
        CurrentTab = name
    end)
    
    local tab = {
        Button = TabButton,
        Content = TabContent,
        Layout = TabContentLayout
    }
    
    Tabs[name] = tab
    
    -- Auto-select first tab
    if CurrentTab == nil then
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Colors.Accent
        TabButton.TextColor3 = Colors.Text
        CurrentTab = name
    end
    
    return tab
end

-- Component Creation Functions
local function CreateHeader(parent, title)
    local Header = Instance.new("Frame")
    Header.Parent = parent
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundColor3 = Colors.Secondary
    Header.BorderSizePixel = 0
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 5)
    HeaderCorner.Parent = Header
    
    local HeaderText = Instance.new("TextLabel")
    HeaderText.Parent = Header
    HeaderText.Size = UDim2.new(1, -20, 1, 0)
    HeaderText.Position = UDim2.fromOffset(10, 0)
    HeaderText.BackgroundTransparency = 1
    HeaderText.Text = title
    HeaderText.TextColor3 = Colors.Text
    HeaderText.TextSize = 14
    HeaderText.Font = Enum.Font.SourceSansBold
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    
    return Header
end

local function CreateCheckbox(parent, label, defaultValue, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.Size = UDim2.new(1, 0, 0, 25)
    Frame.BackgroundTransparency = 1
    
    local Checkbox = Instance.new("TextButton")
    Checkbox.Parent = Frame
    Checkbox.Size = UDim2.fromOffset(20, 20)
    Checkbox.Position = UDim2.new(0, 0, 0.5, -10)
    Checkbox.BackgroundColor3 = defaultValue and Colors.Accent or Colors.Background
    Checkbox.BorderSizePixel = 1
    Checkbox.BorderColor3 = Colors.Border
    Checkbox.Text = defaultValue and "✓" or ""
    Checkbox.TextColor3 = Colors.Text
    Checkbox.TextSize = 12
    Checkbox.Font = Enum.Font.SourceSansBold
    
    local CheckboxCorner = Instance.new("UICorner")
    CheckboxCorner.CornerRadius = UDim.new(0, 3)
    CheckboxCorner.Parent = Checkbox
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.Position = UDim2.fromOffset(25, 0)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Colors.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local checked = defaultValue or false
    Checkbox.MouseButton1Click:Connect(function()
        checked = not checked
        Checkbox.BackgroundColor3 = checked and Colors.Accent or Colors.Background
        Checkbox.Text = checked and "✓" or ""
        if callback then callback(checked) end
    end)
    
    return Frame
end

local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.BackgroundColor3 = Colors.Accent
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Colors.Text
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSansBold
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Colors.AccentHover}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Colors.Accent}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return Button
end

local function CreateDropdown(parent, label, items, selected, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Colors.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Dropdown = Instance.new("TextButton")
    Dropdown.Parent = Frame
    Dropdown.Size = UDim2.new(1, 0, 0, 25)
    Dropdown.Position = UDim2.new(0, 0, 0, 25)
    Dropdown.BackgroundColor3 = Colors.Secondary
    Dropdown.BorderSizePixel = 0
    Dropdown.Text = selected or (items and items[1]) or "Select..."
    Dropdown.TextColor3 = Colors.Text
    Dropdown.TextSize = 12
    Dropdown.Font = Enum.Font.SourceSans
    Dropdown.TextXAlignment = Enum.TextXAlignment.Left
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 5)
    DropdownCorner.Parent = Dropdown
    
    local DropdownPadding = Instance.new("UIPadding")
    DropdownPadding.PaddingLeft = UDim.new(0, 10)
    DropdownPadding.Parent = Dropdown
    
    Dropdown.MouseButton1Click:Connect(function()
        if callback then callback(Dropdown.Text) end
    end)
    
    return Frame
end

--// Create Tabs and Content
local AutomationTab = CreateTab("Automation")
local ModificationsTab = CreateTab("Modifications") 
local TeleportsTab = CreateTab("Teleports")
local VisualsTab = CreateTab("Visuals")

-- Automation Content
CreateHeader(AutomationTab.Content, "Autofarm")
CreateCheckbox(AutomationTab.Content, "Freeze Character", false, function(value) flags.freezechar = value end)
CreateCheckbox(AutomationTab.Content, "Auto Cast", false, function(value) flags.autocast = value end)
CreateCheckbox(AutomationTab.Content, "Auto Shake", false, function(value) flags.autoshake = value end)
CreateCheckbox(AutomationTab.Content, "Auto Reel", false, function(value) flags.autoreel = value end)

-- Modifications Content
CreateHeader(ModificationsTab.Content, "Client Modifications")
CreateCheckbox(ModificationsTab.Content, "Infinite Oxygen", false, function(value) flags.infoxygen = value end)
CreateCheckbox(ModificationsTab.Content, "No Temperature & Oxygen", false, function(value) flags.nopeakssystems = value end)

-- Teleports Content
CreateHeader(TeleportsTab.Content, "Locations")
CreateDropdown(TeleportsTab.Content, "Select Zone", ZoneNames, ZoneNames[1], function(value) flags.selectedzone = value end)
CreateButton(TeleportsTab.Content, "Teleport To Zone", function()
    if flags.selectedzone and TeleportLocations['Zones'][flags.selectedzone] then
        gethrp().CFrame = TeleportLocations['Zones'][flags.selectedzone]
        message('Teleported to ' .. flags.selectedzone, 3)
    end
end)

CreateHeader(TeleportsTab.Content, "Rods & Equipment")
CreateDropdown(TeleportsTab.Content, "Select Rod", RodNames, RodNames[1], function(value) flags.selectedrod = value end)
CreateButton(TeleportsTab.Content, "Teleport To Rod", function()
    if flags.selectedrod and TeleportLocations['Rods'][flags.selectedrod] then
        gethrp().CFrame = TeleportLocations['Rods'][flags.selectedrod]
        message('Teleported to ' .. flags.selectedrod, 3)
    end
end)

-- Visuals Content
CreateHeader(VisualsTab.Content, "Rod Visuals")
CreateCheckbox(VisualsTab.Content, "Rod Chams", false, function(value) flags.rodchams = value end)

CreateHeader(VisualsTab.Content, "Fish Radar")
CreateCheckbox(VisualsTab.Content, "Show Fish Abundance", false, function(value) flags.fishabundance = value end)

print("✅ FISCH Script loaded successfully!")
print("✅ UI created with all tabs and content!")
print("🎣 Click the floating button to open/close the GUI")

-- Set default selected items
flags.selectedzone = ZoneNames[1]
flags.selectedrod = RodNames[1]

--// Main Loop
RunService.Heartbeat:Connect(function()
    -- Character Freezing
    if flags.freezechar then
        if characterposition == nil then
            characterposition = gethrp().CFrame
        else
            gethrp().CFrame = characterposition
        end
    else
        characterposition = nil
    end
    
    -- Auto Shake
    if flags.autoshake then
        local shakeUI = lp.PlayerGui:FindFirstChild('shakeui')
        if shakeUI then
            local safeZone = shakeUI:FindFirstChild('safezone')
            if safeZone then
                local button = safeZone:FindFirstChild('button')
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
        if rod and rod:FindFirstChild('handle') then
            rod.handle.Color = Color3.fromRGB(100, 100, 255)
            rod.handle.Material = Enum.Material.ForceField
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
                local abundance = zone:FindFirstChild('Abundance')
                if abundance and abundance.ClassName == 'StringValue' then
                    local radar1 = zone:FindFirstChild('radar1')
                    local radar2 = zone:FindFirstChild('radar2')
                    if radar1 and radar1.ClassName == 'BillboardGui' then radar1.Enabled = true end
                    if radar2 and radar2.ClassName == 'BillboardGui' then radar2.Enabled = true end
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
                local abundance = zone:FindFirstChild('Abundance')
                if abundance and abundance.ClassName == 'StringValue' then
                    local radar1 = zone:FindFirstChild('radar1')
                    local radar2 = zone:FindFirstChild('radar2')
                    if radar1 and radar1.ClassName == 'BillboardGui' then radar1.Enabled = false end
                    if radar2 and radar2.ClassName == 'BillboardGui' then radar2.Enabled = false end
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
