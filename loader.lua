repeat wait() until game:IsLoaded()

local cloneref = cloneref or function(o) return o end
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local Lighting = cloneref(game:GetService("Lighting"))

local LocalPlayer = cloneref(Players.LocalPlayer)

-- ==========================================
-- CONFIGURATION
-- ==========================================
local RepoURL = "https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/"

local GameList = {
    ["18668065416"]  = "Blue-Lock.lua", 
    ["11708967881"]  = "YeetAFriend.lua",
    ["124473577469410"] = "bealuckyblock.lua",
    ["8908228901"] = "sharkbite2.lua",
    ["97598239454123"] = "gag2.lua",
    ["82524183928567"] = "buildasoccersquad.lua",
}

local Config = {
    Title = "Harya Script",
    Description = "Loading script securely...",
}

-- ==========================================
-- UI CREATION
-- ==========================================
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = HttpService:GenerateGUID(false)
    ScreenGui.Parent = gethui and gethui() or CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.ResetOnSpawn = false

    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 0
    BlurEffect.Parent = Lighting

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 16)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(41, 37, 45)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 1
    UIStroke.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.Position = UDim2.new(0, 0, 0, 20)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title
    TitleLabel.TextColor3 = Color3.fromRGB(232, 186, 248)
    TitleLabel.TextSize = 24
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextTransparency = 1
    TitleLabel.Parent = MainFrame

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(1, 0, 0, 20)
    SubtitleLabel.Position = UDim2.new(0, 0, 0, 65)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = Config.Description
    SubtitleLabel.TextColor3 = Color3.fromRGB(185, 185, 185)
    SubtitleLabel.TextSize = 13
    SubtitleLabel.Font = Enum.Font.GothamBold
    SubtitleLabel.TextTransparency = 1
    SubtitleLabel.Parent = MainFrame

    local BarBackground = Instance.new("Frame")
    BarBackground.Size = UDim2.new(0.8, 0, 0, 4)
    BarBackground.Position = UDim2.new(0.1, 0, 0, 100)
    BarBackground.BackgroundColor3 = Color3.fromRGB(36, 32, 39)
    BarBackground.BorderSizePixel = 0
    BarBackground.Parent = MainFrame

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(232, 186, 248)
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBackground

    local TweenInfo1 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local TweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(BlurEffect, TweenInfo.new(0.5), {Size = 24}):Play()
    TweenService:Create(MainFrame, TweenInfo1, {Size = UDim2.new(0, 400, 0, 140)}):Play()
    task.wait(0.3)
    TweenService:Create(UIStroke, TweenInfo2, {Transparency = 0}):Play()
    TweenService:Create(TitleLabel, TweenInfo2, {TextTransparency = 0}):Play()
    TweenService:Create(SubtitleLabel, TweenInfo2, {TextTransparency = 0}):Play()
    TweenService:Create(BarFill, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

    return ScreenGui, BlurEffect, MainFrame, SubtitleLabel
end

-- ==========================================
-- EXECUTION LOGIC
-- ==========================================
-- Universal HTTP Request function
local function FetchScript(url)
    local response = nil
    local success, err = pcall(function()
        if request then
            response = request({Url = url, Method = "GET"}).Body
        elseif http_request then
            response = http_request({Url = url, Method = "GET"}).Body
        elseif http_get then
            response = http_get(url)
        else
            response = game:HttpGet(url)
        end
    end)
    return success, response, err
end

-- Check PlaceId first, then fallback to GameId
local GameId = tostring(game.PlaceId)
local ScriptName = GameList[GameId]

if not ScriptName then
    GameId = tostring(game.GameId)
    ScriptName = GameList[GameId]
end

if not ScriptName then
    StarterGui:SetCore("SendNotification", {
        Title = "Harya Script",
        Text = "Game not supported! PlaceId: " .. tostring(game.PlaceId) .. " | GameId: " .. tostring(game.GameId),
        Duration = 10
    })
    return
end

local UI, Blur, Frame, StatusText = CreateUI()

-- Update status and fetch script
StatusText.Text = "Connecting to repository..."
local targetUrl = RepoURL .. ScriptName
local success, response, err = FetchScript(targetUrl)

if not success or not response or #response < 10 then
    StatusText.Text = "Failed to load script!"
    StarterGui:SetCore("SendNotification", {
        Title = "Harya Script",
        Text = "HTTP Request failed. Error: " .. tostring(err or "Empty response"),
        Duration = 7
    })
    task.wait(3)
    -- Close UI
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.4)
    UI:Destroy()
    return
end

-- Execute the loaded script
StatusText.Text = "Executing script..."
task.wait(0.5)

local func, syntaxErr = loadstring(response)
if not func then
    StarterGui:SetCore("SendNotification", {
        Title = "Harya Script",
        Text = "Script syntax error: " .. tostring(syntaxErr),
        Duration = 7
    })
else
    local execSuccess, execError = pcall(func)
    if not execSuccess then
        StarterGui:SetCore("SendNotification", {
            Title = "Harya Script",
            Text = "Execution error: " .. tostring(execError),
            Duration = 7
        })
    end
end

-- Close UI smoothly after execution
task.wait(0.5)
TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
task.wait(0.4)
UI:Destroy()
