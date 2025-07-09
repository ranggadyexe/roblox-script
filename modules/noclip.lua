-- modules/noclip.lua
-- Noclip pribadi toggleable via GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local noclipConnection
local noclipRunning = false

local function enableNoclip()
	if noclipRunning then return end
	noclipRunning = true

	noclipConnection = RunService.Stepped:Connect(function()
		character = player.Character
		if character then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide == true then
					part.CanCollide = false
				end
			end
		end
	end)
end

local function disableNoclip()
	if not noclipRunning then return end
	noclipRunning = false

	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end

	-- Opsional: aktifkan kembali CanCollide setelah noclip dimatikan
	character = player.Character
	if character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

-- Fungsi publik
_G.StartNoclip = function()
	enableNoclip()
end

_G.StopNoclip = function()
	disableNoclip()
end
