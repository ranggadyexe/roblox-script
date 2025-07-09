-- modules/speedwalk.lua
-- Speedwalk pribadi toggleable dengan input kecepatan

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variabel kontrol
local isSpeedEnabled = false
local desiredSpeed = 16 -- default speed roblox

local function updateHumanoid()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:FindFirstChildOfClass("Humanoid")
end

local function enableSpeed()
	if isSpeedEnabled then return end
	isSpeedEnabled = true

	-- Pastikan humanoid masih valid
	updateHumanoid()
	if humanoid then
		humanoid.WalkSpeed = desiredSpeed
	end
end

local function disableSpeed()
	if not isSpeedEnabled then return end
	isSpeedEnabled = false

	updateHumanoid()
	if humanoid then
		humanoid.WalkSpeed = 16 -- speed default
	end
end

-- Fungsi publik
_G.SetSpeedValue = function(value)
	desiredSpeed = tonumber(value) or 16

	if isSpeedEnabled then
		updateHumanoid()
		if humanoid then
			humanoid.WalkSpeed = desiredSpeed
		end
	end
end

_G.StartSpeed = function()
	enableSpeed()
end

_G.StopSpeed = function()
	disableSpeed()
end
