---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/sharkbite2.lua"))()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Sharkbite 2",
	LoadingTitle = "Sharkbite 2 Haryas script",
	LoadingSubtitle = "by Haryas",
	Theme = "Default",
	ToggleUIKeybind = "K",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "SharkConfig"
	},
	Discord = {
		Enabled = true,
		Invite = "https://discord.gg/M6Pcqt3AR9",
		RememberJoins = true
	},
	KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458)

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
					task.wait(60) -- Every 60 seconds
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local hrp

local remote = nil
local sharkName = nil

local remotesFolder = ReplicatedStorage
	:WaitForChild("Projectiles")
	:WaitForChild("Events")
	:WaitForChild("Weapons")
	:WaitForChild("remotes")

local function hookRemote(remoteObject)
	local mt = getrawmetatable(game)
	setreadonly(mt, false)
	local oldNamecall = mt.__namecall
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if self == remoteObject and (method == "FireServer" or method == "InvokeServer") then
			remote = self.Name
		end
		return oldNamecall(self, ...)
	end)
end

for _, child in ipairs(remotesFolder:GetChildren()) do
	if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
		pcall(hookRemote, child)
	end
end

local afk = player.PlayerScripts:FindFirstChild("AFK")
if afk then afk:Destroy() end

local hud = player.PlayerScripts:FindFirstChild("HUD")
if hud then
	local oxygen = hud:FindFirstChild("Oxygen")
	if oxygen then oxygen:Destroy() end
end

local function updateHRP()
	character = player.Character or player.CharacterAdded:Wait()
	backpack = player:WaitForChild("Backpack")
	hrp = character:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(updateHRP)
if player.Character then updateHRP() end

local function getShark()
	local sharksFolder = workspace:FindFirstChild("Sharks")
	if sharksFolder then
		for _, shark in ipairs(sharksFolder:GetChildren()) do
			if shark:IsA("Model") then
				sharkName = shark.Name
				return
			end
		end
	end
	sharkName = nil
end

local function KillShark()
	for _ = 1, 20 do
		if sharkName and remote then
			local shark = workspace:WaitForChild("Sharks"):FindFirstChild(sharkName)
			remotesFolder:WaitForChild(remote):FireServer(shark, true)
		end
	end
end

Tab:CreateSection("Autofarm")

local runningConnection

Tab:CreateToggle({
	Name = "Auto Instakill shark [don't equip projectile weapons to work]",
	CurrentValue = false,
	Flag = "AutoKillShark",
	Callback = function(on)
		if on and (not getrawmetatable or not setreadonly or not newcclosure) then
			task.delay(0.2, function()
				Rayfield.Flags["AutoKillShark"]:Set(false)
			end)
			Rayfield:Notify({
				Title = "Executor too weak",
				Content = "Your executor does not support getrawmetatable, setreadonly, or newcclosure.",
				Duration = 3
			})
			return
		end

		if on then
			local angle = 0
			local speed = math.pi * 2
			local center = Vector3.new(0, -100, 0)
			local radius = 1000

			runningConnection = RunService.Heartbeat:Connect(function(dt)
				if not (player.Team and player.Team.Name == "Survivor" and hrp) then return end

				getShark()

				if not sharkName then
					Camera.CameraType = Enum.CameraType.Custom
					local chinook = workspace:FindFirstChild("Chinook")
					local interior = chinook and chinook:FindFirstChild("interior")
					if interior then
						hrp.CFrame = interior.CFrame
					end
				else
					local sharksFolder = workspace:FindFirstChild("Sharks")
					local shark = sharksFolder and sharksFolder:FindFirstChild(sharkName)
					if shark then
						local sharkPart = shark.PrimaryPart or shark:FindFirstChildWhichIsA("BasePart", true)
						if sharkPart then
							for _, tool in ipairs(backpack:GetChildren()) do
								if tool:IsA("Tool") then
									tool.Parent = character
								end
							end

							if not remote then
								local behind = sharkPart.CFrame * CFrame.new(0, 0, 50)
								hrp.CFrame = CFrame.new(behind.Position, sharkPart.Position)

								Camera.CameraType = Enum.CameraType.Scriptable
								Camera.CFrame = CFrame.new(behind.Position, sharkPart.Position)

								local equippedTool = character:FindFirstChildOfClass("Tool")
								if equippedTool then
									local vp = Camera.ViewportSize
									local cx, cy = vp.X / 2, vp.Y / 2
									VirtualInputManager:SendMouseMoveEvent(cx, cy, game)
									VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
									VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
									task.wait(1)
								end
							else
								Camera.CameraType = Enum.CameraType.Custom

								angle += speed * dt
								local t = (angle % (math.pi * 2)) / (math.pi * 2)
								local offset
								if t < 0.25 then
									offset = Vector3.new(radius, 0, -radius + 8 * radius * t)
								elseif t < 0.5 then
									offset = Vector3.new(radius - 8 * radius * (t - 0.25), 0, radius)
								elseif t < 0.75 then
									offset = Vector3.new(-radius, 0, radius - 8 * radius * (t - 0.5))
								else
									offset = Vector3.new(-radius + 8 * radius * (t - 0.75), 0, -radius)
								end
								hrp.CFrame = CFrame.new(center + offset, center)

								KillShark()
							end
						end
					end
				end
			end)

			player.CharacterAdded:Connect(updateHRP)
		else
			Camera.CameraType = Enum.CameraType.Custom
			if runningConnection then
				runningConnection:Disconnect()
				runningConnection = nil
			end
		end
	end
})

local AutoWinConnection
local SharksDescendantConnection
local DestructionParts = {}

