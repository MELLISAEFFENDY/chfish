-- Simple Loader for FISCH Script with New UI
-- Use this for better compatibility
-- Repository: https://github.com/MELLISAEFFENDY/chfish

print("🎣 Loading FISCH Script (Simple UI Edition)...")

-- Direct load the new main script with simple UI
local success, result = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/MELLISAEFFENDY/chfish/main/new-main.lua'))()
end)

if not success then
    error("❌ Failed to load script: " .. tostring(result))
end

print("✅ Script loaded successfully!")
