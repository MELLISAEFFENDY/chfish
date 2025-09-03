--[[
    ReGui - Modern UI Library for Roblox
    Enhanced with draggable windows, minimize functionality, and floating buttons
    Created for user-friendly experience
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ReGui = {}
ReGui.__index = ReGui

-- Color scheme and styling
local Colors = {
    Primary = Color3.fromRGB(45, 45, 50),
    Secondary = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(0, 162, 255),
    AccentHover = Color3.fromRGB(30, 180, 255),
    Success = Color3.fromRGB(76, 175, 80),
    Warning = Color3.fromRGB(255, 193, 7),
    Error = Color3.fromRGB(244, 67, 54),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(60, 60, 65),
    Background = Color3.fromRGB(25, 25, 30),
    Hover = Color3.fromRGB(55, 55, 60)
}

-- Utility functions
local function CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties or {}) do
        element[property] = value
    end
    return element
end

local function TweenElement(element, properties, duration, style, direction)
    local tween = TweenService:Create(
        element,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

-- Dragging functionality
local function MakeDraggable(element, dragHandle)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    dragHandle = dragHandle or element
    
    local function update(input)
        if dragging then
            local delta = input.Position - dragStart
            element.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = element.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
end

-- Initialize ReGui
function ReGui:Init()
    -- Create main ScreenGui
    self.ScreenGui = CreateElement("ScreenGui", {
        Name = "ReGuiLibrary",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Create floating button
    self:CreateFloatingButton()
    
    return self
end

-- Create floating button
function ReGui:CreateFloatingButton()
    local floatingButton = CreateElement("Frame", {
        Name = "FloatingButton",
        Parent = self.ScreenGui,
        Size = UDim2.fromOffset(60, 60),
        Position = UDim2.new(0, 20, 0.5, -30),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        ZIndex = 1000
    })
    
    -- Rounded corners
    local corner = CreateElement("UICorner", {
        Parent = floatingButton,
        CornerRadius = UDim.new(0, 30)
    })
    
    -- Shadow effect
    local shadow = CreateElement("Frame", {
        Name = "Shadow",
        Parent = floatingButton,
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.fromOffset(-3, -3),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        ZIndex = floatingButton.ZIndex - 1
    })
    
    CreateElement("UICorner", {
        Parent = shadow,
        CornerRadius = UDim.new(0, 33)
    })
    
    -- Icon
    local icon = CreateElement("TextLabel", {
        Parent = floatingButton,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "🎣",
        TextColor3 = Colors.Text,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        ZIndex = floatingButton.ZIndex + 1
    })
    
    -- Make draggable
    MakeDraggable(floatingButton, floatingButton)
    
    -- Hover effects
    floatingButton.MouseEnter:Connect(function()
        TweenElement(floatingButton, {
            Size = UDim2.fromOffset(65, 65),
            BackgroundColor3 = Colors.AccentHover
        }, 0.2)
    end)
    
    floatingButton.MouseLeave:Connect(function()
        TweenElement(floatingButton, {
            Size = UDim2.fromOffset(60, 60),
            BackgroundColor3 = Colors.Accent
        }, 0.2)
    end)
    
    -- Store reference
    self.FloatingButton = floatingButton
    
    return floatingButton
end

-- Create window
function ReGui:Window(config)
    local window = {}
    window.Tabs = {}
    window.CurrentTab = nil
    window.Minimized = false
    
    -- Create main frame
    local mainFrame = CreateElement("Frame", {
        Name = config.Title or "ReGuiWindow",
        Parent = self.ScreenGui,
        Size = config.Size or UDim2.fromOffset(450, 550),
        Position = UDim2.new(0.5, -225, 0.5, -275),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10
    })
    
    -- Rounded corners
    CreateElement("UICorner", {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Shadow
    local shadow = CreateElement("Frame", {
        Name = "Shadow",
        Parent = mainFrame,
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.fromOffset(-10, -10),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ZIndex = mainFrame.ZIndex - 1
    })
    
    CreateElement("UICorner", {
        Parent = shadow,
        CornerRadius = UDim.new(0, 22)
    })
    
    -- Title bar
    local titleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        ZIndex = mainFrame.ZIndex + 1
    })
    
    CreateElement("UICorner", {
        Parent = titleBar,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Title bar bottom cover
    local titleBarCover = CreateElement("Frame", {
        Parent = titleBar,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0
    })
    
    -- Title text
    local titleText = CreateElement("TextLabel", {
        Name = "Title",
        Parent = titleBar,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.fromOffset(15, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "ReGui Window",
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = titleBar.ZIndex + 1
    })
    
    -- Close button
    local closeButton = CreateElement("TextButton", {
        Name = "CloseButton",
        Parent = titleBar,
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Colors.Error,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Colors.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        ZIndex = titleBar.ZIndex + 1
    })
    
    CreateElement("UICorner", {
        Parent = closeButton,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Minimize button
    local minimizeButton = CreateElement("TextButton", {
        Name = "MinimizeButton",
        Parent = titleBar,
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -70, 0, 5),
        BackgroundColor3 = Colors.Warning,
        BorderSizePixel = 0,
        Text = "─",
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = titleBar.ZIndex + 1
    })
    
    CreateElement("UICorner", {
        Parent = minimizeButton,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Tab container
    local tabContainer = CreateElement("Frame", {
        Name = "TabContainer",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        ZIndex = mainFrame.ZIndex + 1
    })
    
    -- Tab list layout
    local tabLayout = CreateElement("UIListLayout", {
        Parent = tabContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 2)
    })
    
    -- Content frame
    local contentFrame = CreateElement("ScrollingFrame", {
        Name = "ContentFrame",
        Parent = mainFrame,
        Size = UDim2.new(1, -20, 1, -85),
        Position = UDim2.fromOffset(10, 75),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = mainFrame.ZIndex + 1
    })
    
    -- Content layout
    local contentLayout = CreateElement("UIListLayout", {
        Parent = contentFrame,
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 8)
    })
    
    -- Update canvas size automatically
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Make draggable
    MakeDraggable(mainFrame, titleBar)
    
    -- Window functions
    function window:Show()
        mainFrame.Visible = true
        TweenElement(mainFrame, {Size = config.Size or UDim2.fromOffset(450, 550)}, 0.3, Enum.EasingStyle.Back)
    end
    
    function window:Hide()
        TweenElement(mainFrame, {Size = UDim2.fromOffset(0, 0)}, 0.3, Enum.EasingStyle.Back):Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end
    
    function window:Minimize()
        if not window.Minimized then
            window.Minimized = true
            minimizeButton.Text = "□"
            local originalSize = mainFrame.Size
            window.OriginalSize = originalSize
            TweenElement(mainFrame, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)}, 0.3)
        else
            window.Minimized = false
            minimizeButton.Text = "─"
            TweenElement(mainFrame, {Size = window.OriginalSize}, 0.3)
        end
    end
    
    -- Button events
    closeButton.MouseButton1Click:Connect(function()
        window:Hide()
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        window:Minimize()
    end)
    
    -- Floating button click to show/hide window
    self.FloatingButton.MouseButton1Click:Connect(function()
        if mainFrame.Visible then
            window:Hide()
        else
            window:Show()
        end
    end)
    
    -- Button hover effects
    closeButton.MouseEnter:Connect(function()
        TweenElement(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenElement(closeButton, {BackgroundColor3 = Colors.Error}, 0.2)
    end)
    
    minimizeButton.MouseEnter:Connect(function()
        TweenElement(minimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 220, 50)}, 0.2)
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        TweenElement(minimizeButton, {BackgroundColor3 = Colors.Warning}, 0.2)
    end)
    
    -- Tab creation function
    function window:CreateTab(tabConfig)
        local tab = {}
        tab.Elements = {}
        
        -- Create tab button
        local tabButton = CreateElement("TextButton", {
            Name = tabConfig.Name,
            Parent = tabContainer,
            Size = UDim2.fromOffset(120, 30),
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Text = tabConfig.Name,
            TextColor3 = Colors.TextSecondary,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            ZIndex = tabContainer.ZIndex + 1
        })
        
        CreateElement("UICorner", {
            Parent = tabButton,
            CornerRadius = UDim.new(0, 6)
        })
        
        -- Create tab content
        local tabContent = CreateElement("Frame", {
            Name = tabConfig.Name .. "Content",
            Parent = contentFrame,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ZIndex = contentFrame.ZIndex + 1
        })
        
        local tabContentLayout = CreateElement("UIListLayout", {
            Parent = tabContent,
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Padding = UDim.new(0, 8)
        })
        
        -- Tab switching
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, existingTab in pairs(window.Tabs) do
                existingTab.Content.Visible = false
                existingTab.Button.BackgroundColor3 = Colors.Secondary
                existingTab.Button.TextColor3 = Colors.TextSecondary
            end
            
            -- Show current tab
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Colors.Accent
            tabButton.TextColor3 = Colors.Text
            window.CurrentTab = tab
        end)
        
        -- Tab hover effects
        tabButton.MouseEnter:Connect(function()
            if window.CurrentTab ~= tab then
                TweenElement(tabButton, {BackgroundColor3 = Colors.Hover}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if window.CurrentTab ~= tab then
                TweenElement(tabButton, {BackgroundColor3 = Colors.Secondary}, 0.2)
            end
        end)
        
        -- Store tab reference
        tab.Button = tabButton
        tab.Content = tabContent
        tab.Layout = tabContentLayout
        window.Tabs[tabConfig.Name] = tab
        
        -- Select first tab by default
        if #window.Tabs == 1 then
            tabButton.BackgroundColor3 = Colors.Accent
            tabButton.TextColor3 = Colors.Text
            tabContent.Visible = true
            window.CurrentTab = tab
        end
        
        -- Tab element creation functions
        function tab:CollapsingHeader(config)
            local header = CreateElement("Frame", {
                Name = "CollapsingHeader",
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                ZIndex = tabContent.ZIndex + 1
            })
            
            CreateElement("UICorner", {
                Parent = header,
                CornerRadius = UDim.new(0, 8)
            })
            
            local headerText = CreateElement("TextLabel", {
                Parent = header,
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.fromOffset(15, 0),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = header.ZIndex + 1
            })
            
            return header
        end
        
        function tab:Checkbox(config)
            local checkbox = CreateElement("Frame", {
                Name = "Checkbox",
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                ZIndex = tabContent.ZIndex + 1
            })
            
            local checkButton = CreateElement("TextButton", {
                Name = "CheckButton",
                Parent = checkbox,
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.new(0, 0, 0.5, -10),
                BackgroundColor3 = config.Value and Colors.Accent or Colors.Background,
                BorderColor3 = Colors.Border,
                BorderSizePixel = 1,
                Text = config.Value and "✓" or "",
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                ZIndex = checkbox.ZIndex + 1
            })
            
            CreateElement("UICorner", {
                Parent = checkButton,
                CornerRadius = UDim.new(0, 4)
            })
            
            local label = CreateElement("TextLabel", {
                Name = "Label",
                Parent = checkbox,
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.fromOffset(30, 0),
                BackgroundTransparency = 1,
                Text = config.Label,
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = checkbox.ZIndex + 1
            })
            
            local checked = config.Value or false
            
            checkButton.MouseButton1Click:Connect(function()
                checked = not checked
                checkButton.BackgroundColor3 = checked and Colors.Accent or Colors.Background
                checkButton.Text = checked and "✓" or ""
                
                if config.Callback then
                    config.Callback(checkbox, checked)
                end
            end)
            
            return checkbox
        end
        
        function tab:Button(config)
            local buttonFrame = CreateElement("Frame", {
                Name = "Button",
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                ZIndex = tabContent.ZIndex + 1
            })
            
            local button = CreateElement("TextButton", {
                Name = "ButtonElement",
                Parent = buttonFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Colors.Accent,
                BorderSizePixel = 0,
                Text = config.Text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                ZIndex = buttonFrame.ZIndex + 1
            })
            
            CreateElement("UICorner", {
                Parent = button,
                CornerRadius = UDim.new(0, 8)
            })
            
            button.MouseEnter:Connect(function()
                TweenElement(button, {BackgroundColor3 = Colors.AccentHover}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                TweenElement(button, {BackgroundColor3 = Colors.Accent}, 0.2)
            end)
            
            button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
            
            return buttonFrame
        end
        
        function tab:Combo(config)
            local comboFrame = CreateElement("Frame", {
                Name = "Combo",
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundTransparency = 1,
                ZIndex = tabContent.ZIndex + 1
            })
            
            local label = CreateElement("TextLabel", {
                Name = "Label",
                Parent = comboFrame,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = config.Label,
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = comboFrame.ZIndex + 1
            })
            
            local comboButton = CreateElement("TextButton", {
                Name = "ComboButton",
                Parent = comboFrame,
                Size = UDim2.new(1, 0, 0, 30),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Text = config.Selected or (config.Items and config.Items[1]) or "Select...",
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = comboFrame.ZIndex + 1
            })
            
            CreateElement("UICorner", {
                Parent = comboButton,
                CornerRadius = UDim.new(0, 6)
            })
            
            CreateElement("UIPadding", {
                Parent = comboButton,
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
            
            local dropdown = CreateElement("ScrollingFrame", {
                Name = "Dropdown",
                Parent = comboFrame,
                Size = UDim2.new(1, 0, 0, 120),
                Position = UDim2.new(0, 0, 0, 55),
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = Colors.Accent,
                Visible = false,
                ZIndex = comboFrame.ZIndex + 2
            })
            
            CreateElement("UICorner", {
                Parent = dropdown,
                CornerRadius = UDim.new(0, 6)
            })
            
            local dropdownLayout = CreateElement("UIListLayout", {
                Parent = dropdown,
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Padding = UDim.new(0, 2)
            })
            
            -- Populate dropdown
            if config.Items then
                for _, item in ipairs(config.Items) do
                    local itemButton = CreateElement("TextButton", {
                        Name = item,
                        Parent = dropdown,
                        Size = UDim2.new(1, 0, 0, 25),
                        BackgroundColor3 = Colors.Background,
                        BorderSizePixel = 0,
                        Text = item,
                        TextColor3 = Colors.Text,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = dropdown.ZIndex + 1
                    })
                    
                    CreateElement("UIPadding", {
                        Parent = itemButton,
                        PaddingLeft = UDim.new(0, 10)
                    })
                    
                    itemButton.MouseEnter:Connect(function()
                        itemButton.BackgroundColor3 = Colors.Hover
                    end)
                    
                    itemButton.MouseLeave:Connect(function()
                        itemButton.BackgroundColor3 = Colors.Background
                    end)
                    
                    itemButton.MouseButton1Click:Connect(function()
                        comboButton.Text = item
                        dropdown.Visible = false
                        comboFrame.Size = UDim2.new(1, 0, 0, 60)
                        
                        if config.Callback then
                            config.Callback(comboFrame, item)
                        end
                    end)
                end
                
                -- Update canvas size
                dropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdown.CanvasSize = UDim2.new(0, 0, 0, dropdownLayout.AbsoluteContentSize.Y + 10)
                end)
            end
            
            comboButton.MouseButton1Click:Connect(function()
                dropdown.Visible = not dropdown.Visible
                comboFrame.Size = dropdown.Visible and UDim2.new(1, 0, 0, 180) or UDim2.new(1, 0, 0, 60)
            end)
            
            return comboFrame
        end
        
        return tab
    end
    
    -- Store window reference
    window.Frame = mainFrame
    
    return window
end

return ReGui
