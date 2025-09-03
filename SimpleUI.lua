-- Simple UI Library for FISCH Script
-- Created by MELLISAEFFENDY
-- User-friendly and compatible with all executors

local SimpleUI = {}
SimpleUI.__index = SimpleUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- UI Creation Functions
function SimpleUI.new()
    local self = setmetatable({}, SimpleUI)
    self.gui = nil
    self.tabs = {}
    self.currentTab = nil
    return self
end

function SimpleUI:CreateMainGui(title)
    title = title or "FISCH Script"
    
    -- Remove existing GUI if it exists
    local existing = PlayerGui:FindFirstChild("FischScriptGUI")
    if existing then
        existing:Destroy()
    end
    
    -- Create main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FischScriptGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 45)
    tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.Parent = tabContainer
    
    -- Content frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -10, 1, -90)
    contentFrame.Position = UDim2.new(0, 5, 0, 85)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    contentFrame.Parent = mainFrame
    
    -- Auto resize canvas
    local function updateCanvasSize()
        local layout = contentFrame:FindFirstChild("UIListLayout")
        if layout then
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end
    end
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = contentFrame
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    self.gui = screenGui
    self.mainFrame = mainFrame
    self.tabContainer = tabContainer
    self.contentFrame = contentFrame
    
    return self
end

function SimpleUI:CreateTab(name)
    local tab = {
        name = name,
        button = nil,
        content = nil,
        elements = {}
    }
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.BorderSizePixel = 0
    tabButton.Parent = self.tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tabButton
    
    -- Create tab content
    local tabContent = Instance.new("Frame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = self.contentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = tabContent
    
    tab.button = tabButton
    tab.content = tabContent
    
    -- Tab switching
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    self.tabs[name] = tab
    
    -- Auto select first tab
    if #self.tabs == 1 then
        self:SwitchTab(name)
    end
    
    return tab
end

function SimpleUI:SwitchTab(tabName)
    for name, tab in pairs(self.tabs) do
        if name == tabName then
            tab.button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            tab.button.TextColor3 = Color3.fromRGB(255, 255, 255)
            tab.content.Visible = true
            self.currentTab = tab
        else
            tab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
            tab.content.Visible = false
        end
    end
end

function SimpleUI:AddSection(tab, title)
    local section = Instance.new("Frame")
    section.Name = title .. "Section"
    section.Size = UDim2.new(1, 0, 0, 25)
    section.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    section.BorderSizePixel = 0
    section.Parent = tab.content
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 4)
    sectionCorner.Parent = section
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 10, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = title
    sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionLabel.TextSize = 14
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.Parent = section
    
    return section
end

function SimpleUI:AddToggle(tab, text, defaultValue, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = text .. "Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 35)
    toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    toggle.BorderSizePixel = 0
    toggle.Parent = tab.content
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggle
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -60, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 13
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggle
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -45, 0.5, -10)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(85, 170, 85) or Color3.fromRGB(85, 85, 85)
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 10
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggle
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = toggleButton
    
    local value = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        value = not value
        toggleButton.BackgroundColor3 = value and Color3.fromRGB(85, 170, 85) or Color3.fromRGB(85, 85, 85)
        toggleButton.Text = value and "ON" or "OFF"
        
        if callback then
            callback(value)
        end
    end)
    
    return toggle
end

function SimpleUI:AddButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = tab.content
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        -- Button animation
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 100, 180)})
        tween:Play()
        tween.Completed:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 120, 200)}):Play()
        end)
        
        if callback then
            callback()
        end
    end)
    
    return button
end

function SimpleUI:AddSlider(tab, text, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Name = text .. "Slider"
    slider.Size = UDim2.new(1, 0, 0, 50)
    slider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    slider.BorderSizePixel = 0
    slider.Parent = tab.content
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -10, 0, 20)
    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ": " .. default
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 13
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = slider
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 0, 30)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = slider
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 3)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    local value = default
    local dragging = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        sliderLabel.Text = text .. ": " .. value
        
        if callback then
            callback(value)
        end
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    sliderBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return slider
end

function SimpleUI:AddDropdown(tab, text, options, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Name = text .. "Dropdown"
    dropdown.Size = UDim2.new(1, 0, 0, 35)
    dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    dropdown.BorderSizePixel = 0
    dropdown.ClipsDescendants = true
    dropdown.Parent = tab.content
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdown
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 0, 35)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = text .. ": " .. (options[1] or "None")
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 13
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdown
    
    local dropdownIcon = Instance.new("TextLabel")
    dropdownIcon.Size = UDim2.new(0, 20, 1, 0)
    dropdownIcon.Position = UDim2.new(1, -25, 0, 0)
    dropdownIcon.BackgroundTransparency = 1
    dropdownIcon.Text = "▼"
    dropdownIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
    dropdownIcon.TextSize = 12
    dropdownIcon.Font = Enum.Font.Gotham
    dropdownIcon.Parent = dropdown
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1, 0, 0, #options * 25)
    optionsFrame.Position = UDim2.new(0, 0, 0, 35)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.Parent = dropdown
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsFrame
    
    local expanded = false
    local selectedOption = options[1] or "None"
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 12
        optionButton.Font = Enum.Font.Gotham
        optionButton.BorderSizePixel = 0
        optionButton.Parent = optionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            dropdownButton.Text = text .. ": " .. option
            expanded = false
            dropdown.Size = UDim2.new(1, 0, 0, 35)
            optionsFrame.Visible = false
            dropdownIcon.Text = "▼"
            
            if callback then
                callback(option)
            end
        end)
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            dropdown.Size = UDim2.new(1, 0, 0, 35 + #options * 25)
            optionsFrame.Visible = true
            dropdownIcon.Text = "▲"
        else
            dropdown.Size = UDim2.new(1, 0, 0, 35)
            optionsFrame.Visible = false
            dropdownIcon.Text = "▼"
        end
    end)
    
    return dropdown
end

return SimpleUI
