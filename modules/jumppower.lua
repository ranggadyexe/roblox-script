-- JumpPower
MainTab:CreateSlider({
   Name = "Loncat Tinggi",
   Range = {50, 500},
   Increment = 1,
   Suffix = "JumpPower",
   CurrentValue = 50,
   Flag = "Slider1",
   Callback = function(v)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
   end
})