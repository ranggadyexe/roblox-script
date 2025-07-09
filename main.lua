-- main.lua
loadstring(readfile("Rayfield.lua"))()

-- Load semua modules
loadstring(readfile("modules/fly.lua"))()
loadstring(readfile("modules/speedwalk.lua"))()
loadstring(readfile("modules/jumppower.lua"))()
loadstring(readfile("modules/antiafk.lua"))()
loadstring(readfile("modules/lowgraphic.lua"))()
loadstring(readfile("modules/noclip.lua"))()
loadstring(readfile("modules/teleport.lua"))()

-- Tambahkan module lain di sini

-- Load GUI (wajib terakhir)
loadstring(readfile("gui/gui.lua"))()
