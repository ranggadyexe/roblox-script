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

local InfoTab = Window:CreateTab("Script Info", 4483362458)
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
   Name = "Button Example",
   Callback = function()
      print("Button clicked!")
   end,
})

-- Toggle Infinite Jump
_G.InfiniteJumpConnection = nil

MainTab:CreateToggle({
   Name = "Loncat Loncat",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(enabled)
      if enabled then
         _G.InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
               humanoid:ChangeState("Jumping")
            end
         end)
      else
         if _G.InfiniteJumpConnection then
            _G.InfiniteJumpConnection:Disconnect()
            _G.InfiniteJumpConnection = nil
         end
      end
   end,
})


local Slider = MainTab:CreateSlider({
    Name = "Lari Ngibrit",
    Range = {16, 500},
    Increment = 10,
    Suffix = "Walkspeed",
    CurrentValue = 10,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
 })


 local Slider = MainTab:CreateSlider({
    Name = "Loncat Tinggi",
    Range = {50, 500},
    Increment = 10,
    Suffix = "JumpPower",
    CurrentValue = 10,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
    end,
 })


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
      else
         if _G.AntiAFKConnection then
            _G.AntiAFKConnection:Disconnect()
            _G.AntiAFKConnection = nil
         end
      end
   end,
})



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
      else
         if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
         end
      end
   end,
})



MainTab:CreateToggle({
   Name = "Graphic Kentang",
   CurrentValue = false,
   Flag = "LowGFX",
   Callback = function(enabled)
      if enabled then
         for _,v in pairs(game:GetDescendants()) do
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
   end,
})



-- Variabel koneksi Fly
_G.FlyConnection = nil

-- Toggle Fly
MainTab:CreateToggle({
   Name = "Terbang (BELOM OPTIMAL)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(enabled)
      local player = game.Players.LocalPlayer
      local char = player.Character or player.CharacterAdded:Wait()
      local hrp = char:WaitForChild("HumanoidRootPart")

      if enabled then
         -- Tambahkan BodyVelocity
         local bv = Instance.new("BodyVelocity")
         bv.Name = "FlyVelocity"
         bv.MaxForce = Vector3.new(0, math.huge, 0)
         bv.Velocity = Vector3.new(0, 0, 0)
         bv.Parent = hrp

         -- Jalankan loop untuk mempertahankan terbang
         _G.FlyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            bv.Velocity = Vector3.new(0, 50, 0) -- Ubah 50 jadi kecepatan naik
         end)
      else
         -- Stop fly
         if _G.FlyConnection then
            _G.FlyConnection:Disconnect()
            _G.FlyConnection = nil
         end

         -- Hapus BodyVelocity
         local bv = hrp:FindFirstChild("FlyVelocity")
         if bv then
            bv:Destroy()
         end
      end
   end,
})

local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local selectedPlayer = nil
local teleportDropdown = nil

-- Fungsi ambil daftar player (selain kita)
local function GetPlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

-- Buat dropdown awal
teleportDropdown = TeleportTab:CreateDropdown({
    Name = "Pilih Player Tujuan",
    Options = GetPlayerList(),
    CurrentOption = {""},
    MultipleOptions = false,
    Flag = "TeleportPlayer",
    Callback = function(option)
        selectedPlayer = option[1]
    end,
})

-- Tombol teleport
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
    end,
})

-- Tombol refresh dropdown
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
    end,
})
