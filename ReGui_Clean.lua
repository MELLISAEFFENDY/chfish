--[[
    ReGui - Stable UI Library for FISCH Script
    Fixed layout issues and function indexing errors
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ReGui = {}

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

-- Utility functions
local function CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties or {}) do
        element[property] = value
    end
    return element
end

local function TweenElement(element, properties, duration)
    TweenService:Create(element, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad), properties):Play()
end

-- Dragging
local function MakeDraggable(frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Initialize
function ReGui.Init()
    ReGui.ScreenGui = CreateElement("ScreenGui", {
        Name = "ReGuiLibrary",
        Parent = PlayerGui,
        ResetOnSpawn = false
    })
    
    -- Floating button
    ReGui.FloatingButton = CreateElement("TextButton", {
        Name = "FloatingButton",
        Parent = ReGui.ScreenGui,
        Size = UDim2.fromOffset(60, 60),
        Position = UDim2.new(0, 20, 0.5, -30),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Text = "🎣",
        TextColor3 = Colors.Text,
        TextSize = 20,
        Font = Enum.Font.SourceSansBold,
        ZIndex = 1000
    })
    
    CreateElement("UICorner", {Parent = ReGui.FloatingButton, CornerRadius = UDim.new(0, 30)})
    MakeDraggable(ReGui.FloatingButton)
    
    ReGui.FloatingButton.MouseEnter:Connect(function()
        TweenElement(ReGui.FloatingButton, {BackgroundColor3 = Colors.AccentHover}, 0.2)
    end)
    
    ReGui.FloatingButton.MouseLeave:Connect(function()
        TweenElement(ReGui.FloatingButton, {BackgroundColor3 = Colors.Accent}, 0.2)
    end)
    
    return true
end

-- Window
function ReGui.Window(config)
    local window = {Tabs = {}, CurrentTab = nil, Minimized = false}
    
    -- Main frame
    local mainFrame = CreateElement("Frame", {
        Name = "MainWindow",
        Parent = ReGui.ScreenGui,
        Size = config.Size or UDim2.fromOffset(500, 600),
        Position = UDim2.new(0.5, -250, 0.5, -300),
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Visible = false
    })
    
    CreateElement("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0, 10)})
    
    -- Title bar
    local titleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0
    })
    
    CreateElement("UICorner", {Parent = titleBar, CornerRadius = UDim.new(0, 10)})
    CreateElement("Frame", {
        Parent = titleBar,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0
    })
    
    -- Title
    CreateElement("TextLabel", {
        Parent = titleBar,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.fromOffset(15, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Window",
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.SourceSansBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Close button
    local closeButton = CreateElement("TextButton", {
        Parent = titleBar,
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Colors.Error,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.SourceSansBold
    })
    
    CreateElement("UICorner", {Parent = closeButton, CornerRadius = UDim.new(0, 5)})
    
    -- Minimize button
    local minimizeButton = CreateElement("TextButton", {
        Parent = titleBar,
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -70, 0, 5),
        BackgroundColor3 = Colors.Warning,
        BorderSizePixel = 0,
        Text = "─",
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.SourceSansBold
    })
    
    CreateElement("UICorner", {Parent = minimizeButton, CornerRadius = UDim.new(0, 5)})
    
    -- Tab container
    local tabContainer = CreateElement("Frame", {
        Name = "TabContainer",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0
    })
    
    CreateElement("UIListLayout", {
        Parent = tabContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Left
    })
    
    CreateElement("UIPadding", {Parent = tabContainer, PaddingLeft = UDim.new(0, 10)})
    
    -- Content area
    local contentArea = CreateElement("ScrollingFrame", {
        Name = "ContentArea",
        Parent = mainFrame,
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.fromOffset(10, 80),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 8,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local contentLayout = CreateElement("UIListLayout", {
        Parent = contentArea,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Left
    })
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentArea.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    MakeDraggable(titleBar)
    
    -- Window functions
    function window:Show()
        mainFrame.Visible = true
        TweenElement(mainFrame, {Size = config.Size or UDim2.fromOffset(500, 600)}, 0.3)
    end
    
    function window:Hide()
        TweenElement(mainFrame, {Size = UDim2.fromOffset(0, 0)}, 0.3)
        wait(0.3)
        mainFrame.Visible = false
    end
    
    function window:Minimize()
        if not window.Minimized then
            window.Minimized = true
            window.OriginalSize = mainFrame.Size
            TweenElement(mainFrame, {Size = UDim2.new(window.OriginalSize.X.Scale, window.OriginalSize.X.Offset, 0, 40)}, 0.3)
            minimizeButton.Text = "□"
        else
            window.Minimized = false
            TweenElement(mainFrame, {Size = window.OriginalSize}, 0.3)
            minimizeButton.Text = "─"
        end
    end
    
    closeButton.MouseButton1Click:Connect(function() window:Hide() end)
    minimizeButton.MouseButton1Click:Connect(function() window:Minimize() end)
    
    ReGui.FloatingButton.MouseButton1Click:Connect(function()
        if mainFrame.Visible then window:Hide() else window:Show() end
    end)
    
    -- Create tab function
    function window:CreateTab(tabConfig)
        local tab = {}
        
        -- Tab button
        local tabButton = CreateElement("TextButton", {
            Parent = tabContainer,
            Size = UDim2.fromOffset(100, 30),
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Text = tabConfig.Name,
            TextColor3 = Colors.TextSecondary,
            TextSize = 14,
            Font = Enum.Font.SourceSans
        })
        
        CreateElement("UICorner", {Parent = tabButton, CornerRadius = UDim.new(0, 5)})
        
        -- Tab content
        local tabContent = CreateElement("Frame", {
            Parent = contentArea,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false
        })
        
        local tabLayout = CreateElement("UIListLayout", {
            Parent = tabContent,
            Padding = UDim.new(0, 8),
            HorizontalAlignment = Enum.HorizontalAlignment.Left
        })
        
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
        end)
        
        -- Tab switching
        tabButton.MouseButton1Click:Connect(function()
            for _, existingTab in pairs(window.Tabs) do
                existingTab.Content.Visible = false
                existingTab.Button.BackgroundColor3 = Colors.Secondary
                existingTab.Button.TextColor3 = Colors.TextSecondary
            end
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Colors.Accent
            tabButton.TextColor3 = Colors.Text
            window.CurrentTab = tab
        end)
        
        tab.Button = tabButton
        tab.Content = tabContent
        tab.Layout = tabLayout
        window.Tabs[tabConfig.Name] = tab
        
        -- Auto-select first tab
        if #window.Tabs == 1 then
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Colors.Accent
            tabButton.TextColor3 = Colors.Text
            window.CurrentTab = tab
        end
        
        -- Component functions
        function tab:CollapsingHeader(config)
            local header = CreateElement("Frame", {
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0
            })
            
            CreateElement("UICorner", {Parent = header, CornerRadius = UDim.new(0, 5)})
            
            CreateElement("TextLabel", {
                Parent = header,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.SourceSansBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return header
        end
        
        function tab:Checkbox(config)
            local frame = CreateElement("Frame", {
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1
            })
            
            local checkbox = CreateElement("TextButton", {
                Parent = frame,
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.new(0, 0, 0.5, -10),
                BackgroundColor3 = config.Value and Colors.Accent or Colors.Background,
                BorderSizePixel = 1,
                BorderColor3 = Colors.Border,
                Text = config.Value and "✓" or "",
                TextColor3 = Colors.Text,
                TextSize = 12,
                Font = Enum.Font.SourceSansBold
            })
            
            CreateElement("UICorner", {Parent = checkbox, CornerRadius = UDim.new(0, 3)})
            
            CreateElement("TextLabel", {
                Parent = frame,
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.fromOffset(25, 0),
                BackgroundTransparency = 1,
                Text = config.Label,
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local checked = config.Value or false
            checkbox.MouseButton1Click:Connect(function()
                checked = not checked
                checkbox.BackgroundColor3 = checked and Colors.Accent or Colors.Background
                checkbox.Text = checked and "✓" or ""
                if config.Callback then config.Callback(frame, checked) end
            end)
            
            return frame
        end
        
        function tab:Button(config)
            local button = CreateElement("TextButton", {
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Colors.Accent,
                BorderSizePixel = 0,
                Text = config.Text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.SourceSansBold
            })
            
            CreateElement("UICorner", {Parent = button, CornerRadius = UDim.new(0, 5)})
            
            button.MouseEnter:Connect(function()
                TweenElement(button, {BackgroundColor3 = Colors.AccentHover}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                TweenElement(button, {BackgroundColor3 = Colors.Accent}, 0.2)
            end)
            
            button.MouseButton1Click:Connect(function()
                if config.Callback then config.Callback() end
            end)
            
            return button
        end
        
        function tab:Combo(config)
            local frame = CreateElement("Frame", {
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundTransparency = 1
            })
            
            CreateElement("TextLabel", {
                Parent = frame,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = config.Label,
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local dropdown = CreateElement("TextButton", {
                Parent = frame,
                Size = UDim2.new(1, 0, 0, 25),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Text = config.Selected or (config.Items and config.Items[1]) or "Select...",
                TextColor3 = Colors.Text,
                TextSize = 12,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            CreateElement("UICorner", {Parent = dropdown, CornerRadius = UDim.new(0, 5)})
            CreateElement("UIPadding", {Parent = dropdown, PaddingLeft = UDim.new(0, 10)})
            
            local dropdownList = CreateElement("Frame", {
                Parent = frame,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 50),
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 10
            })
            
            CreateElement("UICorner", {Parent = dropdownList, CornerRadius = UDim.new(0, 5)})
            
            local listLayout = CreateElement("UIListLayout", {
                Parent = dropdownList,
                Padding = UDim.new(0, 2)
            })
            
            if config.Items then
                for _, item in ipairs(config.Items) do
                    local itemButton = CreateElement("TextButton", {
                        Parent = dropdownList,
                        Size = UDim2.new(1, 0, 0, 20),
                        BackgroundColor3 = Colors.Background,
                        BorderSizePixel = 0,
                        Text = item,
                        TextColor3 = Colors.Text,
                        TextSize = 11,
                        Font = Enum.Font.SourceSans,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    
                    CreateElement("UIPadding", {Parent = itemButton, PaddingLeft = UDim.new(0, 10)})
                    
                    itemButton.MouseButton1Click:Connect(function()
                        dropdown.Text = item
                        dropdownList.Visible = false
                        frame.Size = UDim2.new(1, 0, 0, 50)
                        if config.Callback then config.Callback(frame, item) end
                    end)
                end
                
                listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdownList.Size = UDim2.new(1, 0, 0, math.min(listLayout.AbsoluteContentSize.Y, 100))
                end)
            end
            
            dropdown.MouseButton1Click:Connect(function()
                dropdownList.Visible = not dropdownList.Visible
                frame.Size = dropdownList.Visible and UDim2.new(1, 0, 0, 50 + dropdownList.Size.Y.Offset) or UDim2.new(1, 0, 0, 50)
            end)
            
            return frame
        end
        
        return tab
    end
    
    return window
end

return ReGui
