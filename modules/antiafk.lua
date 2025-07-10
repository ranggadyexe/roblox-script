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