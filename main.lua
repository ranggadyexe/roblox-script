-- Rayfield GUI Loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/ranggadyexe/roblox-script/main/Rayfield.lua"))()

-- Load semua modules
local baseURL = "https://raw.githubusercontent.com/ranggadyexe/roblox-script/main/modules/"
local modules = {
    "fly",
    "speedwalk",
    "jumppower",
    "antiafk",
    "lowgraphic",
    "noclip",
    "teleport"
}

for _, name in ipairs(modules) do
    local url = baseURL .. name .. ".lua"
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Gagal load module:", name, "Error:", err)
    end
end

-- Load GUI terakhir
loadstring(game:HttpGet("https://raw.githubusercontent.com/ranggadyexe/roblox-script/main/gui/gui.lua"))()
