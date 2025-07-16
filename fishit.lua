-- GUI dengan Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Akses ke Remote
local netRoot = ReplicatedStorage:WaitForChild("Packages")
	:WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local EquipToolRemote = netRoot:WaitForChild("RE/EquipToolFromHotbar")
local StartChargeRemote = netRoot:WaitForChild("RF/RequestFishingMinigameStarted")
local ChargeRodRemote = netRoot:WaitForChild("RF/ChargeFishingRod")
local CompleteFishingRemote = netRoot:WaitForChild("RE/FishingCompleted")

-- GUI Window
local Window = Rayfield:CreateWindow({
	Name = "🎣 Fish It - DEWA",
	LoadingTitle = "FISH IT 🎣",
	LoadingSubtitle = "by DEWA",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "FishItScript",
		FileName = "AutoFishSettings"
	},
	Discord = { Enabled = false },
	KeySystem = false,
})

local MainTab = Window:CreateTab("🎣 Auto Fish", 4483362458)
local SellTab = Window:CreateTab("💵 Penjualan", 4483362458)
local ShopTab = Window:CreateTab("🛒 Shop", 4483362458)
local TeleportTab = Window:CreateTab("📍 Teleportasi", 4483362458)
local IslandsTab = Window:CreateTab("🏝️ Pulau", 4483362458)
local ServerTab = Window:CreateTab("🌐 Server Tools", 4483362458)

MainTab:CreateSection("🎣 Auto Mancing")

local autoEquipThread = nil
local autoFishThread = nil

-- ✅ Auto Equip Rod
MainTab:CreateToggle({
	Name = "🎣 Auto Equip Rod",
	CurrentValue = false,
	Flag = "AutoEquip",
	Callback = function(Value)
		_G.AutoEquipRod = Value

		if not Value then
			if autoEquipThread then
				task.cancel(autoEquipThread)
				autoEquipThread = nil
			end
			return
		end

		autoEquipThread = task.spawn(function()
			while _G.AutoEquipRod do
				pcall(function()
					EquipToolRemote:FireServer(1)
				end)
				task.wait(1.5)
			end
		end)
	end,
})

-- ✅ Auto Cast + Charge + Hatch
MainTab:CreateToggle({
	Name = "🔥 Auto Fish (Instan Hatch)",
	CurrentValue = false,
	Flag = "AutoFish",
	Callback = function(Value)
		_G.AutoFish = Value

		if not Value then
			if autoFishThread then
				task.cancel(autoFishThread)
				autoFishThread = nil
			end

			-- 🧹 Coba lepas rod jika masih ter-equip
			local character = Players.LocalPlayer.Character
			if character then
				for _, tool in pairs(character:GetChildren()) do
					if tool:IsA("Tool") and tool.Name:lower():find("rod") then
						tool.Parent = Players.LocalPlayer.Backpack
					end
				end
			end

			return
		end

		autoFishThread = task.spawn(function()
			while _G.AutoFish do
				pcall(function()
					StartChargeRemote:InvokeServer(-1, 1)
					task.wait(0.25)

					local now = tick()
					ChargeRodRemote:InvokeServer(now - 0.14)

					task.wait(0.3)
					CompleteFishingRemote:FireServer()
					task.wait(0.3)
				end)
				task.wait(0.2)
			end
		end)
	end,
})

