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

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AntiAFK_GUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 180)
Frame.Position = UDim2.new(0.5, -200, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "● Anti-AFK"
Title.TextColor3 = Color3.fromRGB(200,200,200)
Title.Font = Enum.Font.Gotham
Title.TextSize = 18

-- Stats Labels
local PingLabel = Instance.new("TextLabel", Frame)
local FPSLabel = Instance.new("TextLabel", Frame)
local TimeLabel = Instance.new("TextLabel", Frame)

local labels = {PingLabel, FPSLabel, TimeLabel}
local names = {"PING", "FPS", "TIME"}

for i, lbl in ipairs(labels) do
    lbl.Size = UDim2.new(0.33, 0, 0, 80)
    lbl.Position = UDim2.new((i-1)*0.33, 0, 0.4, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
end

--// FPS Counter
local fps = 0
local last = tick()

RunService.RenderStepped:Connect(function()
    fps = math.floor(1 / (tick() - last))
    last = tick()
end)

--// Time Counter
local startTime = tick()

--// Update Loop
while true do
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

    PingLabel.Text = "PING\n"..ping
    FPSLabel.Text = "FPS\n"..fps
    TimeLabel.Text = "TIME\n"..math.floor(tick() - startTime)

    task.wait(1)
end
