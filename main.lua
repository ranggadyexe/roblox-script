--===[ INIT RAYFIELD ]===--
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DEWA SLEBEW",
   Icon = 0,
   LoadingTitle = "SCRIPT UNIVERSAL",
   LoadingSubtitle = "by DEWA ANJAY SLEBEW",
   ShowText = "DEWA",
   Theme = "Default",
   ToggleUIKeybind = "K",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "DEWA Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

--===[ TABS ]===--
local InfoTab = Window:CreateTab("Script Info", 4483362458)
local MainTab = Window:CreateTab("Main", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)

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

--===[ Anti Knockback & Anti Damage dengan SpeedSinkronisasi ]===--
_G.AntiDamageEnabled = false
_G.AntiDamageConnection = nil

MainTab:CreateToggle({
   Name = "Anti Damage / Knockback",
   CurrentValue = false,
   Flag = "AntiDamage",
   Callback = function(enabled)
      _G.AntiDamageEnabled = enabled

      local function protectHumanoid()
         local char = game.Players.LocalPlayer.Character
         if not char then return end
         local humanoid = char:FindFirstChildOfClass("Humanoid")
         local hrp = char:FindFirstChild("HumanoidRootPart")
         if not humanoid or not hrp then return end

         _G.AntiDamageConnection = game:GetService("RunService").Stepped:Connect(function()
            if _G.AntiDamageEnabled then
               -- Sinkron dengan WalkSpeed: Hentikan velocity agar tidak terdorong
               hrp.Velocity = Vector3.zero

               -- Cegah kehilangan HP
               if humanoid.Health < humanoid.MaxHealth then
                  humanoid.Health = humanoid.MaxHealth
               end
            end
         end)
      end

      if enabled then
         protectHumanoid()
         game.Players.LocalPlayer.CharacterAdded:Connect(protectHumanoid)
      else
         if _G.AntiDamageConnection then
            _G.AntiDamageConnection:Disconnect()
            _G.AntiDamageConnection = nil
         end
      end
   end
})



--===[ TELEPORT TAB ]===--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local selectedPlayer = nil
local teleportDropdown = nil

local function GetPlayerList()
   local playerNames = {}
   for _, player in pairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character then
         table.insert(playerNames, player.Name)
      end
   end
   return playerNames
end

teleportDropdown = TeleportTab:CreateDropdown({
   Name = "Pilih Player Tujuan",
   Options = GetPlayerList(),
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "TeleportPlayer",
   Callback = function(option)
      selectedPlayer = option[1]
   end
})

TeleportTab:CreateButton({
   Name = "Teleport Sekarang",
   Callback = function()
      if selectedPlayer then
         local targetPlayer = Players:FindFirstChild(selectedPlayer)
         if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and myHRP then
               myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 2)
               Rayfield:Notify({
                  Title = "Teleport Berhasil",
                  Content = "Berhasil ke " .. selectedPlayer,
                  Duration = 3
               })
            else
               Rayfield:Notify({
                  Title = "Gagal Teleport",
                  Content = "HRP tidak ditemukan.",
                  Duration = 3
               })
            end
         else
            Rayfield:Notify({
               Title = "Player Tidak Valid",
               Content = "Player tidak ditemukan atau belum punya karakter.",
               Duration = 3
            })
         end
      else
         Rayfield:Notify({
            Title = "Belum Pilih",
            Content = "Silakan pilih player dulu.",
            Duration = 3
         })
      end
   end
})

TeleportTab:CreateButton({
   Name = "Refresh Daftar Player",
   Callback = function()
      local updatedList = GetPlayerList()
      teleportDropdown:Refresh(updatedList)
      selectedPlayer = nil
      teleportDropdown:Set({""})
      Rayfield:Notify({
         Title = "Daftar Diupdate",
         Content = "Silakan pilih ulang player.",
         Duration = 2
      })
   end
})

local NPCSearchBox
local NPCDropdown
local selectedNPC = nil

-- Ambil daftar NPC valid (bukan player & bisa diteleport)
local function GetValidSortedNPCList(filter)
    local npcNameSet = {}
    local allPlayers = game:GetService("Players"):GetPlayers()

    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") then
            -- Cek apakah ini karakter player
            local isPlayerCharacter = false
            for _, p in ipairs(allPlayers) do
                if p.Character == model then
                    isPlayerCharacter = true
                    break
                end
            end

            if not isPlayerCharacter then
                -- Cek apakah model punya part untuk teleport
                local hasValidPart = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
                if not hasValidPart then
                    for _, part in ipairs(model:GetDescendants()) do
                        if part:IsA("BasePart") then
                            hasValidPart = true
                            break
                        end
                    end
                end

                if hasValidPart then
                    if not filter or string.find(string.lower(model.Name), string.lower(filter)) then
                        npcNameSet[model.Name] = true
                    end
                end
            end
        end
    end

    local npcNames = {}
    for name in pairs(npcNameSet) do
        table.insert(npcNames, name)
    end
    table.sort(npcNames)
    return npcNames
