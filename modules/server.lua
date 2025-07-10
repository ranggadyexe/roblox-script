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
