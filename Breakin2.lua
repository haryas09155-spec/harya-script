---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/Breakin2.lua"))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Haryas Watermark
local Watermark = Rayfield:CreateWindow({
   Name = Haryas script,
   LoadingTitle = "Haryas script",
   LoadingSubtitle = "by Haryas",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Haryasscript",
      FileName = "Breakin2"
   },
   KeySystem = false, -- Haryas Keyless Access
   KeySettings = {
      Title = "Haryas Key Auth",
      Subtitle = "Premium Key Required",
      Note = "Join Discord for FREE Key!",
      FileName = "HaryasKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = "HaryasFreeKey2026"
   }
})

-- Main Window
local HaryasWindow = Rayfield:CreateWindow({
   Name = "Haryas script",
   LoadingTitle = "Haryas script",
   LoadingSubtitle = "by Haryas",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HaryasBreakin2",
      FileName = "HaryasConfig"
   },
   Discord = {
      Enabled = true,
      Invite = "https://discord.gg/M6Pcqt3AR9", -- Haryas Discord
      RememberJoins = true
   },
   KeySystem = false
})

-- // HARYAS TABS // 
local MainTab = HaryasWindow:CreateTab("🎯 Main", 4483362458)
local CombatTab = HaryasWindow:CreateTab("⚔️ Combat", 4483362458)
local DeleteTab = HaryasWindow:CreateTab("💥 Delete", 4483362458)
local PlayerTab = HaryasWindow:CreateTab("👤 Player", 4483362458)
local ItemsTab = HaryasWindow:CreateTab("🎒 Items", 4483362458)
local VisualsTab = HaryasWindow:CreateTab("👁️ Visuals", 4483362458)

-- // HARYAS FUNCTIONS //
local HaryasFunctions = {}

-- Haryas Godmode (Premium)
function HaryasFunctions:GodMode()
   Humanoid.MaxHealth = math.huge
   Humanoid.Health = math.huge
   Rayfield:Notify({
      Title = "Godmode",
      Content = "Activated! 🛡️",
      Duration = 2.5,
      Image = 4483362458
   })
end

-- Haryas Delete Everything
function HaryasFunctions:DeleteEverything()
   for _, obj in pairs(Workspace:GetDescendants()) do
      if obj:IsA("BasePart") and obj.Parent ~= Character and obj.Name ~= "Baseplate" then
         obj:Destroy()
      end
   end
   Rayfield:Notify({Title = "Delete", Content = "Map Destroyed! 💥", Duration = 3})
end

-- Haryas Kill Aura (Radius 50)
_G.HaryasKillAura = false
function HaryasFunctions:KillAura()
   _G.HaryasKillAura = not _G.HaryasKillAura
   spawn(function()
      while _G.HaryasKillAura do
         for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
               local dist = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
               if dist < 50 then
                  player.Character.Humanoid.Health = 0
               end
            end
         end
         wait(0.1)
      end
   end)
end

-- Haryas Item Giver
function HaryasFunctions:GiveAllItems()
   local HaryasItems = {"Gun", "Knife", "Grenade", "Medkit", "Keycard", "Lockpick", "Armor", "VIP Pass", "Hacker Tool"}
   for _, item in pairs(HaryasItems) do
      local Tool = Instance.new("Tool")
      Tool.Name = "Haryas " .. item
      Tool.Parent = LocalPlayer.Backpack
   end
end

-- // MAIN TAB - HARYAS MAIN FEATURES //
MainTab:CreateSection("🚀 Haryas Premium Features")

local HaryasMasterToggle = MainTab:CreateToggle({
   Name = "Haryas Master Switch",
   CurrentValue = false,
   Callback = function(Value)
      _G.HaryasMaster = Value
      if Value then
         HaryasFunctions:GodMode()
         HaryasFunctions:GiveAllItems()
      end
   end
})

