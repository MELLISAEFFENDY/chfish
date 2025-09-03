-- Alternative Simple Loader for FISCH Script
-- Use this if main loader fails
-- Repository: https://github.com/MELLISAEFFENDY/chfish

print("Loading FISCH Script (Alternative Loader)...")

-- Simple function to load and validate ReGui
local function loadReGuiSimple()
    local success, result = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/chfish/main/ReGui.lua'))()
    end)
    
    if success and result and type(result) == "table" then
        return result
    else
        error("Failed to load ReGui: " .. tostring(result))
    end
end

-- Load ReGui
local ReGui = loadReGuiSimple()
print("ReGui loaded successfully")

-- Simple initialization
wait(1) -- Give game time to load
ReGui:Init()
print("ReGui initialized successfully")

-- Create main window
local MainWindow = ReGui:Window({
    Title = 'FISCH Script (Simple)',
    Size = UDim2.fromOffset(400, 500)
})

-- Create basic tab
local MainTab = MainWindow:CreateTab({Name = 'Main'})

-- Add basic functionality
MainTab:Checkbox({
    Label = 'Script Loaded Successfully',
    Value = true,
    Callback = function() end
})

MainTab:Button({
    Label = 'Load Full Script',
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/chfish/main/main.lua'))()
    end
})

print("Alternative loader completed successfully!")
