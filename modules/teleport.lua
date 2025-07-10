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