MainTab:CreateButton({
   Name = "💎 Haryas VIP Unlock",
   Callback = function()
      LocalPlayer:SetAttribute("HaryasVIP", true)
      LocalPlayer.DisplayName = "HaryasVIP"
      Rayfield:Notify({Title = "VIP", Content = "Haryas VIP Unlocked!", Duration = 4})
   end
})

-- // COMBAT TAB //
CombatTab:CreateToggle({
   Name = "🔥 Haryas Kill Aura (50 Studs)",
   CurrentValue = false,
   Callback = function(Value)
      HaryasFunctions:KillAura()
   end
})

CombatTab:CreateButton({
   Name = "☠️ Kill All Players",
   Callback = function()
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer then
            if player.Character then
               player.Character.Humanoid.Health = 0
            end
         end
      end
   end
})

-- // DELETE TAB - HARYAS DESTRUCTION //
DeleteTab:CreateButton({
   Name = "🏠 Delete House",
   Callback = function()
      for _, obj in pairs(Workspace:GetChildren()) do
         if obj.Name:lower():find("house") or obj.Name:lower():find("building") then
            obj:Destroy()
         end
      end
   end
})

DeleteTab:CreateButton({
   Name = "🌍 Delete Everything",
   Callback = function()
      HaryasFunctions:DeleteEverything()
   end
})

DeleteTab:CreateButton({
   Name = "🚪 Delete All Doors",
   Callback = function()
      for _, obj in pairs(Workspace:GetDescendants()) do
         if obj.Name:lower():find("door") then
            obj:Destroy()
         end
      end
   end
})

-- // PLAYER TAB //
PlayerTab:CreateToggle({
   Name = "🛡️ Haryas Godmode",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         HaryasFunctions:GodMode()
      else
         Humanoid.MaxHealth = 100
         Humanoid.Health = 100
      end
   end
})

PlayerTab:CreateSlider({
   Name = "🚀 Haryas Speed",
   Range = {16, 500},
   Increment = 10,
   CurrentValue = 16,
   Callback = function(Value)
      Humanoid.WalkSpeed = Value
   end
})

PlayerTab:CreateToggle({
   Name = "✈️ Haryas Fly",
   CurrentValue = false,
   Callback = function(Value)
      _G.HaryasFly = Value
      local BV = Instance.new("BodyVelocity")
      BV.MaxForce = Vector3.new(9e9,9e9,9e9)
      BV.Parent = RootPart
      
      RunService.Heartbeat:Connect(function()
         if _G.HaryasFly then
            local Cam = Workspace.CurrentCamera.CFrame
            BV.Velocity = Vector3.new(
               (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
               (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
               (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
            ) * 50
         end
      end)
   end
})

-- // ITEMS TAB //
ItemsTab:CreateButton({
   Name = "🎒 Haryas Get All Items",
   Callback = function()
      HaryasFunctions:GiveAllItems()
   end
})

-- // VISUALS TAB //
VisualsTab:CreateToggle({
   Name = "👁️ Haryas ESP (Items/Players)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:find("Gun") or obj.Name:find("Knife")) then
               local Highlight = Instance.new("Highlight")
               Highlight.FillColor = Color3.new(0,1,0)
               Highlight.Parent = obj
            end
         end
      end
   end
})

-- // HARYAS NOTIFICATION //
Rayfield:Notify({
   Title = "🟢 Haryas Hub Loaded!",
   Content = "Breakin2 by Haryas#0001 | Premium Features Active",
   Duration = 6,
   Image = 4483362458
})

-- // CONSOLE WATERMARK //
print("=== Haryas Hub Loaded ===")
print("Script: Breakin2 by Haryas")
print("Discord: discord.gg/haryas")
print("Keybind: RightShift")
print("All features unlocked!")

-- // AUTO CHARACTER UPDATE //
LocalPlayer.CharacterAdded:Connect(function(Char)
   Character = Char
   Humanoid = Char:WaitForChild("Humanoid")
   RootPart = Char:WaitForChild("HumanoidRootPart")
end)
