-- Fly Module (Personal, Toggleable, Minim Deteksi)
-- Tekan tombol E atau panggil _G.StartFly() / _G.StopFly()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 60

local BodyGyro
local BodyVelocity

local keys = {
	W = false,
	A = false,
	S = false,
	D = false
}

-- Fungsi memulai Fly
local function startFly()
	if flying or not HumanoidRootPart then return end
	flying = true

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.P = 9e4
	BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	BodyGyro.cframe = HumanoidRootPart.CFrame
	BodyGyro.Parent = HumanoidRootPart

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
	BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
	BodyVelocity.Parent = HumanoidRootPart

	RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value, function()
		if not flying or not HumanoidRootPart then return end

		local cam = workspace.CurrentCamera
		local move = Vector3.new(
			(keys.D and 1 or 0) - (keys.A and 1 or 0),
			0,
			(keys.S and 1 or 0) - (keys.W and 1 or 0)
		)

		local moveDirection = cam.CFrame:VectorToWorldSpace(move).Unit
		if move.Magnitude == 0 then
			BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
		else
			BodyVelocity.velocity = moveDirection * speed
		end

		BodyGyro.CFrame = cam.CFrame
	end)
end

-- Fungsi menghentikan Fly
local function stopFly()
	flying = false
	RunService:UnbindFromRenderStep("FlyControl")
	if BodyGyro then BodyGyro:Destroy() end
	if BodyVelocity then BodyVelocity:Destroy() end
end

-- Fungsi input keyboard (tekan E untuk toggle manual)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.E then
		if flying then
			stopFly()
		else
			startFly()
		end
	elseif keys[key.Name] ~= nil then
		keys[key.Name] = true
	end
end)

UserInputService.InputEnded:Connect(function(input, gp)
	if gp then return end
	local key = input.KeyCode
	if keys[key.Name] ~= nil then
		keys[key.Name] = false
	end
end)

-- Fungsi publik untuk GUI
_G.StartFly = function()
	startFly()
end

_G.StopFly = function()
	stopFly()
end

-- Notifikasi awal (jika pakai Rayfield)
if Rayfield then
	Rayfield:Notify({
		Title = "Fly Loaded",
		Content = "Tekan [E] atau gunakan GUI untuk toggle fly.",
		Duration = 5
	})
else
	warn("Fly module loaded. Tekan E untuk aktif/nonaktif.")
end
