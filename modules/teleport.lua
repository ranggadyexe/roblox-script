-- modules/teleport.lua
-- Teleport ke player manapun di game

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variabel untuk menyimpan target pemain
_G.TeleportTargetPlayer = nil

_G.SetTeleportTarget = function(name)
    _G.TeleportTargetPlayer = name
end

_G.TeleportToPlayer = function()
    if not _G.TeleportTargetPlayer then
        warn("Belum memilih player!")
        return
    end

    local targetPlayer = Players:FindFirstChild(_G.TeleportTargetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position

        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0)) -- sedikit di atas biar gak nyangkut
        end
    else
        warn("Player tidak ditemukan atau belum spawn.")
    end
end

-- Untuk ambil semua nama pemain saat ini
_G.GetAllPlayerNames = function()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end
