--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

--// Anti AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--// GUI (WORKS ON BOTH)
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 150)
frame.Position = UDim2.new(0.5, -160, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "● Anti-AFK"
title.TextColor3 = Color3.fromRGB(0,255,0)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 0)
close.Text = "X"
close.BackgroundTransparency = 1
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.TextScaled = true

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Create stat labels
local function createStat(x, name)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.33, 0, 0, 90)
    lbl.Position = UDim2.new(x, 0, 0.35, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
    lbl.Text = name.."\n0"
    return lbl
end

local pingLabel = createStat(0, "PING")
local fpsLabel = createStat(0.33, "FPS")
local timeLabel = createStat(0.66, "TIME")

-- FPS
local fps = 0
local last = tick()

RunService.RenderStepped:Connect(function()
    fps = math.floor(1 / (tick() - last))
    last = tick()
end)

-- Time
local startTime = tick()

-- Update loop
while task.wait(1) do
    local ping = 0

    -- Safe ping (works PC, may fail mobile)
    pcall(function()
        ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)

    pingLabel.Text = "PING\n"..ping
    fpsLabel.Text = "FPS\n"..fps
    timeLabel.Text = "TIME\n"..math.floor(tick() - startTime)
end
