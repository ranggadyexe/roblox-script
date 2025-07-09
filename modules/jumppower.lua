-- modules/jumppower.lua
-- JumpBoost pribadi toggleable dengan input tinggi lompatan

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variabel kontrol
local isJumpPowerEnabled = false
local desiredJump = 50 -- default JumpPower = 50

local function updateHumanoid()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:FindFirstChildOfClass("Humanoid")
end

local function enableJump()
	if isJumpPowerEnabled then return end
	isJumpPowerEnabled = true

	updateHumanoid()
	if humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = desiredJump
	end
end

local function disableJump()
	if not isJumpPowerEnabled then return end
	isJumpPowerEnabled = false

	updateHumanoid()
	if humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = 50 -- nilai default Roblox
	end
end

-- Fungsi publik
_G.SetJumpPowerValue = function(value)
	desiredJump = tonumber(value) or 50

	if isJumpPowerEnabled then
		updateHumanoid()
		if humanoid then
			humanoid.JumpPower = desiredJump
		end
	end
end

_G.StartJumpPower = function()
	enableJump()
end

_G.StopJumpPower = function()
	disableJump()
end
