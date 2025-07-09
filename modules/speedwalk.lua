-- SpeedWalk Module

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local speedEnabled = false
local speedValue = 16  -- Default Roblox WalkSpeed

-- Update loop
local function applySpeed()
	while speedEnabled do
		local character = LocalPlayer.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid.WalkSpeed = speedValue
		end
		RunService.RenderStepped:Wait()
	end
end

-- Fungsi publik untuk GUI
_G.SetSpeedValue = function(val)
	local number = tonumber(val)
	if number and number > 0 then
		speedValue = number
	end
end

_G.StartSpeed = function()
	speedEnabled = true
	task.spawn(applySpeed)
end

_G.StopSpeed = function()
	speedEnabled = false
	local character = LocalPlayer.Character
	if character and character:FindFirstChild("Humanoid") then
		character.Humanoid.WalkSpeed = 16 -- Reset ke default
	end
end

-- Notifikasi (jika pakai Rayfield)
if Rayfield then
	Rayfield:Notify({
		Title = "Speed Module Loaded",
		Content = "Gunakan input dan toggle untuk atur kecepatan jalan.",
		Duration = 5
	})
else
	warn("Speed module loaded. Gunakan _G.StartSpeed() dan _G.SetSpeedValue(nilai).")
end
