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