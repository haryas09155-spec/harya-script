local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/jacklebeignet/Fluent-Reborn/refs/heads/main/src/ui.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

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
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    -----
    -----
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local success, claimGift = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages", 10)
            :WaitForChild("_Index", 10)
            :WaitForChild("sleitnick_knit@1.7.0", 10)
            :WaitForChild("knit", 10)
            :WaitForChild("Services", 10)
            :WaitForChild("PlaytimeRewardService", 10)
            :WaitForChild("RF", 10)
            :WaitForChild("ClaimGift", 10)
    end)
    
    if success and claimGift then
        Tabs.Main:AddButton({
            Title = "Claim Gift",
            Callback = function()
                pcall(function()
                    claimGift:FireServer()
                end)
            end
        })
    end

    -- Add your other Main tab features here (e.g., auto-collect, teleports) following similar pcall pattern

    -----
    -----

    Tabs.Brainrots:AddSection("Farming")
    local running = false
    local AutoFarmToggle = Tabs.Brainrots:AddToggle("AutoFarmToggle", {
        Title = "Auto Farm Best Brainrots",
        Default = false
    })
    AutoFarmToggle:OnChanged(function(state)
        running = state
        if state then
            task.spawn(function()
                while running do
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:WaitForChild("HumanoidRootPart")
                    local humanoid = character:WaitForChild("Humanoid")
                    local userId = player.UserId
                    local modelsFolder = workspace:WaitForChild("RunningModels", 10)
                    local target = workspace:WaitForChild("CollectZones", 10) and workspace.CollectZones:WaitForChild("base15", 10)
                    
                    if not modelsFolder or not target then
                        task.wait(1)
                        continue
                    end
                    
                    root.CFrame = CFrame.new(715, 39, -2122)
                    task.wait(0.3)
                    humanoid:MoveTo(Vector3.new(710, 39, -2122))
                    
                    local ownedModel = nil
                    repeat
                        task.wait(0.3)
                        for _, obj in ipairs(modelsFolder:GetChildren()) do
                            if obj:IsA("Model") and obj:GetAttribute("OwnerId") == userId then
                                ownedModel = obj
                                break
                            end
                        end
                    until ownedModel ~= nil or not running
                    
                    if not running then break end
                    
                    pcall(function()
                        if ownedModel.PrimaryPart then
                            ownedModel:SetPrimaryPartCFrame(target.CFrame)
                        else
                            local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                            if part then
                                part.CFrame = target.CFrame
                            end
                        end
                    end)
                    
                    task.wait(0.7)
                    
                    pcall(function()
                        if ownedModel and ownedModel.Parent == modelsFolder then
                            local newCFrame = target.CFrame * CFrame.new(0, -5, 0)
                            if ownedModel.PrimaryPart then
                                ownedModel:SetPrimaryPartCFrame(newCFrame)
                            else
                                local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    part.CFrame = newCFrame
                                end
                            end
                        end
                    end)
                    
                    repeat task.wait(0.3) until not running or (not ownedModel or ownedModel.Parent ~= modelsFolder)
                    if not running then break end
                    
                    local oldCharacter = player.Character
                    repeat task.wait(0.2) until not running or (player.Character ~= oldCharacter and player.Character)
                    if not running then break end
                    
                    task.wait(0.4)
                    local newChar = player.Character
                    if newChar then
                        local newRoot = newChar:WaitForChild("HumanoidRootPart", 5)
                        if newRoot then
                            newRoot.CFrame = CFrame.new(737, 39, -2118)
                        end
                    end
                    task.wait(2.1)
                end
            end)
        end
    end)

    -----
    -----
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local speedRunning = false
    local sliderValue = 1000
    local originalSpeed = nil
    local currentModel = nil
    
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
    
    local function applySpeed()
        local model = getMyModel()
        if not model then
            currentModel = nil
            return
        end
        if model ~= currentModel then
            currentModel = model
            originalSpeed = model:GetAttribute("MovementSpeed")
        end
        if speedRunning and originalSpeed ~= nil then
            pcall(function()
                model:SetAttribute("MovementSpeed", sliderValue)
            end)
        end
    end
    
    task.spawn(function()
        while true do
            if speedRunning then
                applySpeed()
            end
            task.wait(0.2)
        end
    end)
    
    local Toggle = Tabs.Stats:AddToggle("MovementToggle", {
        Title = "Enable Custom Lucky Block Speed",
        Default = false
    })
    Toggle:OnChanged(function()
        speedRunning = Options.MovementToggle.Value
        if not speedRunning then
            local model = getMyModel()
            if model and originalSpeed ~= nil then
                pcall(function()
                    model:SetAttribute("MovementSpeed", originalSpeed)
                end)
            end
            originalSpeed = nil
            currentModel = nil
        end
    end)
    
    local Slider = Tabs.Stats:AddSlider("MovementSlider", {
        Title = "Lucky Block Speed",
        Default = 1000,
        Min = 50,
        Max = 3000,
        Rounding = 0
    })
    Slider:OnChanged(function(Value)
        sliderValue = Value
    end)

    -- Add other features (Upgrades, Stats) here as needed
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
