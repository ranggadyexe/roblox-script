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