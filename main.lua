local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DEWA SLEBEW",
   Icon = 0,
   LoadingTitle = "SCRIPT UNIVERSAL",
   LoadingSubtitle = "by DEWA ANJAY SLEBEW",
   ShowText = "DEWA",
   Theme = "Default",
   ToggleUIKeybind = "K",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "DEWA Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local InfoTab = Window:CreateTab("Script Info", 4483362458)
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
   Name = "Button Example",
   Callback = function()
      print("Button clicked!")
   end,
})

-- Toggle Infinite Jump
_G.InfiniteJumpConnection = nil

MainTab:CreateToggle({
   Name = "Loncat Loncat (Infinite Jump)",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(enabled)
      if enabled then
         _G.InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
               humanoid:ChangeState("Jumping")
            end
         end)
      else
         if _G.InfiniteJumpConnection then
            _G.InfiniteJumpConnection:Disconnect()
            _G.InfiniteJumpConnection = nil
         end
      end
   end,
})

local Slider = Tab:CreateSlider({
   Name = "LARI NGIBRIT",
   Range = {0, 100},
   Increment = 10,
   Suffix = "Bananas",
   CurrentValue = 10,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- The function that takes place when the slider changes
   -- The variable (Value) is a number which correlates to the value the slider is currently at
   end,
})