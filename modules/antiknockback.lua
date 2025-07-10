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