-- 🔁 Tombol Reset Tool State
MainTab:CreateButton({
	Name = "🔁 Mau Berhenti? Klik ini 3x setelah dapat ikan",
	Callback = function()
		-- Matikan semua flag & thread
		_G.AutoFish = false
		_G.AutoEquipRod = false

		if autoFishThread then
			task.cancel(autoFishThread)
			autoFishThread = nil
		end
		if autoEquipThread then
			task.cancel(autoEquipThread)
			autoEquipThread = nil
		end

		-- Coba pindahkan rod ke backpack
		local player = Players.LocalPlayer
		local char = player.Character
		if char then
			for _, tool in pairs(char:GetChildren()) do
				if tool:IsA("Tool") and tool.Name:lower():find("rod") then
					tool.Parent = player.Backpack
				end
			end
		end

		Rayfield:Notify({
			Title = "Reset Sukses",
			Content = "Semua fitur dimatikan & rod dilepas.",
			Duration = 4,
			Image = 4483362458,
		})
	end,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FishingRadarItem = ReplicatedStorage:WaitForChild("Items"):FindFirstChild("Fishing Radar")
local RadarRemote = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")
    :WaitForChild("RF/UpdateFishingRadar")

MainTab:CreateToggle({
    Name = "📡 Fishing Radar",
    CurrentValue = false,
    Flag = "FishingRadarBypass",
    Callback = function(enabled)
        pcall(function()
            local backpack = Players.LocalPlayer:WaitForChild("Backpack")
            local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()

            if enabled then
                -- 🔁 Clone dan masukkan Fishing Radar ke backpack
                if FishingRadarItem then
                    local clonedRadar = FishingRadarItem:Clone()
                    clonedRadar.Parent = backpack
                    print("✅ Radar dimasukkan ke Backpack")

                    -- Invoke ON
                    RadarRemote:InvokeServer(true)
                else
                    warn("❌ Fishing Radar item tidak ditemukan di ReplicatedStorage.Items")
                end
            else
                -- Hapus radar dari backpack jika ada
                local existing = backpack:FindFirstChild("Fishing Radar")
                if existing then existing:Destroy() end

                -- Invoke OFF
                RadarRemote:InvokeServer(false)
                print("🛑 Radar dimatikan dan dihapus dari backpack")
            end
        end)
    end
})


MainTab:CreateSection("⚙️ Utility")
-- Walkspeed
MainTab:CreateSlider({
   Name = "Lari Ngibrit",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Walkspeed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(v)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
   end
})

-- JumpPower
MainTab:CreateSlider({
   Name = "Loncat Tinggi",
   Range = {50, 500},
   Increment = 1,
   Suffix = "JumpPower",
   CurrentValue = 50,
   Flag = "Slider1",
   Callback = function(v)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
   end
})

-- Infinite Jump
_G.InfiniteJumpConnection = nil
MainTab:CreateToggle({
   Name = "Loncat Loncat",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(enabled)
      if enabled then
         _G.InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState("Jumping") end
         end)
      elseif _G.InfiniteJumpConnection then
         _G.InfiniteJumpConnection:Disconnect()
         _G.InfiniteJumpConnection = nil
      end
   end
})

-- Anti AFK
MainTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(enabled)
      if enabled then
         _G.AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
         end)
      elseif _G.AntiAFKConnection then
         _G.AntiAFKConnection:Disconnect()
         _G.AntiAFKConnection = nil
      end
   end
})

-- Noclip
_G.Noclip = false
_G.NoclipConnection = nil
MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(enabled)
      _G.Noclip = enabled
      if enabled then
         _G.NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if char then
               for _, v in pairs(char:GetDescendants()) do
                  if v:IsA("BasePart") and v.CanCollide == true then
                     v.CanCollide = false
                  end
               end
            end
         end)
      elseif _G.NoclipConnection then
         _G.NoclipConnection:Disconnect()
         _G.NoclipConnection = nil
      end
   end
})

-- Low Graphics
MainTab:CreateToggle({
   Name = "Graphic Kentang",
   CurrentValue = false,
   Flag = "LowGFX",
   Callback = function(enabled)
      if enabled then
         for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
               v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
               v.Enabled = false
            end
         end
         game.Lighting.GlobalShadows = false
         game.Lighting.FogEnd = 100000
         settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
      else
         game.Lighting.GlobalShadows = true
         game.Lighting.FogEnd = 1000
         settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
      end
   end
})