end

-- Fungsi teleport ke NPC dengan nama
local function TeleportToNPC(name)
    local function findNPCByName(targetName)
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("Model") and descendant.Name == targetName and descendant:FindFirstChild("Humanoid") then
                return descendant
            end
        end
        return nil
    end

    local npc = findNPCByName(name)
    local char = game.Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if not npc or not hrp then return end

    local targetCFrame = nil
    if npc:FindFirstChild("HumanoidRootPart") then
        targetCFrame = npc.HumanoidRootPart.CFrame
    elseif npc.PrimaryPart then
        targetCFrame = npc.PrimaryPart.CFrame
    else
        for _, part in ipairs(npc:GetDescendants()) do
            if part:IsA("BasePart") then
                targetCFrame = part.CFrame
                break
            end
        end
    end

    if targetCFrame then
        hrp.CFrame = targetCFrame + Vector3.new(2, 2, 2)
    end
end

-- Dropdown NPC
NPCDropdown = TeleportTab:CreateDropdown({
    Name = "Pilih NPC (Auto Teleport)",
    Options = GetValidSortedNPCList(),
    CurrentOption = {""},
    MultipleOptions = false,
    Flag = "NPCSelector",
    Callback = function(option)
        if option[1] ~= "" then
            TeleportToNPC(option[1])
        end
    end
})

-- Search Box (untuk filter nama NPC)
NPCSearchBox = TeleportTab:CreateInput({
    Name = "Cari Nama NPC",
    PlaceholderText = "Contoh: Miner",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local filtered = GetValidSortedNPCList(text)
        NPCDropdown:Refresh(filtered)
    end
})

-- Tombol Refresh NPC
TeleportTab:CreateButton({
    Name = "🔄 Refresh Daftar NPC",
    Callback = function()
        NPCDropdown:Refresh(GetValidSortedNPCList())
        NPCDropdown:Set({""})
    end
})


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

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()
local LocalPlayer = Players.LocalPlayer
local teleportClickEnabled = false
local lastClickedCFrame = nil

-- Toggle untuk aktifkan mode teleport via klik + keybind
TeleportTab:CreateToggle({
   Name = "Aktifkan Klik Teleport (Butuh Keybind)",
   CurrentValue = false,
   Flag = "ClickTeleportToggle",
   Callback = function(state)
      teleportClickEnabled = state
   end,
})

-- Simpan posisi terakhir saat klik (tapi tidak teleport)
Mouse.Button1Down:Connect(function()
   if teleportClickEnabled and Mouse.Target then
      lastClickedCFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
   end
end)

-- Keybind untuk teleport ke tempat yang diklik
TeleportTab:CreateKeybind({
   Name = "Teleport ke Klik (Tekan untuk Pindah)",
   CurrentKeybind = "L",
   HoldToInteract = false,
   Flag = "ClickTeleportKeybind",
   Callback = function()
      if teleportClickEnabled and lastClickedCFrame then
         local char = LocalPlayer.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = lastClickedCFrame
         end
      end
   end,
})

TeleportTab:CreateButton({
   Name = "🛒 Teleport ke Traveling Merchant",
   Callback = function()
      local Players = game:GetService("Players")
      local LocalPlayer = Players.LocalPlayer
      local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if not HRP then return end

      local merchant = nil
      for _, obj in pairs(workspace:GetDescendants()) do
         -- Nama harus mengandung 'travel' dan bukan yang tetap
         local nameLower = string.lower(obj.Name)
         if (nameLower:find("travel") or nameLower:find("travelling")) and obj:IsA("Model") then
            -- Pastikan bukan merchant tetap
            if not nameLower:find("normal") and not nameLower:find("static") then
               merchant = obj
               break
            end
         end
      end

      local targetCFrame = nil
      if merchant then
         if merchant:FindFirstChild("HumanoidRootPart") then
            targetCFrame = merchant.HumanoidRootPart.CFrame
         elseif merchant.PrimaryPart then
            targetCFrame = merchant.PrimaryPart.CFrame
         else
            for _, part in ipairs(merchant:GetDescendants()) do
               if part:IsA("BasePart") then
                  targetCFrame = part.CFrame
                  break
               end
            end
         end
      end

      if targetCFrame then
         HRP.CFrame = targetCFrame + Vector3.new(2, 3, 2)
      else
         warn("Traveling Merchant tidak ditemukan atau tidak memiliki part yang valid.")
      end
   end
})


TeleportTab:CreateButton({
   Name = "🌀 Teleport ke Enchantment Altar",
   Callback = function()
      local altar = nil
      for _, v in pairs(workspace:GetDescendants()) do
         if v:IsA("BasePart") and v.Name:lower():find("enchant") then
            altar = v
            break
         end
      end

      local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if altar and hrp then
         hrp.CFrame = altar.CFrame + Vector3.new(0, 5, 0) -- agar tidak nyangkut di bawah
      end
   end
})


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