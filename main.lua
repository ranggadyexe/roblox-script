-- main.lua (online loader)
loadstring(game:HttpGet("https://raw.githubusercontent.com/ranggadyexe/roblox-script/main/Rayfield.lua"))()

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
    local url = ("https://raw.githubusercontent.com/ranggadyexe/roblox-script/main/modules/%s.lua"):format(name)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then
        warn("Gagal load module:", name, err)
    end
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/ranggadyexe/roblox-script/main/gui/gui.lua"))()
