-- Global untuk menyimpan target
_G.TeleportTarget = nil

-- Fungsi untuk mengambil semua nama player (kecuali diri sendiri)
local function GetOtherPlayers()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local list = {}

    for _, p in pairs(players:GetPlayers()) do
        if p ~= localPlayer then
            table.insert(list, p.Name)
        end
    end

    return list
end

-- Dropdown Player
MainTab:CreateDropdown({
    Name = "Pilih Player Tujuan",
    Options = GetOtherPlayers(),
    CurrentOption = "",
    Flag = "TargetPlayer",
    Callback = function(Selected)
        _G.TeleportTarget = Selected
    end,
})

-- Tombol Teleport
MainTab:CreateButton({
    Name = "Teleport ke Player",
    Callback = function()
        if not _G.TeleportTarget then
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Belum pilih player!",
                Duration = 3
            })
            return
        end

        local targetPlayer = game.Players:FindFirstChild(_G.TeleportTarget)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local localHRP = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if localHRP then
                localHRP.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 2) -- offset sedikit
            end
        else
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Gagal teleport. Mungkin player sudah keluar.",
                Duration = 3
            })
        end
    end,
})
