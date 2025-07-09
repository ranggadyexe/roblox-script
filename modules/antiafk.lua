-- modules/antiafk.lua
-- Anti-AFK script pribadi dengan toggle via GUI

local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local antiafkConnection
local antiafkRunning = false

local function enableAntiAFK()
	if antiafkRunning then return end
	antiafkRunning = true

	antiafkConnection = player.Idled:Connect(function()
		VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		task.wait(1)
		VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end

local function disableAntiAFK()
	if not antiafkRunning then return end
	antiafkRunning = false

	if antiafkConnection then
		antiafkConnection:Disconnect()
		antiafkConnection = nil
	end
end

-- Fungsi publik untuk GUI
_G.StartAntiAFK = function()
	enableAntiAFK()
end

_G.StopAntiAFK = function()
	disableAntiAFK()
end

-- Optional: Notifikasi saat module dimuat
if Rayfield then
	Rayfield:Notify({
		Title = "Anti-AFK Loaded",
		Content = "Kamu sekarang tidak akan kena kick karena idle.",
		Duration = 5
	})
else
	print("[AntiAFK] Loaded.")
end