SellTab:CreateSection("🛒 Penjualan Otomatis Tapi Harus Dekat Dengan NPC")
SellTab:CreateButton({
	Name = "💰 Auto Sell All (Harus Dekat Dengan NPC)",
	Callback = function()
		local SellAllRemote = game:GetService("ReplicatedStorage")
			:WaitForChild("Packages"):WaitForChild("_Index")
			:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
			:WaitForChild("RF/SellAllItems")

		pcall(function()
			SellAllRemote:InvokeServer()
		end)

		Rayfield:Notify({
			Title = "Berhasil!",
			Content = "Semua item di Backpack telah dijual.",
			Duration = 4,
			Image = 4483362458,
		})
	end
})

local autoSellThread

SellTab:CreateToggle({
	Name = "♻️ Auto Sell Tiap 30 Detik",
	CurrentValue = false,
	Flag = "AutoSellLoop",
	Callback = function(Value)
		_G.AutoSell = Value

		if not Value then
			if autoSellThread then
				task.cancel(autoSellThread)
				autoSellThread = nil
			end
			return
		end

		local SellAllRemote = game:GetService("ReplicatedStorage")
			:WaitForChild("Packages"):WaitForChild("_Index")
			:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
			:WaitForChild("RF/SellAllItems")

		autoSellThread = task.spawn(function()
			while _G.AutoSell do
				pcall(function()
					SellAllRemote:InvokeServer()
				end)
				task.wait(30) -- interval auto sell
			end
		end)
	end
})


SellTab:CreateSection("🏝️ Penjualan ke NPC Berdasarkan Lokasi (TP > Jual > Balik Lagi)")
local function SellToTropicalNPC()
	local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local npc = workspace["!!! MENU RINGS"]:GetChildren()[6] -- Jed (Tropical Grove)
	if not npc or not npc:IsA("BasePart") then
		warn("❌ NPC bukan BasePart")
		return
	end

	local originalPos = hrp.CFrame

	-- Teleport langsung ke NPC
	hrp.CFrame = npc.CFrame + Vector3.new(0, 3, 0)
	task.wait(0.5)

	-- Jual item
	local success, err = pcall(function()
		local SellAllRemote = game:GetService("ReplicatedStorage")
			:WaitForChild("Packages"):WaitForChild("_Index")
			:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
			:WaitForChild("RF/SellAllItems")
		SellAllRemote:InvokeServer()
	end)

	task.wait(0.3)
	hrp.CFrame = originalPos

	if success then
		print("✅ Item berhasil dijual ke Jed.")
	else
		warn("❌ Gagal menjual item:", err)
	end
end


SellTab:CreateButton({
	Name = "💰 Jual ke Jed (Tropical Grove)",
	Callback = SellToTropicalNPC
})


local function SellToAlex()
	local npc = workspace["!!! MENU RINGS"]:GetChildren()[9]
	local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local originalPos = hrp.CFrame

	if npc:IsA("BasePart") then
		hrp.CFrame = npc.CFrame + Vector3.new(0, 3, 0)
		task.wait(0.5)
		pcall(function()
			SellAllRemote:InvokeServer()
		end)
		-- Jual item
	local success, err = pcall(function()
		local SellAllRemote = game:GetService("ReplicatedStorage")
			:WaitForChild("Packages"):WaitForChild("_Index")
			:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
			:WaitForChild("RF/SellAllItems")
		SellAllRemote:InvokeServer()
	end)

		task.wait(0.3)
		hrp.CFrame = originalPos
	end
end

SellTab:CreateButton({
	Name = "💰 Jual ke Alex (Stingray Shores)",
	Callback = SellToAlex
})

