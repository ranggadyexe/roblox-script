-- modules/lowgraphic.lua
-- Low Graphic Mode pribadi, toggleable via GUI

local lighting = game:GetService("Lighting")
local terrain = workspace:FindFirstChildOfClass("Terrain")
local originalSettings = {}
local isLowGraphicActive = false

local function enableLowGraphic()
	if isLowGraphicActive then return end
	isLowGraphicActive = true

	-- Simpan pengaturan asli
	originalSettings.FogEnd = lighting.FogEnd
	originalSettings.Brightness = lighting.Brightness
	originalSettings.GlobalShadows = lighting.GlobalShadows
	originalSettings.EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale
	originalSettings.EnvironmentSpecularScale = lighting.EnvironmentSpecularScale
	originalSettings.WaterWaveSize = terrain and terrain.WaterWaveSize or 0
	originalSettings.WaterWaveSpeed = terrain and terrain.WaterWaveSpeed or 0
	originalSettings.WaterReflectance = terrain and terrain.WaterReflectance or 0
	originalSettings.WaterTransparency = terrain and terrain.WaterTransparency or 0

	-- Terapkan pengaturan low-graphic
	lighting.FogEnd = 100000
	lighting.Brightness = 0
	lighting.GlobalShadows = false
	lighting.EnvironmentDiffuseScale = 0
	lighting.EnvironmentSpecularScale = 0

	if terrain then
		terrain.WaterWaveSize = 0
		terrain.WaterWaveSpeed = 0
		terrain.WaterReflectance = 0
		terrain.WaterTransparency = 1
	end

	-- Hapus efek dan pantulan
	for _, v in pairs(lighting:GetChildren()) do
		if v:IsA("PostEffect") then
			v.Enabled = false
		end
	end

	-- Nonaktifkan texture
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Texture") or obj:IsA("Decal") then
			obj.Transparency = 1
		end
	end
end

local function disableLowGraphic()
	if not isLowGraphicActive then return end
	isLowGraphicActive = false

	-- Kembalikan pengaturan asli
	lighting.FogEnd = originalSettings.FogEnd or 100000
	lighting.Brightness = originalSettings.Brightness or 1
	lighting.GlobalShadows = originalSettings.GlobalShadows or true
	lighting.EnvironmentDiffuseScale = originalSettings.EnvironmentDiffuseScale or 1
	lighting.EnvironmentSpecularScale = originalSettings.EnvironmentSpecularScale or 1

	if terrain then
		terrain.WaterWaveSize = originalSettings.WaterWaveSize or 0.1
		terrain.WaterWaveSpeed = originalSettings.WaterWaveSpeed or 0.1
		terrain.WaterReflectance = originalSettings.WaterReflectance or 0.05
		terrain.WaterTransparency = originalSettings.WaterTransparency or 0
	end

	-- Aktifkan kembali post effects
	for _, v in pairs(lighting:GetChildren()) do
		if v:IsA("PostEffect") then
			v.Enabled = true
		end
	end

	-- Kembalikan transparansi texture
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Texture") or obj:IsA("Decal") then
			obj.Transparency = 0
		end
	end
end

-- Fungsi publik
_G.StartLowGraphic = function()
	enableLowGraphic()
end

_G.StopLowGraphic = function()
	disableLowGraphic()
end
