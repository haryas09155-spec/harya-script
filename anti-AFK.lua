--loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/anti-AFK.lua))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Configuration
local CONFIG = {
    MOUSE_MOVE_INTERVAL = 10,
    KEY_PRESS_INTERVAL = 30,
    MOUSE_DELTA = 2,
    KEYS_TO_PRESS = {"w", "a", "s", "d"}
}

-- State
local enabled = false
local lastMouseMove = 0
local lastKeyPress = 0
local connection
local dragging = false
local dragStart = nil
local startPos = nil

-- Anti-AFK Functions (same as before)
local function randomDelay(min, max)
    return math.random(min * 100, max * 100) / 100
end

local function subtleMouseMove()
    local deltaX = math.random(-CONFIG.MOUSE_DELTA, CONFIG.MOUSE_DELTA)
    local deltaY = math.random(-CONFIG.MOUSE_DELTA, CONFIG.MOUSE_DELTA)
    VirtualInputManager:SendMouseDelta(deltaX, deltaY, 0, "Default")
end

local function pressRandomKey()
    local key = CONFIG.KEYS_TO_PRESS[math.random(1, #CONFIG.KEYS_TO_PRESS)]
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key:upper()], false, game)
    wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key:upper()], false, game)
end

local function antiAFKLoop()
    if not enabled then return end
    local now = tick()
    
    if now - lastMouseMove >= CONFIG.MOUSE_MOVE_INTERVAL then
        subtleMouseMove()
        lastMouseMove = now
    end
    
    if now - lastKeyPress >= CONFIG.KEY_PRESS_INTERVAL then
        pressRandomKey()
        lastKeyPress = now
    end
end

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "AntiAFK_UI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.Size = UDim2.new(0, 220, 0, 80)
MainFrame.Active = true
MainFrame.Draggable = false

-- Corner rounding
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(65, 65, 75)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Title Bar
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Active = true

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(50, 50, 60)
TitleStroke.Thickness = 1
TitleStroke.Parent = TitleBar

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Anti-AFK"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle Button
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 15, 0, 45)
ToggleButton.Size = UDim2.new(0, 80, 0, 30)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(180, 40, 55)
ToggleStroke.Thickness = 1
ToggleStroke.Parent = ToggleButton

-- Status Label
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 105, 0, 45)
StatusLabel.Size = UDim2.new(1, -120, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Mouse: 10s | Keys: 30s"
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Dragging Logic
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Toggle Function
local function setEnabled(state)
    enabled = state
    if state then
        connection = RunService.Heartbeat:Connect(antiAFKLoop)
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
        ToggleStroke.Color = Color3.fromRGB(35, 140, 60)
        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
        ToggleStroke.Color = Color3.fromRGB(180, 40, 55)
        StatusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    setEnabled(not enabled)
end)

-- Hover Effects
ToggleButton.MouseEnter:Connect(function()
    if enabled then
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 84, 0, 32)}):Play()
    else
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 84, 0, 32)}):Play()
    end
end)

ToggleButton.MouseLeave:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 80, 0, 30)}):Play()
end)

-- Initialize OFF
setEnabled(false)

print("Anti-AFK UI loaded! Drag by title bar, click toggle button.")