local function SellToJess()
	local npc = workspace["!!! MENU RINGS"]:GetChildren()[8]
	local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local originalPos = hrp.CFrame

	if npc:IsA("BasePart") then
		hrp.CFrame = npc.CFrame + Vector3.new(0, 3, 0)
		task.wait(0.5)
		pcall(function()
			SellAllRemote:InvokeServer()
		end)
		-- Jual item
	local success, err = pcall(function()
		local SellAllRemote = game:GetService("ReplicatedStorage")
			:WaitForChild("Packages"):WaitForChild("_Index")
			:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
			:WaitForChild("RF/SellAllItems")
		SellAllRemote:InvokeServer()
	end)

		task.wait(0.3)
		hrp.CFrame = originalPos
	end
end

SellTab:CreateButton({
	Name = "💰 Jual ke Jess (Coral Reefs)",
	Callback = SellToJess
})

local function SellToJones()
	local npc = workspace["!!! MENU RINGS"]:GetChildren()[7]
	local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local originalPos = hrp.CFrame

	if npc:IsA("BasePart") then
		hrp.CFrame = npc.CFrame + Vector3.new(0, 3, 0)
		task.wait(0.5)
		pcall(function()
			SellAllRemote:InvokeServer()
		end)
		-- Jual item
	local success, err = pcall(function()
		local SellAllRemote = game:GetService("ReplicatedStorage")
			:WaitForChild("Packages"):WaitForChild("_Index")
			:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
			:WaitForChild("RF/SellAllItems")
		SellAllRemote:InvokeServer()
	end)

		task.wait(0.3)
		hrp.CFrame = originalPos
	end
end

SellTab:CreateButton({
	Name = "💰 Jual ke Jones (Ocean)",
	Callback = SellToJones
})

local function SellToKohana()
	local npc = workspace["!!! MENU RINGS"]:FindFirstChild("Selling")
	local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	local originalPos = hrp.CFrame

	if npc and npc:IsA("BasePart") then
		hrp.CFrame = npc.CFrame + Vector3.new(0, 3, 0)
		task.wait(0.5)
		pcall(function()
			SellAllRemote:InvokeServer()
		end)
		-- Jual item
	local success, err = pcall(function()
		local SellAllRemote = game:GetService("ReplicatedStorage")
			:WaitForChild("Packages"):WaitForChild("_Index")
			:WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
			:WaitForChild("RF/SellAllItems")
		SellAllRemote:InvokeServer()
	end)

		task.wait(0.3)
		hrp.CFrame = originalPos
	end
end

SellTab:CreateButton({
	Name = "💰 Jual ke Jones (Kohana)",
	Callback = SellToKohana
})

ShopTab:CreateButton({
	Name = "📍 Tempat Jual Rods",
	Callback = function()
		local target = workspace:FindFirstChild("!!! MENU RINGS")
		if target and target:FindFirstChild("Rods") then
			local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
			hrp.CFrame = target.Rods.CFrame + Vector3.new(0, 5, 0)
		else
			Rayfield:Notify({
				Title = "Teleport Gagal",
				Content = "'!!! MENU RINGS.Rods' tidak ditemukan!",
				Duration = 4,
				Image = 4483362458,
			})
		end
	end,
})

local function teleportToPath(folderName, targetName)
	local menu = workspace:FindFirstChild(folderName)
	if not menu then
		warn("❌ Folder '" .. folderName .. "' tidak ditemukan.")
		return
	end

	local target = menu:FindFirstChild(targetName)
	if not target then
		warn("❌ Target '" .. targetName .. "' tidak ditemukan.")
		return
	end

	local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		warn("❌ HumanoidRootPart tidak ditemukan.")
		return
	end

	-- Kalau model, pakai GetPivot
	if target:IsA("Model") then
		hrp.CFrame = target:GetPivot() + Vector3.new(0, 5, 0)
	elseif target:IsA("BasePart") then
		hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0)
	else
		warn("❌ Target bukan Model atau Part.")
	end
end

ShopTab:CreateButton({
	Name = "📍 Teleport ke Fishing Radar Stand",
	Callback = function()
		teleportToPath("!!! MENU RINGS", "Fishing Radar Stand")
	end,
})

