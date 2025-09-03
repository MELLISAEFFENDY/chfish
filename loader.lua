-- FISCH Script Loader v2.0
-- Repository: https://github.com/MELLISAEFFENDY/chfish
-- New UI Edition - More stable and user-friendly

print("🎣 FISCH Script Loader v2.0")
print("📖 Created by MELLISAEFFENDY")

-- Try to load the new main script with simple UI
local success, result = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/chfish/main/new-main.lua'))()
end)

if not success then
    warn("❌ Failed to load new script, trying fallback...")
    
    -- Fallback to simple loader
    local fallbackSuccess, fallbackResult = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/chfish/main/simple-loader.lua'))()
    end)
    
    if not fallbackSuccess then
        error("❌ All loading methods failed: " .. tostring(fallbackResult))
    end
end

print("✅ FISCH Script loaded successfully!")
