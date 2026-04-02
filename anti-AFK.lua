--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// CONFIG
local CONFIG = {
    MOUSE_INTERVAL = {8, 15},
    KEY_INTERVAL = {20, 40},
    CAMERA_INTERVAL = {10, 25},
    TOUCH_INTERVAL = {15, 35},
    DELTA = 3,
    KEYS = {"W","A","S","D"},
}

--// STATE
local enabled = false
local activeThreads = {}

--// UTILS
local function randomRange(min, max)
    return math.random() * (max - min) + min
end

local function randomKey()
    return CONFIG.KEYS[math.random(1, #CONFIG.KEYS)]
end

--// METHODS

-- 1. Idle bypass (Bypasses the built-in 20-minute kick)
local function antiIdle()
    -- Standard Method: Disabling the Idled connection
    if getconnections then
        for _, v in pairs(getconnections(player.Idled)) do
            if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end
        end
    else
        -- Fallback: Overwrite the Idled signal logic if getconnections isn't available
        player.Idled:Connect(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
        end)
    end
end

-- 2. Mouse movement
local function moveMouse()
    local dx = math.random(-CONFIG.DELTA, CONFIG.DELTA)
    local dy = math.random(-CONFIG.DELTA, CONFIG.DELTA)
    pcall(function()
        VirtualInputManager:SendMouseDelta(dx, dy)
    end)
end

-- 3. Key press
local function pressKey()
    local key = Enum.KeyCode[randomKey()]
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

-- 4. Camera movement
local function moveCamera()
    if camera then
        local current = camera.CFrame
        local offset = CFrame.Angles(0, math.rad(math.random(-2,2)), 0)
        camera.CFrame = current * offset
    end
end

-- 5. Touch simulation
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

--// LOOP SYSTEM
local function stopLoops()
    enabled = false
    for _, thread in ipairs(activeThreads) do
        task.cancel(thread)
    end
    table.clear(activeThreads)
end

local function startLoops()
    stopLoops() -- Clear any existing loops first
    enabled = true

    local function runLoop(func, interval)
        table.insert(activeThreads, task.spawn(function()
            while enabled do
                func()
                task.wait(randomRange(interval[1], interval[2]))
            end
        end))
    end

    runLoop(moveMouse, CONFIG.MOUSE_INTERVAL)
    runLoop(pressKey, CONFIG.KEY_INTERVAL)
    runLoop(moveCamera, CONFIG.CAMERA_INTERVAL)
    runLoop(simulateTouch, CONFIG.TOUCH_INTERVAL)
end

--// TOGGLE
local function setEnabled(state)
    if state then
        antiIdle()
        startLoops()
        print("✅ Anti-AFK ENABLED")
    else
        stopLoops()
        print("❌ Anti-AFK DISABLED")
    end
end

--// UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AntiAFK_UI"
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 140, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 20)
btn.Text = "Anti-AFK: OFF"
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true

-- Rounded Corners
local corner = Instance.new("UICorner", btn)
corner.CornerRadius = ToolUnit.new(0, 8)

btn.MouseButton1Click:Connect(function()
    local newState = not enabled
    setEnabled(newState)
    
    btn.Text = newState and "Anti-AFK: ON" or "Anti-AFK: OFF"
    btn.BackgroundColor3 = newState and Color3.fromRGB(50, 200, 80) or Color3.fromRGB(200, 50, 50)
end)