ShopTab:CreateButton({
	Name = "📍 Teleport ke Ares Rod Stand",
	Callback = function()
		teleportToPath("!!! MENU RINGS", "Ares Rod Stand")
	end,
})



-- SECTION: TELEPORT KE NPC
TeleportTab:CreateSection("🧍 Teleport ke NPC")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ReplicatedNPCFolder = ReplicatedStorage:WaitForChild("NPC")
local NPCDropdown

-- Ambil semua nama NPC, urut A-Z, bisa difilter
local function GetSortedNPCNames(filter)
	local npcNames = {}

	for _, model in ipairs(ReplicatedNPCFolder:GetChildren()) do
		if model:IsA("Model") then
			local name = model.Name
			if not filter or string.find(string.lower(name), string.lower(filter)) then
				table.insert(npcNames, name)
			end
		end
	end

	table.sort(npcNames)
	return npcNames
end

-- Teleport langsung ke ReplicatedStorage.NPC[Nama].HumanoidRootPart
local function TeleportToNPC(name)
	local npc = ReplicatedNPCFolder:FindFirstChild(name)
	if not npc then
		warn("❌ NPC '" .. name .. "' tidak ditemukan.")
		return
	end

	local tpPart = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head") or npc:FindFirstChildOfClass("BasePart")
	if not tpPart then
		warn("❌ Tidak menemukan bagian teleport dalam NPC '" .. name .. "'")
		return
	end

	local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = tpPart.CFrame + Vector3.new(2, 3, 2)
	end
end

-- Dropdown NPC
NPCDropdown = TeleportTab:CreateDropdown({
	Name = "🧍 Teleport ke NPC",
	Options = GetSortedNPCNames(),
	CurrentOption = {""},
	MultipleOptions = false,
	Flag = "NPCSelector",
	Callback = function(option)
		local selected = option[1]
		if selected and selected ~= "" then
			TeleportToNPC(selected)
		end
	end
})

-- Filter cari nama
TeleportTab:CreateInput({
	Name = "🔍 Cari Nama NPC",
	PlaceholderText = "Contoh: PLER",
	RemoveTextAfterFocusLost = false,
	Callback = function(text)
		NPCDropdown:Refresh(GetSortedNPCNames(text))
	end
})

-- Tombol manual refresh
TeleportTab:CreateButton({
	Name = "🔁 Refresh Daftar NPC",
	Callback = function()
		NPCDropdown:Refresh(GetSortedNPCNames())
		Rayfield:Notify({
			Title = "Berhasil!",
			Content = "Daftar NPC di-refresh dari ReplicatedStorage.",
			Duration = 3,
		})
	end
})



-- SECTION: TELEPORT KE PLAYER
TeleportTab:CreateSection("🧑‍🤝‍🧑 Teleport ke Player")

local selectedPlayerName = ""
local playerDropdown

-- Ambil daftar nama player
local function GetFilteredPlayerList(filter)
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not filter or string.find(string.lower(player.Name), string.lower(filter)) then
                table.insert(list, player.Name)
            end
        end
    end
    table.sort(list)
    return list
end

-- Dropdown teleport ke player (langsung teleport saat dipilih)
playerDropdown = TeleportTab:CreateDropdown({
    Name = "🧍 Teleport ke Player",
    Options = GetFilteredPlayerList(),
    CurrentOption = {""},
    MultipleOptions = false,
    Flag = "TeleportToPlayerDropdown",
    Callback = function(option)
        local selected = option[1]
        if selected and selected ~= "" then
            local targetPlayer = Players:FindFirstChild(selected)
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHRP = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")

            if myHRP and targetHRP then
                myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 2)
                Rayfield:Notify({
                    Title = "✅ Teleport Berhasil",
                    Content = "Berhasil ke " .. selected,
                    Duration = 3
                })
            else
                Rayfield:Notify({
                    Title = "❌ Gagal Teleport",
                    Content = "HumanoidRootPart tidak ditemukan.",
                    Duration = 3
                })
            end
        end
    end
})

