-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Variables
local Player = Players.LocalPlayer
local StartTime = tick()

-- Create GUI
local AntiAFKGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local StatusDot = Instance.new("Frame")
local DotCorner = Instance.new("UICorner")
local CloseButton = Instance.new("TextButton")
local Divider1 = Instance.new("Frame")
local Divider2 = Instance.new("Frame")
local Footer = Instance.new("TextLabel")

-- Metrics Labels
local PingLabel = Instance.new("TextLabel")
local FPSLabel = Instance.new("TextLabel")
local TimeLabel = Instance.new("TextLabel")
local PingValue = Instance.new("TextLabel")
local FPSValue = Instance.new("TextLabel")
local TimeValue = Instance.new("TextLabel")

-- GUI Properties
AntiAFKGui.Name = "AntiAFK_UI"
AntiAFKGui.Parent = CoreGui
AntiAFKGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = AntiAFKGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(40, 40, 40)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

StatusDot.Name = "StatusDot"
StatusDot.Parent = MainFrame
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
StatusDot.Position = UDim2.new(0, 15, 0, 18)
StatusDot.Size = UDim2.new(0, 8, 0, 8)

DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 32, 0, 10)
Title.Size = UDim2.new(0, 200, 0, 25)
Title.Font = Enum.Font.SourceSans
Title.Text = "Anti-AFK · by hassanxzayn"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -30, 0, 10)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseButton.TextSize = 20

Divider1.Name = "Divider"
Divider1.Parent = MainFrame
Divider1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Divider1.BorderSizePixel = 0
Divider1.Position = UDim2.new(0, 15, 0, 45)
Divider1.Size = UDim2.new(1, -30, 0, 1)

-- Layout for Stats
local function CreateStat(name, pos, valueName)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.Parent = MainFrame
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, pos, 0, 60)
    lbl.Size = UDim2.new(0, 60, 0, 20)
    lbl.Font = Enum.Font.SourceSans
    lbl.Text = name:upper()
    lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    lbl.TextSize = 14
    
    local val = Instance.new("TextLabel")
    val.Name = valueName
    val.Parent = MainFrame
    val.BackgroundTransparency = 1
    val.Position = UDim2.new(0, pos, 0, 90)
    val.Size = UDim2.new(0, 60, 0, 30)
    val.Font = Enum.Font.SourceSansBold
    val.Text = "0"
    val.TextColor3 = Color3.fromRGB(255, 255, 255)
    val.TextSize = 22
    val.TextXAlignment = Enum.TextXAlignment.Left
    return val
end

PingValue = CreateStat("Ping", 20, "PingValue")
FPSValue = CreateStat("FPS", 145, "FPSValue")
TimeValue = CreateStat("Time", 255, "TimeValue")

Divider2.Name = "Divider"
Divider2.Parent = MainFrame
Divider2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Divider2.BorderSizePixel = 0
Divider2.Position = UDim2.new(0, 15, 0, 140)
Divider2.Size = UDim2.new(1, -30, 0, 1)

Footer.Name = "Footer"
Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 15, 0, 150)
Footer.Size = UDim2.new(0, 200, 0, 20)
Footer.Font = Enum.Font.SourceSans
Footer.Text = "Haryas script"
Footer.TextColor3 = Color3.fromRGB(180, 180, 180)
Footer.TextSize = 16
Footer.TextXAlignment = Enum.TextXAlignment.Left

-- Functionality
CloseButton.MouseButton1Click:Connect(function()
    AntiAFKGui:Destroy()
end)

-- Anti-AFK Logic
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Update Stats
local FrameCount = 0
local LastUpdate = tick()

RunService.RenderStepped:Connect(function()
    FrameCount = FrameCount + 1
    local now = tick()
    
    -- Update FPS every second
    if now - LastUpdate >= 1 then
        FPSValue.Text = tostring(FrameCount)
        FrameCount = 0
        LastUpdate = now
    end
    
    -- Update Ping
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    PingValue.Text = tostring(ping)
    
    -- Update Time
    local duration = math.floor(now - StartTime)
    local hours = math.floor(duration / 3600)
    local mins = math.floor((duration % 3600) / 60)
    local secs = duration % 60
    TimeValue.Text = string.format("%d:%d:%d", hours, mins, secs)
end)
