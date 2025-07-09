-- gui/gui.lua
local Window = Rayfield:CreateWindow({
	Name = "Script Dewa",
	LoadingTitle = "Memuat GUI...",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "ScriptDewa",
		FileName = "config"
	}
})

local MainTab = Window:CreateTab("Main", 4483362458)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MainTab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Flag = "FlyToggle",
	Callback = function(Value)
		if Value then _G.StartFly() else _G.StopFly() end
	end
})
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Input JumpPower
MainTab:CreateInput({
	Name = "Set Jump Power",
	PlaceholderText = "Masukkan tinggi loncat (contoh: 100)",
	RemoveTextAfterFocusLost = false,
	Callback = function(text)
		_G.SetJumpPowerValue(text)
	end
})

-- Toggle JumpPower
MainTab:CreateToggle({
	Name = "JumpPower ON/OFF",
	CurrentValue = false,
	Flag = "JumpPowerToggle",
	Callback = function(enabled)
		if enabled then
			_G.StartJumpPower()
		else
			_G.StopJumpPower()
		end
	end
})
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MainTab:CreateToggle({
	Name = "Anti-AFK",
	CurrentValue = false,
	Flag = "AntiAFKToggle",
	Callback = function(Value)
		if Value then
			_G.StartAntiAFK()
		else
			_G.StopAntiAFK()
		end
	end
})
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MainTab:CreateToggle({
	Name = "Low Graphic Mode",
	CurrentValue = false,
	Flag = "LowGraphicToggle",
	Callback = function(Value)
		if Value then
			_G.StartLowGraphic()
		else
			_G.StopLowGraphic()
		end
	end
})
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MainTab:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Flag = "NoclipToggle",
	Callback = function(Value)
		if Value then
			_G.StartNoclip()
		else
			_G.StopNoclip()
		end
	end
})
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Input speed
MainTab:CreateInput({
	Name = "Set Speed",
	PlaceholderText = "Masukkan kecepatan (contoh: 30)",
	RemoveTextAfterFocusLost = false,
	Callback = function(text)
		_G.SetSpeedValue(text)
	end
})

-- Toggle speed
MainTab:CreateToggle({
	Name = "Speed ON/OFF",
	CurrentValue = false,
	Flag = "SpeedToggle",
	Callback = function(enabled)
		if enabled then
			_G.StartSpeed()
		else
			_G.StopSpeed()
		end
	end
})
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Dropdown Pilih Player
MainTab:CreateDropdown({
    Name = "Pilih Player Tujuan",
    Options = _G.GetAllPlayerNames(),
    CurrentOption = "",
    Flag = "TargetPlayer",
    Callback = function(Selected)
        _G.SetTeleportTarget(Selected)
    end
})

-- Tombol Teleport
MainTab:CreateButton({
    Name = "Teleport ke Player",
    Callback = function()
        _G.TeleportToPlayer()
    end
})

-- Tombol Refresh List Player
MainTab:CreateButton({
    Name = "Refresh Daftar Player",
    Callback = function()
        Rayfield:Notify({
            Title = "Player List",
            Content = "Silakan buka ulang dropdown untuk lihat player terbaru.",
            Duration = 3
        })
    end
})
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

print("✅ GUI Loaded")
