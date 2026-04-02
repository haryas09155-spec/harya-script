--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// CONFIG
local CONFIG = {
    DELTA = 3,
    KEYS = {"W","A","S","D"},
}

--// STATE
local enabled = false
local activeThreads = {}

--// SAVE SYSTEM
local SAVE_KEY = "AntiAFK_State.txt"

local function saveState(state)
    pcall(function()
        if writefile then
            writefile(SAVE_KEY, tostring(state))
        end
    end)
end

local function loadState()
    local state = false
    pcall(function()
        if readfile and isfile and isfile(SAVE_KEY) then
            state = readfile(SAVE_KEY) == "true"
        end
    end)
    return state
end

--// UTILS
local function randomRange(min, max)
    return math.random() * (max - min) + min
end

local function randomKey()
    return CONFIG.KEYS[math.random(1, #CONFIG.KEYS)]
end

--// ANTI IDLE
local function antiIdle()
    if getconnections then
        for _, v in pairs(getconnections(player.Idled)) do
            if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end
        end
    else
        player.Idled:Connect(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
    end
end

--// ACTIONS
local function moveMouse()
    pcall(function()
        VirtualInputManager:SendMouseDelta(
            math.random(-CONFIG.DELTA, CONFIG.DELTA),
            math.random(-CONFIG.DELTA, CONFIG.DELTA)
        )
    end)
end

local function pressKey()
    local key = Enum.KeyCode[randomKey()]
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

local function moveCamera()
    if camera then
        camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(math.random(-2,2)), 0)
    end
end

local function simulateTouch()
    if UserInputService.TouchEnabled then
        pcall(function()
            local pos = Vector2.new(math.random(100,300), math.random(100,300))
            VirtualInputManager:SendTouchEvent(0, pos, true, game)
            task.wait(0.1)
            VirtualInputManager:SendTouchEvent(0, pos, false, game)
        end)
    end
end

--// SMART LOOP
local function smartAction()
    local actions = {moveMouse, pressKey, moveCamera, simulateTouch}
    for i = 1, math.random(1,2) do
        actions[math.random(1,#actions)]()
    end
end

local function stopLoops()
    enabled = false
    for _, t in ipairs(activeThreads) do
        task.cancel(t)
    end
    table.clear(activeThreads)
end

local function startLoops()
    stopLoops()
    enabled = true

    table.insert(activeThreads, task.spawn(function()
        while enabled do
            smartAction()
            task.wait(randomRange(10,30))
        end
    end))
end

local function setEnabled(state)
    if state then
        antiIdle()
        startLoops()
    else
        stopLoops()
    end
end

--// UI
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "AntiAFK_UI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,110)
frame.Position = UDim2.new(0,20,0,20)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-40,0,30)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Anti-AFK"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-35,0,0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimize)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,45)
btn.Position = UDim2.new(0,10,0,45)
btn.Text = "OFF"
btn.BackgroundColor3 = Color3.fromRGB(200,50,50)
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
Instance.new("UICorner", btn)

-- Animation
local function animate(state)
    TweenService:Create(btn, TweenInfo.new(0.25), {
        BackgroundColor3 = state and Color3.fromRGB(50,200,80) or Color3.fromRGB(200,50,50)
    }):Play()
    btn.Text = state and "ON" or "OFF"
end

local function toggle()
    local new = not enabled
    setEnabled(new)
    animate(new)
    saveState(new)
end

btn.MouseButton1Click:Connect(toggle)

-- Keybind (K)
UserInputService.InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode == Enum.KeyCode.K then
        toggle()
    end
end)

-- Minimize
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    btn.Visible = not minimized
    frame.Size = minimized and UDim2.new(0,200,0,35) or UDim2.new(0,200,0,110)
end)

-- Dragging
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function()
    dragging = false
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Auto-hide
local last = tick()

local function resetIdle()
    last = tick()
    frame.Visible = true
end

UserInputService.InputBegan:Connect(resetIdle)
UserInputService.InputChanged:Connect(resetIdle)

task.spawn(function()
    while true do
        if tick() - last > 10 then
            frame.Visible = false
        end
        task.wait(1)
    end
end)

-- Load state
local saved = loadState()
if saved then
    setEnabled(true)
end
animate(saved)
