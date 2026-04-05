-- Enhanced Multi-Executor Detection & Delta Support
-- Haryas Script Loader v2.0

local function checkExecutor()
    local execName = "unknown"
    
    -- Multiple executor detection methods
    if identifyexecutor then
        execName = tostring(identifyexecutor())
    elseif getexecutorname then
        execName = tostring(getexecutorname())
    elseif getexecutor then
        execName = tostring(getexecutor())
    elseif gethui then
        execName = "gethui_detected"
    end
    
    local lowerName = string.lower(execName or "")
    
    -- Comprehensive executor matching
    local patterns = {
        xeno = {"xeno", "xen"},
        delta = {"delta", "δ", "de"},
        solara = {"solara"},
        scriptware = {"script%-ware", "scriptware", "sw"},
        synapse = {"synapse", "syn"},
        krnl = {"krnl"},
        fluxus = {"fluxus"},
        oxygen = {"oxygen", "oxu"},
        electron = {"electron"}
    }
    
    for execType, matches in pairs(patterns) do
        for _, pattern in ipairs(matches) do
            if string.find(lowerName, pattern) then
                return execType
            end
        end
    end
    
    return nil
end

-- File & First-run system
local FIRST_RUN_PATH = "haryasscript_firstrun.json"
local CONFIG_PATH = "haryas_config.json"

local function fileExists(path)
    if not isfile then return false end
    return pcall(isfile, path) and isfile(path)
end

local function checkFirstRun()
    if fileExists(FIRST_RUN_PATH) then
        local ok, raw = pcall(readfile, FIRST_RUN_PATH)
        if ok and raw then
            local HttpService = game:GetService("HttpService")
            local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok2 and type(data) == "table" and data.__LuarmorDone == true then
                return true
            end
        end
    end
    return false
end

local function markFirstRunDone()
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local json = HttpService:JSONEncode({ __LuarmorDone = true })
        writefile(FIRST_RUN_PATH, json)
    end)
end

-- Initialize first-run protection
local needFirstRun = not checkFirstRun()
if needFirstRun then
    markFirstRunDone()
end

-- Luarmor URLs
local LUARMOR_MAIN = "https://api.luarmor.net/files/v4/loaders/66e067f17cbfa177b7bed91c1bdcb466.lua"
local LUARMOR_FIRST = "https://api.luarmor.net/files/v4/loaders/4361856ec1a1756e11427e07dd6ec7bb.lua"
local REMOTE_URL = "https://raw.githubusercontent.com/haryas09155-spec/harya-script/refs/heads/main/sab.lua"

-- Detect executor
local executorType = checkExecutor()
local isSpecialExecutor = executorType ~= nil

print("=== Haryas Script Loader ===")
print("Executor:", executorType or "standard")
print("First-run needed:", needFirstRun)

-- SPECIAL EXECUTOR HANDLING (Xeno, Delta, Solara, etc.)
if isSpecialExecutor then
    print("Loading Luarmor for " .. executorType .. "...")
    
    -- Load main Luarmor script
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet(LUARMOR_MAIN, true))()
        end)
    end)
    
    -- First-run protection
    if needFirstRun then
        task.wait(1)
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(LUARMOR_FIRST, true))()
            end)
        end)
    end
    
    return
end

-- STANDARD EXECUTOR FLOW
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Config system
config = config or {}
local firstShownFlag = config.__HaryasscriptDiscordShown == true

local function loadConfig()
    if fileExists(CONFIG_PATH) then
        local ok, raw = pcall(readfile, CONFIG_PATH)
        if ok and raw then
            local ok2, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok2 and type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    config[k] = v
                end
            end
        end
    end
end

local function saveConfig()
    local ok, json = pcall(HttpService.JSONEncode, HttpService, config)
    if ok then
        pcall(writefile, CONFIG_PATH, json)
    end
end

loadConfig()

-- Remote script loader
local function runRemote()
    task.spawn(function()
        pcall(function()
            local src = game:HttpGet(REMOTE_URL, true)
            local f = loadstring(src)
            if type(f) == "function" then 
                f() 
            end
        end)
    end)
end

-- Skip Discord GUI if already shown
if firstShownFlag then
    print("Config flag found, running remote...")
    runRemote()
    
    if needFirstRun then
        task.wait(1)
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(LUARMOR_FIRST, true))()
            end)
        end)
    end
    return
