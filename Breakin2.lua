---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/breakin2.lua"))()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Break In 2",
	LoadingTitle = "Break In 2 Haryas Script",
	LoadingSubtitle = "by Haryas",
	Theme = "Default",
	ToggleUIKeybind = "RightShift",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "BreakIn2Config"
	},
	Discord = {
		Enabled = true,
		Invite = "https://discord.gg/M6Pcqt3AR9",
		RememberJoins = true
	},
	KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local DeleteTab = Window:CreateTab("Delete", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)

-- Anti-AFK System
local VirtualUser = game:GetService('VirtualUser')
local antiAFKConnection = nil

Tab:CreateToggle({
	Name = "Anti AFK",
	CurrentValue = false,
	Flag = "AntiAFK",
	Callback = function(enabled)
		if enabled then
			antiAFKConnection = task.spawn(function()
				while Rayfield.Flags["AntiAFK"].CurrentValue do
					VirtualUser:CaptureController()
					VirtualUser:ClickButton2(Vector2.new())
					task.wait(60)
				end
			end)
		else
			if antiAFKConnection then
				task.cancel(antiAFKConnection)
				antiAFKConnection = nil
			end
		end
	end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Character Update
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	hrp = newChar:WaitForChild("HumanoidRootPart")
end)

-- Haryas Godmode
PlayerTab:CreateToggle({
	Name = "Godmode",
	CurrentValue = false,
	Flag = "Godmode",
	Callback = function(Value)
		if Value then
			humanoid.MaxHealth = math.huge
			humanoid.Health = math.huge
		else
			humanoid.MaxHealth = 100
			humanoid.Health = 100
		end
	end
})

-- Haryas Speed
PlayerTab:CreateSlider({
	Name = "Walkspeed",
	Range = {16, 200},
	Increment = 5,
	Suffix = "Speed",
	CurrentValue = 16,
	Flag = "Walkspeed",
	Callback = function(Value)
		humanoid.WalkSpeed = Value
	end,
})

PlayerTab:CreateSlider({
	Name = "JumpPower", 
	Range = {50, 200},
	Increment = 5,
	Suffix = "Power",
	CurrentValue = 50,
	Flag = "JumpPower",
	Callback = function(Value)
		humanoid.JumpPower = Value
	end,
})

-- Haryas Kill All
CombatTab:CreateButton({
	Name = "Kill All Players",
	Callback = function()
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				plr.Character.Humanoid.Health = 0
			end
		end
	end,
})

-- Haryas Kill Aura
local KillAuraConn
CombatTab:CreateToggle({
	Name = "Kill Aura",
	CurrentValue = false,
	Flag = "KillAura",
	Callback = function(Value)
		if Value then
			KillAuraConn = RunService.Heartbeat:Connect(function()
				for _, plr in pairs(Players:GetPlayers()) do
					if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
						if dist < 20 then
							plr.Character.Humanoid.Health = 0
						end
					end
				end
			end)
		else
			if KillAuraConn then
				KillAuraConn:Disconnect()
			end
		end
	end
})

-- Haryas Delete Features (GitHub Style)
DeleteTab:CreateButton({
	Name = "Delete House",
	Callback = function()
		for _, obj in pairs(Workspace:GetChildren()) do
			if obj.Name:lower():find("house") or obj.Name:lower():find("building") then
				obj:Destroy()
			end
		end
	end,
})

DeleteTab:CreateButton({
	Name = "Delete Everything",
	Callback = function()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Parent ~= character then
				pcall(function() obj:Destroy() end)
			end
		end
	end,
})

DeleteTab:CreateButton({
	Name = "Delete Doors & Trees",
	Callback = function()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj.Name:lower():find("door") or obj.Name:lower():find("tree") then
				obj:Destroy()
			end
		end
	end,
})

-- Haryas Items
Tab:CreateButton({
	Name = "Get All Items",
	Callback = function()
		local items = {"Gun", "Knife", "Grenade", "Medkit", "Keycard", "Lockpick"}
		for _, itemName in pairs(items) do
			local tool = Instance.new("Tool")
			tool.Name = itemName
			tool.Parent = player.Backpack
		end
	end,
})

-- Haryas ESP
local ESPConn
Tab:CreateToggle({
	Name = "Item ESP",
	CurrentValue = false,
	Flag = "ItemESP",
	Callback = function(Value)
		if Value then
			ESPConn = RunService.Heartbeat:Connect(function()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if obj.Name:match("Gun|Knife|Medkit") and obj:IsA("BasePart") then
						local high = obj:FindFirstChild("HaryasESP") or Instance.new("Highlight")
						high.Name = "HaryasESP"
						high.FillColor = Color3.new(0,1,0)
						high.Parent = obj
					end
				end
			end)
		else
			if ESPConn then
				ESPConn:Disconnect()
			end
		end
	end
})

-- Haryas Fly
local FlyConn, BV
PlayerTab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Flag = "Fly",
	Callback = function(Value)
		if Value then
			BV = Instance.new("BodyVelocity")
			BV.MaxForce = Vector3.new(4000,4000,4000)
			BV.Velocity = Vector3.new(0,0,0)
			BV.Parent = hrp
			
			FlyConn = RunService.Heartbeat:Connect(function()
				local cam = Workspace.CurrentCamera.CFrame
				local move = Vector3.new(0,0,0)
				
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					move = move + cam.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					move = move - cam.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					move = move - cam.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					move = move + cam.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					move = move + Vector3.new(0,1,0)
				end
				
				BV.Velocity = move * 50
			end)
		else
			if BV then BV:Destroy() end
			if FlyConn then FlyConn:Disconnect() end
		end
	end
})

-- Haryas Noclip
local NoclipConn
PlayerTab:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Flag = "Noclip",
	Callback = function(Value)
		if Value then
			NoclipConn = RunService.Stepped:Connect(function()
				for _, part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end)
		else
			if NoclipConn then
				NoclipConn:Disconnect()
			end
		end
	end
})

Rayfield:Notify({
	Title = "Haryas Script Loaded!",
	Content = "Break In 2 by Haryas - Enjoy!",
	Duration = 4.5,
	Image = 4483362458
})

print("Haryas Break In 2 Script Loaded!")
print("Keybind: RightShift")
