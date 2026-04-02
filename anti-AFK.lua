local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// Seed randomness
math.randomseed(os.time())

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
local connections = {}

--// UTILS
local function randomRange(min, max)
    return math.random() * (max - min) + min
end

local function randomKey()
    return CONFIG.KEYS[math.random(1, #CONFIG.KEYS)]
end

--// METHODS

-- 1. Idle bypass (MOST IMPORTANT)
local function antiIdle()
    for _,v in pairs(getconnections(player.Idled)) do
        v:Disable()
    end
end

-- 2. Mouse movement (PC)
local function moveMouse()
    local dx = math.random(-CONFIG.DELTA, CONFIG.DELTA)
    local dy = math.random(-CONFIG.DELTA, CONFIG.DELTA)
    pcall(function()
        VirtualInputManager:SendMouseDelta(dx, dy)
    end)
end

-- 3. Key press (PC)
local function pressKey()
    local key = Enum.KeyCode[randomKey()]
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

-- 4. Camera movement (works on ALL devices)
local function moveCamera()
    if camera then
        local current = camera.CFrame
        local offset = CFrame.Angles(
            math.rad(math.random(-2,2)),
            math.rad(math.random(-2,2)),
            0
        )
        camera.CFrame = current * offset
    end
end

-- 5. Touch simulation (Mobile)
local function simulateTouch()
    if UserInputService.TouchEnabled then
        pcall(function()
            VirtualInputManager:SendTouchEvent(
                0,
                Vector2.new(math.random(100,300), math.random(100,300)),
                true,
                game
            )
            task.wait(0.1)
            VirtualInputManager:SendTouchEvent(
                0,
                Vector2.new(math.random(100,300), math.random(100,300)),
                false,
                game
            )
        end)
    end
end

--// LOOP SYSTEM (modular timers)
local function startLoops()

    -- Mouse loop
    table.insert(connections, task.spawn(function()
        while enabled do
            moveMouse()
            task.wait(randomRange(CONFIG.MOUSE_INTERVAL[1], CONFIG.MOUSE_INTERVAL[2]))
        end
    end))

    -- Key loop
    table.insert(connections, task.spawn(function()
        while enabled do
            pressKey()
            task.wait(randomRange(CONFIG.KEY_INTERVAL[1], CONFIG.KEY_INTERVAL[2]))
        end
    end))

    -- Camera loop
    table.insert(connections, task.spawn(function()
        while enabled do
            moveCamera()
            task.wait(randomRange(CONFIG.CAMERA_INTERVAL[1], CONFIG.CAMERA_INTERVAL[2]))
        end
    end))

    -- Touch loop (mobile)
    table.insert(connections, task.spawn(function()
        while enabled do
            simulateTouch()
            task.wait(randomRange(CONFIG.TOUCH_INTERVAL[1], CONFIG.TOUCH_INTERVAL[2]))
        end
    end))

end

local function stopLoops()
    enabled = false
end

--// TOGGLE
local function setEnabled(state)
    enabled = state

    if state then
        antiIdle()
        startLoops()
        print("✅ Anti-AFK ENABLED (Advanced)")
    else
        stopLoops()
        print("❌ Anti-AFK DISABLED")
    end
end

--// SIMPLE UI (lightweight & mobile-friendly)
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 140, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 20)
btn.Text = "Anti-AFK: OFF"
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true

btn.MouseButton1Click:Connect(function()
    setEnabled(not enabled)

    if enabled then
        btn.Text = "Anti-AFK: ON"
        btn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
    else
        btn.Text = "Anti-AFK: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

print("🔥 Advanced Anti-AFK Loaded (PC + Mobile + Bypass)")
