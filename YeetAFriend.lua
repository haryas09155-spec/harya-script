---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/YeetAFriend.lua"))()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Yeet A Friend",
	LoadingTitle = "Yeet A Friend Haryas script",
	LoadingSubtitle = "by Haryas",
	Theme = "Default",
	ToggleUIKeybind = "RightControl",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "YeetConfig"
	},
	Discord = {
		Enabled = false,
		Invite = "",
		RememberJoins = true
	},
	KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

-- Anti-AFK System
local VirtualUser = game:GetService('VirtualUser')
local antiAFKConnection = nil

MainTab:CreateToggle({
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

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local character, hrp

local remoteSpam = nil
local yeetConnection = nil

-- Update character
local function updateCharacter()
	character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	hrp = character:WaitForChild("HumanoidRootPart")
end

LocalPlayer.CharacterAdded:Connect(updateCharacter)
if LocalPlayer.Character then updateCharacter() end

-- Remote hook for dynamic detection
local remotesFolder = ReplicatedStorage
local hookedRemotes = {}

local function hookRemote(remoteObject)
	local mt = getrawmetatable(game)
	if not mt then return end
	setreadonly(mt, false)
	local oldNamecall = mt.__namecall
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if self == remoteObject and (method == "FireServer" or method == "InvokeServer") then
			table.insert(hookedRemotes, self.Name)
		end
		return oldNamecall(self, ...)
	end)
	setreadonly(mt, true)
end

-- Hook all remotes
for _, child in ipairs(remotesFolder:GetDescendants()) do
	if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
		pcall(hookRemote, child)
	end
end

MainTab:CreateSection("Infinite Currency")

MainTab:CreateToggle({
	Name = "Infinite Rubux/Pets/Stats",
	CurrentValue = false,
	Flag = "InfiniteCurrency",
	Callback = function(enabled)
		if enabled and (not getrawmetatable or not setreadonly or not newcclosure) then
			Rayfield.Flags["InfiniteCurrency"]:Set(false)
			Rayfield:Notify({
				Title = "Executor Error",
				Content = "Needs F9 support (getrawmetatable)",
				Duration = 3
			})
			return
		end

		if enabled then
			remoteSpam = RunService.Heartbeat:Connect(function()
				if not Rayfield.Flags["InfiniteCurrency"].CurrentValue then return end
				
				pcall(function()
					for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
						if remote:IsA("RemoteEvent") then
							local name = remote.Name:lower()
							if name:find("rubux") or name:find("money") or name:find("coin") or name:find("pet") or name:find("claim") then
								remote:FireServer(999999999, "All")
							elseif name:find("stats") or name:find("upgrade") or name:find("strength") then
								for i = 1, 12 do remote:FireServer(i, 999999999) end
							elseif name:find("hatch") or name:find("egg") then
								remote:FireServer("Rainbow", 999)
							end
						end
					end
				end)
			end)
		else
			if remoteSpam then
				remoteSpam:Disconnect()
				remoteSpam = nil
			end
		end
	end
})

MainTab:CreateSection("Auto Farm")

local farmConnection = nil

MainTab:CreateToggle({
	Name = "Auto Collect Stars/Coins",
	CurrentValue = false,
	Flag = "AutoCollect",
	Callback = function(enabled)
		if enabled then
			farmConnection = RunService.Heartbeat:Connect(function()
				if not Rayfield.Flags["AutoCollect"].CurrentValue then return end
				
				pcall(function()
					-- Touch collectibles
					for _, obj in pairs(Workspace:GetChildren()) do
						if obj:IsA("BasePart") and (obj.Name:lower():find("star") or obj.Name:lower():find("coin") or obj.Name:lower():find("gem")) then
							firetouchinterest(hrp, obj, 0)
							firetouchinterest(hrp, obj, 1)
						end
					end
					
					-- Fire collect remotes
					local collectRemote = ReplicatedStorage:FindFirstChild("CollectRemote") or ReplicatedStorage:FindFirstChild("ClaimRemote")
					if collectRemote then collectRemote:FireServer() end
				end)
			end)
		else
			if farmConnection then
				farmConnection:Disconnect()
				farmConnection = nil
			end
		end
	end
})

MainTab:CreateToggle({
	Name = "Auto Rebirth",
	CurrentValue = false,
	Flag = "AutoRebirth",
	Callback = function(enabled)
		if enabled then
			task.spawn(function()
				while Rayfield.Flags["AutoRebirth"].CurrentValue do
					pcall(function()
						local rebirthRemote = ReplicatedStorage:FindFirstChild("RebirthRemote") or ReplicatedStorage:FindFirstChild("ReincarnateRemote")
						if rebirthRemote then
							rebirthRemote:FireServer()
						end
					end)
					task.wait(3)
				end
			end)
		end
	end
})

MainTab:CreateSection("Combat")

local yeetEnabled = false

MainTab:CreateToggle({
	Name = "Super Yeet (Hold E)",
	CurrentValue = false,
	Flag = "SuperYeet",
	Callback = function(enabled)
		yeetEnabled = enabled
		Rayfield:Notify({
			Title = "Super Yeet",
			Content = enabled and "✅ Hold E to YEET" or "❌ Disabled",
			Duration = 2
		})
	end
})

-- Yeet handler
UserInputService.InputBegan:Connect(function(input)
	if yeetEnabled and input.KeyCode == Enum.KeyCode.E then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local targetHRP = player.Character.HumanoidRootPart
				local dist = (hrp.Position - targetHRP.Position).Magnitude
				
				if dist < 50 then
					local bv = Instance.new("BodyVelocity")
					bv.MaxForce = Vector3.new(50000, 50000, 50000)
					bv.Velocity = hrp.CFrame.LookVector * 150 + Vector3.new(0, 200, 0)
					bv.Parent = targetHRP
					
					local spin = Instance.new("BodyAngularVelocity")
					spin.MaxTorque = Vector3.new(50000, 50000, 50000)
					spin.AngularVelocity = Vector3.new(math.random(-100,100), math.random(-100,100), math.random(-100,100))
					spin.Parent = targetHRP
					
					game:GetService("Debris"):AddItem(bv, 3)
					game:GetService("Debris"):AddItem(spin, 3)
				end
			end
		end
	end
end)

MainTab:CreateSection("Godmode")

MainTab:CreateToggle({
	Name = "Godmode + Noclip",
	CurrentValue = false,
	Flag = "Godmode",
	Callback = function(enabled)
		if enabled then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			humanoid.MaxHealth = math.huge
			humanoid.Health = math.huge
			
			local noclipConn = RunService.Stepped:Connect(function()
				if not Rayfield.Flags["Godmode"].CurrentValue then
					noclipConn:Disconnect()
					return
				end
				for _, part in pairs(character:GetChildren()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end)
		else
			pcall(function()
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				humanoid.MaxHealth = 100
				humanoid.Health = 100
			end)
		end
	end
})

MainTab:CreateToggle({
	Name = "Player ESP",
	CurrentValue = false,
	Flag = "PlayerESP",
	Callback = function(enabled)
		if enabled then
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local highlight = Instance.new("Highlight")
					highlight.FillColor = Color3.new(1, 0, 0)
					highlight.OutlineColor = Color3.new(1, 1, 1)
					highlight.Parent = player.Character
				end
			end
		else
			for _, obj in pairs(Workspace:GetDescendants()) do
				if obj:IsA("Highlight") then obj:Destroy() end
			end
		end
	end
})

MainTab:CreateSection("Speed")

local speedSlider = MainTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {16, 500},
	Increment = 10,
	CurrentValue = 50,
	Flag = "WalkSpeed",
	Callback = function(value)
		pcall(function()
			character.Humanoid.WalkSpeed = value
		end)
	end
})

LocalPlayer.CharacterAdded:Connect(function(newChar)
	newChar:WaitForChild("Humanoid").WalkSpeed = Rayfield.Flags["WalkSpeed"].CurrentValue or 16
end)

-- YEET ALL Button
MainTab:CreateButton({
	Name = "YEET EVERYONE (1-Click)",
	Callback = function()
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local targetHRP = player.Character.HumanoidRootPart
				local bv = Instance.new("BodyVelocity")
				bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
				bv.Velocity = Vector3.new(math.random(-300,300), 500, math.random(-300,300))
				bv.Parent = targetHRP
				game.Debris:AddItem(bv, 5)
			end
		end
		Rayfield:Notify({
			Title = "MASS YEET",
			Content = "💥 Everyone flung!",
			Duration = 3
		})
	end
})

Rayfield:Notify({
	Title = "Yeet A Friend Loaded ✅",
	Content = "All toggles working!\nHold E for Super Yeet\nRightControl = Toggle UI",
	Duration = 6,
	Image = 4483362458
})
