local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Be a Lucky Block",
    SubTitle = "by Haryas script",
    TabWidth = 160,
    Size = UDim2.fromOffset(550, 430),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "box" }),
    Upgrades = Window:AddTab({ Title = "Upgrades", Icon = "gauge" }),
    Brainrots = Window:AddTab({ Title = "Brainrots", Icon = "bot" }),
    Stats = Window:AddTab({ Title = "Stats", Icon = "chart-column" }),
    EggFarm = Window:AddTab({ Title = "Egg Farm", Icon = "egg" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Services Cache
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Helper function to find your model
local function getMyModel()
    local folder = workspace:FindFirstChild("RunningModels")
    if not folder then return nil end
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("OwnerId") == player.UserId then
            return model
        end
    end
    return nil
end

-- Main Tab Features
do
    local claimGift = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PlaytimeRewardService"):WaitForChild("RF"):WaitForChild("ClaimGift")
    local autoClaiming = false
    
    local ACPR = Tabs.Main:AddToggle("ACPR", {
        Title = "Auto Claim Playtime Rewards",
        Default = false
    })
    
    ACPR:OnChanged(function(state)
        autoClaiming = state
        if not state then return end
        task.spawn(function()
            while autoClaiming do
                for reward = 1, 12 do
                    if not autoClaiming then break end
                    pcall(function() claimGift:InvokeServer(reward) end)
                    task.wait(0.25)
                end
                task.wait(1)
            end
        end)
    end)

    local rebirth = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("RebirthService"):WaitForChild("RF"):WaitForChild("Rebirth")
    local rebirthRunning = false
    
    local AR = Tabs.Main:AddToggle("AR", {
        Title = "Auto Rebirth",
        Default = false
    })
    
    AR:OnChanged(function(state)
        rebirthRunning = state
        if not state then return end
        task.spawn(function()
            while rebirthRunning do
                pcall(function() rebirth:InvokeServer() end)
                task.wait(1)
            end
        end)
    end)

    local redeem = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("CodesService"):WaitForChild("RF"):WaitForChild("RedeemCode")
    local codes = {"release"}
    
    Tabs.Main:AddButton({
        Title = "Redeem All Codes",
        Callback = function()
            for _, code in ipairs(codes) do
                pcall(function() redeem:InvokeServer(code) end)
                task.wait(1)
            end
        end
    })

    Tabs.Main:AddButton({
        Title = "Sell Held Brainrot",
        Callback = function()
            Window:Dialog({
                Title = "Confirm Sale", Content = "Sell held Brainrot?",
                Buttons = {
                    {Title = "Confirm", Callback = function()
                        local character = player.Character or player.CharacterAdded:Wait()
                        local tool = character:FindFirstChildOfClass("Tool")
                        if not tool then
                            Fluent:Notify({Title = "ERROR!", Content = "Equip Brainrot first!", Duration = 5})
                            return
                        end
                        local entityId = tool:GetAttribute("EntityId")
                        if entityId then
                            local sellBrainrot = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.InventoryService.RF.SellBrainrot
                            sellBrainrot:InvokeServer(entityId)
                            Fluent:Notify({Title = "SOLD!", Content = "Sold: " .. tool.Name, Duration = 5})
                        end
                    end},
                    {Title = "Cancel", Callback = function() end}
                }
            })
        end
    })
end

-- Upgrades Tab
do
    Tabs.Upgrades:AddSection("Speed Upgrades")
    
    local upgrade = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("UpgradesService"):WaitForChild("RF"):WaitForChild("Upgrade")
    local amount = 1
    local delayTime = 0.5
    local upgradeRunning = false
    
    local IMS = Tabs.Upgrades:AddInput("IMS", {
        Title = "Speed Amount", Default = "1", Placeholder = "Number",
        Numeric = true, Finished = false,
        Callback = function(Value) amount = tonumber(Value) or 1 end
    })
    
    local SMS = Tabs.Upgrades:AddSlider("SMS", {
        Title = "Upgrade Interval", Default = 1, Min = 0, Max = 5, Rounding = 1,
        Callback = function(Value) delayTime = Value end
    })
    
    local AMS = Tabs.Upgrades:AddToggle("AMS", {Title = "Auto Upgrade Speed", Default = false})
    
    AMS:OnChanged(function(state)
        upgradeRunning = state
        if not state then return end
        task.spawn(function()
            while upgradeRunning do
                pcall(function() upgrade:InvokeServer("MovementSpeed", amount) end)
                task.wait(delayTime)
            end
        end)
    end)
end

-- Brainrots Tab
do
    local storedParts = {}
    local folder = workspace:WaitForChild("BossTouchDetectors")
    
    local RBTD = Tabs.Brainrots:AddToggle("RBTD", {
        Title = "Remove Bad Boss Touch Detectors",
        Description = "Only base15 boss can capture you",
        Default = false
    })
    
    RBTD:OnChanged(function(state)
        if state then
            storedParts = {}
            for _, obj in ipairs(folder:GetChildren()) do
                if obj.Name ~= "base15" then
                    table.insert(storedParts, obj)
                    obj.Parent = nil
                end
            end
        else
            for _, obj in ipairs(storedParts) do
                if obj then obj.Parent = folder end
            end
            storedParts = {}
        end
    end)

    Tabs.Brainrots:AddButton({
        Title = "Teleport to End",
        Callback = function()
            local modelsFolder = workspace:WaitForChild("RunningModels")
            local target = workspace:WaitForChild("CollectZones"):WaitForChild("base15")
            for _, obj in ipairs(modelsFolder:GetChildren()) do
                if obj:IsA("Model") and obj.PrimaryPart then
                    obj:SetPrimaryPartCFrame(target.CFrame)
                end
            end
        end
    })

    local autoFarmRunning = false
    
    local AutoFarmToggle = Tabs.Brainrots:AddToggle("AutoFarmToggle", {
        Title = "Auto Farm Best Brainrots (MOVING)",
        Default = false
    })
    
    AutoFarmToggle:OnChanged(function(state)
        autoFarmRunning = state
        if state then
            task.spawn(function()
                while autoFarmRunning do
                    local myModel = getMyModel()
                    if not myModel or not myModel.PrimaryPart then
                        task.wait(1) continue
                    end
                    
                    local rootPart = myModel.PrimaryPart
                    local targetZone = workspace.CollectZones:FindFirstChild("base15")
                    if targetZone then
                        local distance = (rootPart.Position - targetZone.Position).Magnitude
                        local steps = math.max(20, distance / 10)
                        
                        for i = 1, steps do
                            if not autoFarmRunning then break end
                            local alpha = i / steps
                            local newPos = rootPart.Position:Lerp(targetZone.Position + Vector3.new(0, 5, 0), alpha)
                            rootPart.CFrame = CFrame.new(newPos)
                            task.wait(0.05)
                        end
                        
                        task.wait(1)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end)
end

-- Stats Tab (Custom Speed)
do
    local speedRunning = false
    local sliderValue = 1000
    
    task.spawn(function()
        while true do
            if speedRunning then
                local model = getMyModel()
                if model then
                    model:SetAttribute("MovementSpeed", sliderValue)
                end
            end
            task.wait(0.2)
        end
    end)
    
    local Toggle = Tabs.Stats:AddToggle("MovementToggle", {
        Title = "Enable Custom Lucky Block Speed", Default = false
    })
    
    Toggle:OnChanged(function()
        speedRunning = Options.MovementToggle.Value
    end)
    
    local Slider = Tabs.Stats:AddSlider("MovementSlider", {
        Title = "Lucky Block Speed", Default = 1000, Min = 50, Max = 3000, Rounding = 0,
        Callback = function(Value) sliderValue = Value end
    })
end

-- EGG FARM TAB - FIXED
do
    local eggFarmRunning = false
    local currentPatrolIndex = 1
    local eggSpeed = 1000
    local patrolPoints = {}
    local centerPos = nil
    
    local AutoEggFarm = Tabs.EggFarm:AddToggle("AutoEggFarm", {
        Title = "Auto Farm Eggs",
        Description = "Auto Farm Eggs",
        Default = false
    })
    
    AutoEggFarm:OnChanged(function(state)
        eggFarmRunning = state
        
        if state then
            local bossFolder = workspace:FindFirstChild("BossTouchDetectors")
            if bossFolder then
                for _, obj in ipairs(bossFolder:GetChildren()) do
                    if obj.Name ~= "base15" then obj.Parent = nil end
                end
            end
            
            task.spawn(function()
                local myModel = getMyModel()
                if not myModel or not myModel.PrimaryPart then
                    eggFarmRunning = false
                    return
                end
                
                centerPos = myModel.PrimaryPart.Position
                patrolPoints = {
                    centerPos + Vector3.new(80, 0, 0),
                    centerPos + Vector3.new(0, 0, 80),
                    centerPos + Vector3.new(-80, 0, 0),
                    centerPos + Vector3.new(0, 0, -80),
                    centerPos + Vector3.new(60, 0, 60),
                    centerPos + Vector3.new(-60, 0, -60),
                }
                currentPatrolIndex = 1
                
                while eggFarmRunning do
                    local myModel = getMyModel()
                    if not myModel or not myModel.PrimaryPart then
                        task.wait(1)
                        continue
                    end
                    
                    local rootPart = myModel.PrimaryPart
                    myModel:SetAttribute("MovementSpeed", eggSpeed)
                    
                    local targetPos = patrolPoints[currentPatrolIndex]
                    local distance = (rootPart.Position - targetPos).Magnitude
                    local steps = math.max(30, distance / 8)
                    
                    for i = 1, steps do
                        if not eggFarmRunning then break end
                        local alpha = i / steps
                        local newPos = rootPart.Position:Lerp(targetPos, alpha)
                        rootPart.CFrame = CFrame.new(newPos)
                        task.wait(0.03)
                    end
                    
                    currentPatrolIndex = (currentPatrolIndex % #patrolPoints) + 1
                    task.wait(0.8)
                end
            end)
        end
    end)
    
    local EggSpeedSlider = Tabs.EggFarm:AddSlider("EggSpeed", {
        Title = "Egg Farm Speed", Default = 1000, Min = 100, Max = 3000, Rounding = 0,
        Callback = function(Value)
            eggSpeed = Value
            local myModel = getMyModel()
            if myModel then
                myModel:SetAttribute("MovementSpeed", eggSpeed)
            end
        end
    })
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

Fluent:Notify({
    Title = "Join discord", 
    Content = "join discord",
    Duration = 5
})