local function addDestructionPart(part)
	table.insert(DestructionParts, part)
	part.AncestryChanged:Connect(function(_, parent)
		if parent then return end
		for i = #DestructionParts, 1, -1 do
			if DestructionParts[i] == part then
				table.remove(DestructionParts, i)
				break
			end
		end
	end)
end

local function getNearestSurvivorToPart(part)
	local nearestPlayer, nearestDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Team and plr.Team.Name == "Survivor" then
			local char = plr.Character
			local hrpTarget = char and char:FindFirstChild("HumanoidRootPart")
			if hrpTarget and not hrpTarget:FindFirstChild("Attachment") then
				local dist = (hrpTarget.Position - part.Position).Magnitude
				if dist < nearestDist then
					nearestDist = dist
					nearestPlayer = plr
				end
			end
		end
	end
	return nearestPlayer
end

Tab:CreateToggle({
	Name = "Auto win as shark",
	CurrentValue = false,
	Flag = "AutoWinShark",
	Callback = function(state)
		if state then
			local sharksFolder = workspace:FindFirstChild("Sharks")
			if sharksFolder then
				for _, d in ipairs(sharksFolder:GetDescendants()) do
					if d:IsA("BasePart") and d.Name == "DestructionPart" then
						addDestructionPart(d)
					end
				end
				SharksDescendantConnection = sharksFolder.DescendantAdded:Connect(function(desc)
					if desc:IsA("BasePart") and desc.Name == "DestructionPart" then
						addDestructionPart(desc)
					end
				end)
			end

			AutoWinConnection = RunService.Heartbeat:Connect(function()
				if not (player.Team and player.Team.Name == "Shark" and #DestructionParts > 0) then return end

				for i = #DestructionParts, 1, -1 do
					if not DestructionParts[i] or not DestructionParts[i].Parent then
						table.remove(DestructionParts, i)
					end
				end

				local count = #DestructionParts
				if count == 0 then return end

				local randomPart = DestructionParts[math.random(1, count)]
				local targetPlayer = getNearestSurvivorToPart(randomPart)
				if randomPart and targetPlayer and targetPlayer.Character then
					local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
					if targetHRP then
						randomPart.CFrame = CFrame.new(targetHRP.Position)
					end
				end
			end)
		else
			if AutoWinConnection then
				AutoWinConnection:Disconnect()
				AutoWinConnection = nil
			end
			if SharksDescendantConnection then
				SharksDescendantConnection:Disconnect()
				SharksDescendantConnection = nil
			end
			table.clear(DestructionParts)
		end
	end
})

Tab:CreateSection("Shark ESP")

local sharkESPConnections = {}

local function setSharkESP(enabled)
	local sharksFolder = workspace:FindFirstChild("Sharks")
	if not sharksFolder then return end

	for _, conn in ipairs(sharkESPConnections) do
		conn:Disconnect()
	end
	table.clear(sharkESPConnections)

	for _, shark in ipairs(sharksFolder:GetDescendants()) do
		if shark:IsA("Highlight") then
			shark.Enabled = enabled
			shark.OutlineTransparency = enabled and 0 or 1
			if enabled then
				table.insert(sharkESPConnections, shark:GetPropertyChangedSignal("Enabled"):Connect(function()
					if not shark.Enabled then shark.Enabled = true end
				end))
				table.insert(sharkESPConnections, shark:GetPropertyChangedSignal("OutlineTransparency"):Connect(function()
					if shark.OutlineTransparency ~= 0 then shark.OutlineTransparency = 0 end
				end))
			end
		end
	end
end

local function watchForNewSharks(toggleState)
	local sharksFolder = workspace:FindFirstChild("Sharks")
	if not sharksFolder then return end
	table.insert(sharkESPConnections, sharksFolder.DescendantAdded:Connect(function(desc)
		if desc:IsA("Highlight") then
			setSharkESP(toggleState)
		end
	end))
end

Tab:CreateToggle({
	Name = "Highlight sharks [ESP]",
	CurrentValue = false,
	Flag = "SharkESP",
	Callback = function(state)
		setSharkESP(state)
		watchForNewSharks(state)
	end
})

Tab:CreateSection("Auto Vase")

local VaseTouchParts = {}
local VaseConnections = {}
local VaseHeartbeat

local function AddVaseTouch(part)
	table.insert(VaseTouchParts, part)
	part.AncestryChanged:Connect(function(_, parent)
		if parent then return end
		for i, v in ipairs(VaseTouchParts) do
			if v == part then
				table.remove(VaseTouchParts, i)
				break
			end
		end
	end)
end

Tab:CreateToggle({
	Name = "Auto touch vases",
	CurrentValue = false,
	Flag = "AutoTouchVases",
	Callback = function(state)
		if state then
			local folder = workspace:FindFirstChild("Vases")
			if folder then
				for _, d in ipairs(folder:GetDescendants()) do
					if d:IsA("TouchTransmitter") then
						AddVaseTouch(d)
					end
				end
				table.insert(VaseConnections, folder.DescendantAdded:Connect(function(desc)
					if desc:IsA("TouchTransmitter") then
						AddVaseTouch(desc)
					end
				end))
			end

			VaseHeartbeat = RunService.Heartbeat:Connect(function()
				local charHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if not charHRP then return end
				for _, t in ipairs(VaseTouchParts) do
					if t and t.Parent and t.Parent:IsA("BasePart") then
						local part = t.Parent
						charHRP.CFrame = part.CFrame
						firetouchinterest(charHRP, part, 0)
						firetouchinterest(charHRP, part, 1)
					end
				end
			end)
		else
			for _, c in ipairs(VaseConnections) do c:Disconnect() end
			table.clear(VaseConnections)
			table.clear(VaseTouchParts)
			if VaseHeartbeat then
				VaseHeartbeat:Disconnect()
				VaseHeartbeat = nil
			end
		end
	end
})