-- Input filter player
TeleportTab:CreateInput({
    Name = "🔍 Cari Nama Player",
    PlaceholderText = "Contoh: PLER",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local filtered = GetFilteredPlayerList(text)
        playerDropdown:Refresh(filtered)
        playerDropdown:Set({""})
    end
})

TeleportTab:CreateButton({
    Name = "🔁 Refresh Daftar Player",
    Callback = function()
        local updated = GetFilteredPlayerList()
        playerDropdown:Refresh(updated)
        playerDropdown:Set({""})
        Rayfield:Notify({
            Title = "✅ Diperbarui",
            Content = "Daftar player berhasil diperbarui.",
            Duration = 3
        })
    end
})

TeleportTab:CreateSection("📌 Simpan & Teleport ke Posisi Custom")
local savedCFrame = nil
TeleportTab:CreateButton({
   Name = "📌 Simpan Posisi Saat Ini",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
         savedCFrame = char.HumanoidRootPart.CFrame
         Rayfield:Notify({
            Title = "Posisi Disimpan",
            Content = "Posisi berhasil disimpan!",
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Gagal Menyimpan",
            Content = "Karakter atau HRP tidak ditemukan.",
            Duration = 3
         })
      end
   end
})

TeleportTab:CreateButton({
   Name = "🚀 Teleport ke Posisi Tersimpan",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("HumanoidRootPart") and savedCFrame then
         char.HumanoidRootPart.CFrame = savedCFrame
         Rayfield:Notify({
            Title = "Teleport Sukses",
            Content = "Kamu telah kembali ke posisi tersimpan.",
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Gagal Teleport",
            Content = "Posisi belum disimpan atau karakter tidak lengkap.",
            Duration = 3
         })
      end
   end
})


-- Dropdown teleport ke pulau
local islandList = {
	"Coral Reefs",
	"Crater Island",
	"Esoteric Depths",
	"Kohana",
	"Kohana Volcano",
	"Stingray Shores",
	"Tropical Grove",
	"Weather Machine"
}

local islandDropdown = IslandsTab:CreateDropdown({
	Name = "🌴 Teleport ke Pulau",
	Options = islandList,
	CurrentOption = {},
	MultipleOptions = false,
	Flag = "IslandSelector",
	Callback = function(option)
		local folder = workspace:FindFirstChild("!!!! ISLAND LOCATIONS !!!!")
		if not folder or not option[1] then return end
		local island = folder:FindFirstChild(option[1])
		if island then
			local part = island:IsA("BasePart") and island or island:FindFirstChildWhichIsA("BasePart", true)
			if part then
				local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
				end
			end
		end
	end
})


-- Fungsi teleport ke ENCHANTING ALTAR
local function TeleportToAltar()
	local altar = workspace:FindFirstChild("! ENCHANTING ALTAR !")
	if not altar then
		warn("❌ '! ENCHANTING ALTAR !' tidak ditemukan di Workspace.")
		return
	end

	-- Jika altar adalah BasePart, langsung teleport
	if altar:IsA("BasePart") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = altar.CFrame + Vector3.new(0, 5, 0)
		print("✅ Teleport ke: ! ENCHANTING ALTAR !")
	elseif altar:IsA("Model") then
		-- Jika altar adalah model, cari part di dalamnya
		local part = altar:FindFirstChildWhichIsA("BasePart", true)
		if part then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
			print("✅ Teleport ke part dalam model ! ENCHANTING ALTAR !")
		else
			warn("❌ Tidak ada BasePart dalam '! ENCHANTING ALTAR !'")
		end
	else
		warn("❌ '! ENCHANTING ALTAR !' bukan Model/BasePart.")
	end
end

IslandsTab:CreateButton({
	Name = "✨ Teleport ke Enchanting Altar",
	Callback = function()
		TeleportToAltar()
	end
})