end

-- Load remote immediately
runRemote()

-- First-run protection
if needFirstRun then
    task.wait(1)
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet(LUARMOR_FIRST, true))()
        end)
    end)
end

-- Modern Discord Invite GUI
local function getGuiParent()
    if gethui then return gethui() end
    if CoreGui:FindFirstChild("RobloxGui") then return CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local DISCORD_LINK = "https://discord.gg/7jrstE4zjn"

-- Colors
local COLORS = {
    BASE_BG = Color3.fromRGB(16, 24, 39),
    CARD_GRAD_1 = Color3.fromRGB(12, 18, 32),
    CARD_GRAD_2 = Color3.fromRGB(21, 30, 47),
    CARD_GRAD_3 = Color3.fromRGB(10, 82, 120),
    STROKE_GLOW = Color3.fromRGB(56, 189, 248),
    STROKE_MAIN = Color3.fromRGB(56, 189, 248),
    SURFACE = Color3.fromRGB(30, 41, 59),
    SURFACE_DARK = Color3.fromRGB(25, 32, 48),
    TEAL_ON = Color3.fromRGB(52, 180, 230),
    TEXT = Color3.fromRGB(241, 245, 249),
    TEXT_MUTED = Color3.fromRGB(148, 163, 184)
}

local function createCard(parent, size)
    local frame = Instance.new("Frame")
    frame.Name = "DiscordCard"
    frame.Parent = parent
    frame.BackgroundColor3 = COLORS.BASE_BG
    frame.BorderSizePixel = 0
    frame.Size = size
    frame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame
    
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 35
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.CARD_GRAD_1),
        ColorSequenceKeypoint.new(0.55, COLORS.CARD_GRAD_2),
        ColorSequenceKeypoint.new(1, COLORS.CARD_GRAD_3)
    })
    gradient.Parent = frame
    
    local glowStroke = Instance.new("UIStroke")
    glowStroke.Thickness = 8
    glowStroke.Transparency = 0.9
    glowStroke.Color = COLORS.STROKE_GLOW
    glowStroke.LineJoinMode = Enum.LineJoinMode.Round
    glowStroke.Parent = frame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.15
    mainStroke.Color = COLORS.STROKE_MAIN
    mainStroke.LineJoinMode = Enum.LineJoinMode.Round
    mainStroke.Parent = frame
    
    return frame
end

local function createTopBar(parent, title)
    local bar = Instance.new("Frame")
    bar.Name = "TopBar"
    bar.Parent = parent
    bar.BackgroundColor3 = COLORS.SURFACE_DARK
    bar.BackgroundTransparency = 0.15
    bar.BorderSizePixel = 0
    bar.Size = UDim2.new(1, -16, 0, 42)
    bar.Position = UDim2.new(0, 8, 0, 8)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = bar
    
    local label = Instance.new("TextLabel")
    label.Parent = bar
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -28, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = title
    label.TextColor3 = COLORS.TEXT
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Center
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 211, 238)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(99, 102, 241))
    })
    grad.Parent = label
    
    return bar
end

-- Create GUI
local playerGui = getGuiParent()
local hubGui = Instance.new("ScreenGui")
hubGui.Name = "HaryasScriptDiscord"
hubGui.IgnoreGuiInset = true
hubGui.ResetOnSpawn = false
hubGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
hubGui.Parent = playerGui

local card = createCard(hubGui, UDim2.fromOffset(380, 228))
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.new(0.5, 0, 0.34, 0)

local topBar = createTopBar(card, "Haryas Script Discord")

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Parent = topBar
closeBtn.BackgroundColor3 = COLORS.SURFACE
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -34, 0.5, -14)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = COLORS.TEXT
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local closeStroke = Instance.new("UIStroke")
closeStroke.Thickness = 1.5
closeStroke.Color = COLORS.STROKE_MAIN
closeStroke.Transparency = 0.25
closeStroke.Parent = closeBtn

-- Body text
local body = Instance.new("TextLabel")
body.Name = "BodyText"
body.Parent = card
body.BackgroundTransparency = 1
body.Position = UDim2.new(0, 18, 0, 60)
body.Size = UDim2.new(1, -36, 0, 76)
body.Font = Enum.Font.Gotham
body.TextSize = 16
body.TextColor3 = COLORS.TEXT
body.TextXAlignment = Enum.TextXAlignment.Center
body.TextYAlignment = Enum.TextYAlignment.Center
body.TextWrapped = true
body.Text = "⭐ Join Discord for:\n• Secret game servers\n• Update announcements\n• Exclusive giveaways\n• Script support"

