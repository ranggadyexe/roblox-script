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