IslandsTab:CreateButton({
    Name = "🦈 Teleport ke Ghost Shark Hunt",
    Callback = function()
        local sharkHunt = workspace:FindFirstChild("Props") and workspace.Props:FindFirstChild("Ghost Shark Hunt")
        if not sharkHunt then
            Rayfield:Notify({
                Title = "❌ Gagal Teleport",
                Content = "'Ghost Shark Hunt' tidak ditemukan di workspace.Props",
                Duration = 4
            })
            return
        end

        local targetPart = sharkHunt:IsA("BasePart") and sharkHunt or sharkHunt:FindFirstChildWhichIsA("BasePart", true)

        if targetPart then
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
                Rayfield:Notify({
                    Title = "✅ Teleport Berhasil",
                    Content = "Berhasil teleport ke Ghost Shark Hunt!",
                    Duration = 3
                })
            end
        else
            Rayfield:Notify({
                Title = "⚠️ Tidak Ada BasePart",
                Content = "Tidak menemukan bagian valid di Ghost Shark Hunt.",
                Duration = 4
            })
        end
    end
})



ServerTab:CreateSection("🌐 Kontrol Server")
--===[ SERVER TAB ]===--
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId

ServerTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local servers = {}
      local req = syn and syn.request or http and http.request or http_request or request
      local body = req({
         Url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
      }).Body
      local data = HttpService:JSONDecode(body)
      for _, server in pairs(data.data) do
         if server.playing < server.maxPlayers and server.id ~= game.JobId then
            table.insert(servers, server.id)
         end
      end
      TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], LocalPlayer)
   end
})

ServerTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      TeleportService:Teleport(PlaceId, LocalPlayer)
   end
})

ServerTab:CreateButton({
   Name = "Join Server dengan Sedikit Pemain",
   Callback = function()
      local HttpService = game:GetService("HttpService")
      local TeleportService = game:GetService("TeleportService")
      local Players = game:GetService("Players")
      local PlaceId = game.PlaceId
      local LocalPlayer = Players.LocalPlayer

      local servers = {}
      local req = syn and syn.request or http and http.request or http_request or request

      local body = req({
         Url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
      }).Body

      local data = HttpService:JSONDecode(body)

      for _, server in pairs(data.data) do
         if server.playing > 0 and server.playing <= 5 and server.id ~= game.JobId then
            table.insert(servers, server.id)
         end
      end

      if #servers > 0 then
         TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], LocalPlayer)
      else
         Rayfield:Notify({
            Title = "Tidak Ditemukan",
            Content = "Tidak ada server dengan ≤5 player saat ini.",
            Duration = 3
         })
      end
   end
})

ServerTab:CreateSection("🛡️ Deteksi Admin/Mod")
-- Admin/Moderator Detection
local blacklistUsers = { "Admin1", "ModUser", "TestMod" }
_G.AdminAction = "None"

ServerTab:CreateDropdown({
   Name = "Aksi saat Admin/Mod Masuk",
   Options = {"None", "Warning", "Kick"},
   CurrentOption = "None",
   Flag = "AdminActionDropdown",
   Callback = function(option)
      _G.AdminAction = option
   end
})

local function IsBlacklisted(user)
   for _, name in pairs(blacklistUsers) do
      if user == name then return true end
   end
   return false
end

local function HandleAdminDetection(playerName)
   if _G.AdminAction == "Warning" then
      Rayfield:Notify({
         Title = "⚠️ Admin/Mod Terdeteksi!",
         Content = "Player mencurigakan: " .. playerName,
         Duration = 5
      })
   elseif _G.AdminAction == "Kick" then
      LocalPlayer:Kick("Admin/Mod terdeteksi: " .. playerName)
   end
end

for _, player in pairs(Players:GetPlayers()) do
   if IsBlacklisted(player.Name) then
      HandleAdminDetection(player.Name)
   end
end

Players.PlayerAdded:Connect(function(player)
   if IsBlacklisted(player.Name) then
      HandleAdminDetection(player.Name)
   end
end)