-- Copy button
local copyBtn = Instance.new("TextButton")
copyBtn.Name = "CopyBtn"
copyBtn.Parent = card
copyBtn.Size = UDim2.new(1, -24, 0, 38)
copyBtn.Position = UDim2.new(0, 12, 1, -70)
copyBtn.BackgroundColor3 = COLORS.TEAL_ON
copyBtn.BorderSizePixel = 0
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 16
copyBtn.TextColor3 = Color3.fromRGB(14, 25, 38)
copyBtn.Text = "📋 Copy Discord Invite"
copyBtn.AutoButtonColor = false

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 12)
copyCorner.Parent = copyBtn

local copyStroke = Instance.new("UIStroke")
copyStroke.Thickness = 1.5
copyStroke.Color = COLORS.STROKE_MAIN
copyStroke.Transparency = 0.15
copyStroke.Parent = copyBtn

-- Link display
local linkBtn = Instance.new("TextButton")
linkBtn.Name = "LinkBtn"
linkBtn.Parent = card
linkBtn.BackgroundTransparency = 1
linkBtn.BorderSizePixel = 0
linkBtn.Position = UDim2.new(0, 12, 1, -28)
linkBtn.Size = UDim2.new(1, -24, 0, 18)
linkBtn.Font = Enum.Font.GothamBold
linkBtn.TextSize = 13
linkBtn.TextColor3 = COLORS.TEXT
linkBtn.Text = DISCORD_LINK
linkBtn.AutoButtonColor = false
linkBtn.TextXAlignment = Enum.TextXAlignment.Center

-- Toast notification
local toast = Instance.new("TextLabel")
toast.Name = "Toast"
toast.Parent = card
toast.BackgroundTransparency = 1
toast.Position = UDim2.new(0, 12, 1, -48)
toast.Size = UDim2.new(1, -24, 0, 16)
toast.Font = Enum.Font.Gotham
toast.TextSize = 12
toast.TextColor3 = COLORS.TEXT_MUTED
toast.TextXAlignment = Enum.TextXAlignment.Center
toast.Text = ""

-- Enhanced clipboard support
local function copyToClipboard(text)
    if type(text) ~= "string" then return false end
    
    -- Delta specific
    if delta and delta.clipboard_set then
        pcall(delta.clipboard_set, text)
        return true
    end
    
    -- Universal clipboard APIs
    local apis = {
        setclipboard, toclipboard,
        function() if syn and syn.write_clipboard then syn.write_clipboard(text) end end,
        function() if pastebin and pastebin.setcb then pastebin.setcb(text) end end
    }
    
    for _, api in ipairs(apis) do
        if type(api) == "function" then
            local success = pcall(api, text)
            if success then return true end
        end
    end
    
    return false
end

-- Button connections
local function showToast(message, color)
    toast.Text = message
    toast.TextColor3 = color or COLORS.TEXT_MUTED
    task.wait(2)
    toast.Text = ""
end

copyBtn.MouseButton1Click:Connect(function()
    if copyToClipboard(DISCORD_LINK) then
        showToast("✅ Invite copied to clipboard!", Color3.fromRGB(34, 197, 94))
    else
        showToast("❌ Copy failed. Manual link:", COLORS.TEXT_MUTED)
    end
end)

linkBtn.MouseButton1Click:Connect(function()
    if copyToClipboard(DISCORD_LINK) then
        showToast("✅ Discord link copied!", Color3.fromRGB(34, 197, 94))
    else
        showToast("❌ Copy failed. Link: discord.gg/7jrstE4zjn", COLORS.TEXT_MUTED)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    config.__HaryasscriptDiscordShown = true
    saveConfig()
    hubGui:Destroy()
end)

-- Entrance animation
card.Position = UDim2.new(0.5, 0, 0.31, 0)
local tween = TweenService:Create(
    card,
    TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    { Position = UDim2.new(0.5, 0, 0.34, 0) }
)
tween:Play()

print("=== Discord GUI loaded successfully ===")
print("Executor:", executorType or "standard")
