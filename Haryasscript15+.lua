---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/Haryasscript15+.lua"))()
repeat wait() until game:IsLoaded()

getgenv().lilix = getgenv().lilix or nil
getgenv().relix = getgenv().relix or nil

getgenv().key = getgenv().key or nil
getgenv().luarmor_api = getgenv().luarmor_api or nil
getgenv().key_expire = getgenv().key_expire or nil
getgenv().key_note = getgenv().key_note or nil
getgenv().key_executions = getgenv().key_executions or nil

local wait = task.wait
local spawn = task.spawn
local delay = task.delay

local CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService = cloneref(game:GetService("HttpService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Workspace = cloneref(game:GetService("Workspace"))

local plr = Players.LocalPlayer

local list = {
	["3808223175"] = { id = "4fe2dfc202115670b1813277df916ab2", keyless = false }, -- Jujutsu Infinite
	["994732206"]  = { id = "e2718ddebf562c5c4080dfce26b09398", keyless = false }, -- Blox Fruits
	["1511883870"] = { id = "fefdf5088c44beb34ef52ed6b520507c", keyless = false }, -- Shindo Life
	["6035872082"] = { id = "3bb7969a9ecb9e317b0a24681327c2e2", keyless = true }, -- Rivals
	["245662005"]  = { id = "21ad7f491e4658e9dc9529a60c887c6e", keyless = true },  -- Jailbreak
	["7018190066"] = { id = "98f5c64a0a9ecca29517078597bbcbdb", keyless = true },  -- Dead Rails
	["7326934954"] = { id = "00e140acb477c5ecde501c1d448df6f9", keyless = true },  -- 99 Nights in the Forest
	["7671049560"] = { id = "c0b41e859f576fb70183206224d4a75f", keyless = false }, -- The Forge
	["9363735110"] = {id = "4948419832e0bd4aa588e628c45b6f8d", keyless = false }, -- Escape Tsunami For Brainrots!
	["9509842868"] = {id = "ad4ccd094f8b6f972bff36de80475abe", keyless = true }, -- Garden Horizons
	["5130394318"] = {id = "3e7a75a970118d0f0cf629369524dc7d", keyless = false }, -- Bizarre Lineage
	["9186719164"] = {id = "892ccfefdc8834199a2a6e5856a8da67", keyless = true }, -- Sailor Piece

}

local is_mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local game_id = tostring(game.GameId)
local game_config = list[game_id]

if not game_config then
	plr:Kick("This game is not supported.")
	return
end

local script_id = game_config.id
local is_key_less = game_config.keyless

if hookfunction and hookmetamethod then
	getgenv().lilix = true
else
	getgenv().lilix = false
end

if is_mobile then
	getgenv().relix = true
else
	getgenv().relix = false
end

local Buttons = {}

if CoreGui:FindFirstChild("Haryas script ScreenGui") then
	CoreGui["Solix ScreenGui"]:Destroy()
end

if CoreGui:FindFirstChild("Solix Notification") then
	CoreGui["Solix Notification"]:Destroy()
end

local config = {
	File = "Haryas script/savedkey.txt",
	Title = "Haryas script Free 15+ Games",
	Description = "Lifetime key access is available for a one time payment of $15 via solixhub.com",
	Linkvertise = "https://ads.luarmor.net/get_key?for=Solixhub_Free_KeySystem-OWlLHDMCHADk",
	Rinku = "https://ads.luarmor.net/get_key?for=Solix_Free_Keysystems-pqJCGTqnTsng",
	Discord = "https://discord.gg/solixhub",
	Shop = "https://solixhub.com/",
}

local theme = {
	Background = Color3.fromRGB(15, 12, 16),
	Inline = Color3.fromRGB(22, 20, 24),
	Border = Color3.fromRGB(41, 37, 45),
	Shadow = Color3.fromRGB(0, 0, 0),
	Text = Color3.fromRGB(255, 255, 255),
	InactiveText = Color3.fromRGB(185, 185, 185),
	Accent = Color3.fromRGB(232, 186, 248),
	Element = Color3.fromRGB(36, 32, 39),
	Success = Color3.fromRGB(60, 255, 60),
	Error = Color3.fromRGB(255, 60, 60)
}

local error_messages = {
	KEY_EXPIRED = "Your key has expired. Please renew it to continue.",
	KEY_BANNED = "This key has been blacklisted. Contact support for assistance.",
	KEY_INCORRECT = "The provided key is incorrect or no longer valid.",
	KEY_INVALID = "Invalid key format. Please check your key and try again.",
	SCRIPT_ID_INCORRECT = "The provided script ID does not exist or has been removed.",
	SCRIPT_ID_INVALID = "This script has been deleted by its owner.",
	SECURITY_ERROR = "Security validation failed (Cloudflare check). Please retry.",
	TIME_ERROR = "Invalid client time detected. Please sync your system clock.",
	UNKNOWN_ERROR = "An unknown error occurred. Please contact support."
}

local function DeleteFile(v)
	if isfile(v) then
		delfile(v)
	end
end

local function ToTime(v)
	if v <= 0 or not v then
		return "Lifetime"
	end

	local days = math.floor(v / 86400)
	local hours = math.floor((v % 86400) / 3600)
	local minutes = math.floor((v % 3600) / 60)
	local seconds = v % 60

	if days > 0 then
		return string.format("%dd %dh %dm %ds", days, hours, minutes, seconds)
	elseif hours > 0 then
		return string.format("%dh %dm %ds", hours, minutes, seconds)
	elseif minutes > 0 then
		return string.format("%dm %ds", minutes, seconds)
	else
		return string.format("%ds", seconds)
	end
end

local DefaultFont = Enum.Font.GothamBold

local function CustomFont()
	local font_path = "solixhub/Assets/InterSemiBold.ttf"

	if not isfolder("solixhub") then
		makefolder("solixhub")
	end
	if not isfolder("solixhub/Assets") then
		makefolder("solixhub/Assets")
	end

	if not isfile(font_path) then
		writefile(font_path, game:HttpGet("https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf"))
	end

	local font_data = {
		name = "InterSemiBold",
		faces = {
			{
				name = "InterSemiBold",
				weight = 400,
				style = "Regular",
				assetId = getcustomasset(font_path)
			}
		}
	}

	writefile("Haryas script/Assets/InterSemiBold.Font", HttpService:JSONEncode(font_data))
	return Font.new(getcustomasset("solixhub/Assets/InterSemiBold.Font"))
end

local FontSuccess, LoadedFont = pcall(CustomFont)
local LibraryFont = (FontSuccess and LoadedFont) and LoadedFont or DefaultFont

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "Haryas script Blur"
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

local NotificationHolder = Instance.new("ScreenGui")
NotificationHolder.Name = "Haryas script Notification"
NotificationHolder.DisplayOrder = 1002
NotificationHolder.Parent = CoreGui

local NotificationContainer = Instance.new("Frame", NotificationHolder)
NotificationContainer.Position = UDim2.new(1, -20, 0, 20)
NotificationContainer.Size = UDim2.new(0, 0, 1, -40)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.AnchorPoint = Vector2.new(1, 0)

local NotificationLayout = Instance.new("UIListLayout", NotificationContainer)
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Padding = UDim.new(0, 10)
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function Notification(title, desc, duration, color)
	local NotificationFrame = Instance.new("Frame", NotificationContainer)
	NotificationFrame.BackgroundColor3 = theme.Background
	NotificationFrame.BackgroundTransparency = 0.3
	NotificationFrame.BorderSizePixel = 0
	NotificationFrame.Size = UDim2.new(0, 0, 0, 0)
	NotificationFrame.ClipsDescendants = true
	Instance.new("UICorner", NotificationFrame).CornerRadius = UDim.new(0, 5)

	local NotificationPadding = Instance.new("UIPadding", NotificationFrame)
	NotificationPadding.PaddingTop = UDim.new(0, 8)
	NotificationPadding.PaddingBottom = UDim.new(0, 8)
	NotificationPadding.PaddingLeft = UDim.new(0, 8)
	NotificationPadding.PaddingRight = UDim.new(0, 8)

	local TitleLabel = Instance.new("TextLabel", NotificationFrame)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.FontFace = LibraryFont
	TitleLabel.Text = title
	TitleLabel.TextColor3 = theme.Text
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Size = UDim2.new(0, 0, 0, 15)
	TitleLabel.AutomaticSize = Enum.AutomaticSize.XY
	TitleLabel.TextTransparency = 1

	local DescLabel = Instance.new("TextLabel", NotificationFrame)
	DescLabel.BackgroundTransparency = 1
	DescLabel.FontFace = LibraryFont
	DescLabel.Text = desc
	DescLabel.TextColor3 = theme.Text
	DescLabel.TextTransparency = 0.4
	DescLabel.TextSize = 14
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.Size = UDim2.new(0, 115, 0, 15)
	DescLabel.Position = UDim2.new(0, 0, 0, 20)
	DescLabel.AutomaticSize = Enum.AutomaticSize.Y
	DescLabel.TextWrapped = false

	wait()

	local SizeX = math.max(TitleLabel.TextBounds.X, DescLabel.TextBounds.X) + 18
	local SizeY = TitleLabel.TextBounds.Y + DescLabel.TextBounds.Y + 40

	local DurationBar = Instance.new("Frame", NotificationFrame)
	DurationBar.Position = UDim2.new(0, 0, 0, SizeY - 25)
	DurationBar.Size = UDim2.new(1, 0, 0, 5)
	DurationBar.BackgroundColor3 = theme.Inline
	DurationBar.BorderSizePixel = 0
	DurationBar.BackgroundTransparency = 1
	Instance.new("UICorner", DurationBar).CornerRadius = UDim.new(0, 5)

	local AccentBar = Instance.new("Frame", DurationBar)
	AccentBar.Size = UDim2.new(1, 0, 1, 0)
	AccentBar.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
	AccentBar.BorderSizePixel = 0
	AccentBar.BackgroundTransparency = 1
	Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0, 5)

	local Tween_Info = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
	TweenService:Create(NotificationFrame, Tween_Info, {BackgroundTransparency = 0}):Play()
	TweenService:Create(TitleLabel, Tween_Info, {TextTransparency = 0}):Play()
	TweenService:Create(DescLabel, Tween_Info, {TextTransparency = 0.4}):Play()
	TweenService:Create(DurationBar, Tween_Info, {BackgroundTransparency = 0}):Play()
	TweenService:Create(AccentBar, Tween_Info, {BackgroundTransparency = 0}):Play()
	TweenService:Create(NotificationFrame, Tween_Info, {Size = UDim2.new(0, SizeX, 0, SizeY)}):Play()
	TweenService:Create(AccentBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

	delay(duration + 0.1, function()
		TweenService:Create(NotificationFrame, Tween_Info, {BackgroundTransparency = 1}):Play()
		TweenService:Create(TitleLabel, Tween_Info, {TextTransparency = 1}):Play()
		TweenService:Create(DescLabel, Tween_Info, {TextTransparency = 1}):Play()
		TweenService:Create(DurationBar, Tween_Info, {BackgroundTransparency = 1}):Play()
		TweenService:Create(AccentBar, Tween_Info, {BackgroundTransparency = 1}):Play()
		TweenService:Create(NotificationFrame, Tween_Info, {Size = UDim2.new(0, 0, 0, SizeY)}):Play()
		wait(0.5)
		NotificationFrame:Destroy()
	end)
end

local luarmor_api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()

luarmor_api.script_id = script_id

if is_key_less then
	pcall(function()
		luarmor_api.load_script()
	end)
	return
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Haryas script ScreenGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = CoreGui

local UIScale = Instance.new("UIScale")
UIScale.Name = "UIScale"
UIScale.Scale = 1
UIScale.Parent = ScreenGui

local function GetViewportSize()
	local Camera = Workspace.CurrentCamera

	return (Camera and Camera.ViewportSize) or Vector2.new(1920, 1080)
end

local function SetMobileScale()
	local Viewport = GetViewportSize()

	if is_mobile then
		local Scale = math.clamp(Viewport.Y / 500, 0.5, 1.5)

		UIScale.Scale = Scale
	else
		UIScale.Scale = 1
	end
end

local Overlay = Instance.new("Frame", ScreenGui)
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "Main"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundColor3 = theme.Background
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = theme.Border
MainStroke.Thickness = 1
MainStroke.Transparency = 1
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Position = UDim2.new(0, 0, 0, 20)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.FontFace = LibraryFont
TitleLabel.Text = config.Title
TitleLabel.TextColor3 = theme.Accent
TitleLabel.TextSize = 28
TitleLabel.TextTransparency = 1

local SubtitleLabel = Instance.new("TextLabel", MainFrame)
SubtitleLabel.Position = UDim2.new(0, 0, 0, 65)
SubtitleLabel.Size = UDim2.new(1, 0, 0, 20)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.FontFace = LibraryFont
SubtitleLabel.Text = config.Description
SubtitleLabel.TextColor3 = theme.InactiveText
SubtitleLabel.TextSize = 13
SubtitleLabel.TextTransparency = 1

local Line = Instance.new("Frame", MainFrame)
Line.Position = UDim2.new(0.08, 0, 0, 95)
Line.Size = UDim2.new(0.84, 0, 0, 1)
Line.BackgroundColor3 = theme.Border
Line.BorderSizePixel = 0
Line.BackgroundTransparency = 1

local TextBoxContainer = Instance.new("Frame", MainFrame)
TextBoxContainer.Position = UDim2.new(0.5, 0, 0, 115)
TextBoxContainer.AnchorPoint = Vector2.new(0.5, 0)
TextBoxContainer.Size = UDim2.new(0, 480, 0, 50)
TextBoxContainer.BackgroundColor3 = theme.Element
TextBoxContainer.BorderSizePixel = 0
TextBoxContainer.BackgroundTransparency = 1
Instance.new("UICorner", TextBoxContainer).CornerRadius = UDim.new(0, 5)

local TextBoxGradient = Instance.new("UIGradient", TextBoxContainer)
TextBoxGradient.Rotation = 90
TextBoxGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(216, 216, 216))
})

local TextBoxStroke = Instance.new("UIStroke", TextBoxContainer)
TextBoxStroke.Color = theme.Border
TextBoxStroke.Thickness = 1
TextBoxStroke.Transparency = 1
TextBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local KeyTextBox = Instance.new("TextBox", TextBoxContainer)
KeyTextBox.Size = UDim2.new(1, -24, 1, 0)
KeyTextBox.Position = UDim2.new(0, 12, 0, 0)
KeyTextBox.BackgroundTransparency = 1
KeyTextBox.FontFace = LibraryFont
KeyTextBox.PlaceholderText = "Paste your key here..."
KeyTextBox.PlaceholderColor3 = theme.InactiveText
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = theme.Text
KeyTextBox.TextSize = 15
KeyTextBox.ClearTextOnFocus = false
KeyTextBox.TextTransparency = 1

local function AddGradient(v)
	local Gradient = Instance.new("UIGradient", v)

	Gradient.Rotation = 90
	Gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(216, 216, 216))
	})
	return Gradient
end

local function CreateButton(text, position, color)
	local Button = Instance.new("TextButton", MainFrame)

	Button.Position = position
	Button.AnchorPoint = Vector2.new(0.5, 0)
	Button.Size = UDim2.new(0, 220, 0, 45)
	Button.BackgroundColor3 = color
	Button.FontFace = LibraryFont
	Button.Text = text
	Button.TextColor3 = theme.Text
	Button.TextSize = is_mobile and 13 or 15
	Button.BorderSizePixel = 0
	Button.AutoButtonColor = false
	Button.BackgroundTransparency = 1
	Button.TextTransparency = 1

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)

	AddGradient(Button)

	local ButtonStroke = Instance.new("UIStroke", Button)

	ButtonStroke.Color = theme.Border
	ButtonStroke.Thickness = 1
	ButtonStroke.Transparency = 1
	ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	table.insert(Buttons, {button = Button, stroke = ButtonStroke})
	return Button
end

local Button1, Button2, Button3, Button4

if is_mobile then
	Button1 = CreateButton("Get Key (Linkvertise)", UDim2.new(0.5, 0, 0, 185), theme.Element)
	Button2 = CreateButton("Get Key (Rinku)", UDim2.new(0.5, 0, 0, 240), theme.Element)
	Button3 = CreateButton("Join Discord", UDim2.new(0.5, 0, 0, 295), theme.Element)
	Button4 = CreateButton("Buy Standard Key", UDim2.new(0.5, 0, 0, 350), theme.Element)

	for _, Button in ipairs(Buttons) do
		Button.button.Size = UDim2.new(0, 320, 0, 42)
	end
else
	Button1 = CreateButton("Get Key (Linkvertise)", UDim2.new(0.25, 0, 0, 190), theme.Element)
	Button2 = CreateButton("Get Key (Rinku)", UDim2.new(0.75, 0, 0, 190), theme.Element)
	Button3 = CreateButton("Join Discord", UDim2.new(0.25, 0, 0, 255), theme.Element)
	Button4 = CreateButton("Buy Standard Key", UDim2.new(0.75, 0, 0, 255), theme.Element)
end

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.BackgroundColor3 = theme.Element
CloseButton.FontFace = LibraryFont
CloseButton.Text = "X"
CloseButton.TextColor3 = theme.Text
CloseButton.TextSize = 18
CloseButton.BorderSizePixel = 0
CloseButton.AutoButtonColor = false
CloseButton.BackgroundTransparency = 1
CloseButton.TextTransparency = 1
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 5)

local CloseStroke = Instance.new("UIStroke", CloseButton)
CloseStroke.Color = theme.Border
CloseStroke.Thickness = 1
CloseStroke.Transparency = 1
CloseStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local function MakeDraggable(frame)
	local dragging = false
	local start = nil
	local postion = nil

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			start = input.Position
			postion = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				local Scale = UIScale.Scale
				local delta = (input.Position - start) / Scale

				TweenService:Create(frame, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = UDim2.new(postion.X.Scale, postion.X.Offset + delta.X, postion.Y.Scale, postion.Y.Offset + delta.Y)
				}):Play()
			end
		end
	end)
end

local function CloseUI()
	local TweenData = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TweenService:Create(BlurEffect, TweenData, {Size = 0}):Play()
	TweenService:Create(Overlay, TweenData, {BackgroundTransparency = 1}):Play()

	TweenService:Create(TitleLabel, TweenData, {TextTransparency = 1}):Play()
	TweenService:Create(SubtitleLabel, TweenData, {TextTransparency = 1}):Play()
	TweenService:Create(Line, TweenData, {BackgroundTransparency = 1}):Play()
	TweenService:Create(TextBoxContainer, TweenData, {BackgroundTransparency = 1}):Play()
	TweenService:Create(TextBoxStroke, TweenData, {Transparency = 1}):Play()
	TweenService:Create(KeyTextBox, TweenData, {TextTransparency = 1}):Play()
	TweenService:Create(CloseButton, TweenData, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
	TweenService:Create(CloseStroke, TweenData, {Transparency = 1}):Play()
	TweenService:Create(MainStroke, TweenData, {Transparency = 1}):Play()

	for _, v in ipairs(Buttons) do
		TweenService:Create(v.button, TweenData, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		TweenService:Create(v.stroke, TweenData, {Transparency = 1}):Play()
	end

	TweenService:Create(MainFrame, TweenData, {Size = UDim2.new(0, 0, 0, 0)}):Play()
	wait(0.35)
	BlurEffect:Destroy()
	ScreenGui:Destroy()
end

local function ValidateKey(key)
	local cleaned_key = key:gsub("%s", "")

	if not string.match(cleaned_key, "^[A-Za-z0-9]+$") or #cleaned_key ~= 32 then
		Notification("Error", "Invalid key format. Key must be 32 characters.", 5)
		return false
	end

	if cleaned_key ~= key then
		Notification("Info", "Extra spaces detected, verifying without spaces...", 5)
	end

	local Success, Result = pcall(luarmor_api.check_key, cleaned_key)

	if not Success then
		Notification("Error", "Network error. Please try again.", 5)
		return false
	end

	if Result.code == "KEY_VALID" then
		if not isfile(config.File) then
			pcall(writefile, config.File, cleaned_key)
		else
			if readfile(config.File) ~= cleaned_key then
				pcall(writefile, config.File, cleaned_key)
			end
		end

		script_key = cleaned_key

		getgenv().key = cleaned_key
		getgenv().luarmor_api = luarmor_api
		getgenv().key_expire = Result.data.auth_expire
		getgenv().key_note = Result.data.note
		getgenv().key_executions = Result.data.total_executions or 0

		Notification("Success", "Key expires in: " .. ToTime(Result.data.auth_expire - os.time()), 5)

		wait(1.5)
		CloseUI()

		if not (
			game_id == "3808223175" -- Jujutsu Infinite
				or game_id == "994732206" -- Blox Fruits
				or game_id == "1511883870" -- Shindo Life
				or game_id == "7018190066" -- Dead Rails
				or game_id == "7671049560" -- The Forge
				or game_id == "9363735110" -- Escape Tsunami For Brainrots!
				or game_id == "9509842868" -- Garden Horizons
				or game_id == "5130394318" -- Bizarre Lineage
			)
				and not getgenv().lilix then
			plr:Kick("This executor is not supported for this game.")
		end

		pcall(function()
			luarmor_api.load_script()
		end)

		return true
	end

	if error_messages[Result.code] then
		if Result.code == "SECURITY_ERROR" or Result.code == "UNKNOWN_ERROR" then
			plr:Kick(error_messages[Result.code])
		else
			DeleteFile(config.File)
			Notification("Error", error_messages[Result.code], 5)
		end
		return false
	end

	plr:Kick("Key check failed:\nCode: " .. Result.code)
	return false
end

for _, button in ipairs({Button1, Button2, Button3, Button4}) do
	button.MouseEnter:Connect(function()
		local hoverSize = is_mobile and UDim2.new(0, 330, 0, 45) or UDim2.new(0, 230, 0, 48)
		TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = hoverSize}):Play()
	end)
	button.MouseLeave:Connect(function()
		local normalSize = is_mobile and UDim2.new(0, 320, 0, 42) or UDim2.new(0, 220, 0, 45)
		TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize}):Play()
	end)
	button.MouseButton1Down:Connect(function()
		local clickSize = is_mobile and UDim2.new(0, 310, 0, 40) or UDim2.new(0, 210, 0, 42)
		TweenService:Create(button, TweenInfo.new(0.08), {Size = clickSize}):Play()
	end)
	button.MouseButton1Up:Connect(function()
		local normalSize = is_mobile and UDim2.new(0, 320, 0, 42) or UDim2.new(0, 220, 0, 45)
		TweenService:Create(button, TweenInfo.new(0.08), {Size = normalSize}):Play()
	end)
end

Button1.MouseButton1Click:Connect(function()
	setclipboard(config.Linkvertise)
	Notification("Link Copied", "Linkvertise link copied to clipboard", 5)
end)

Button2.MouseButton1Click:Connect(function()
	setclipboard(config.Rinku)
	Notification("Link Copied", "Rinku link copied to clipboard", 5)
end)

Button3.MouseButton1Click:Connect(function()
	setclipboard(config.Discord)
	Notification("Discord Copied", "Discord invite copied to clipboard", 5)
end)

Button4.MouseButton1Click:Connect(function()
	setclipboard(config.Shop)
	Notification("Link Copied", "Standard key shop link copied", 5)
end)

KeyTextBox.FocusLost:Connect(function()
	if KeyTextBox.Text == "" then
		return
	end

	if ValidateKey(KeyTextBox.Text) then
		--?
	else
		KeyTextBox.Text = ""
	end
end)

CloseButton.MouseButton1Click:Connect(CloseUI)

CloseButton.MouseEnter:Connect(function()
	TweenService:Create(CloseButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 35, 0, 35)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
	TweenService:Create(CloseButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 30, 0, 30)}):Play()
end)

MakeDraggable(MainFrame)

if is_mobile then
	MainFrame.Size = UDim2.new(0, 380, 0, 440)
	TitleLabel.TextSize = 22
	SubtitleLabel.TextSize = 10
	TextBoxContainer.Size = UDim2.new(0, 340, 0, 45)

	SetMobileScale()
end

local Final_Size = is_mobile and UDim2.new(0, 380, 0, 440) or UDim2.new(0, 580, 0, 340)
local Tween_Info2 = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

TweenService:Create(BlurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 24}):Play()
TweenService:Create(Overlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.3}):Play()
TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = Final_Size}):Play()

wait(0.3)

TweenService:Create(TitleLabel, Tween_Info2, {TextTransparency = 0}):Play()
TweenService:Create(SubtitleLabel, Tween_Info2, {TextTransparency = 0}):Play()
TweenService:Create(Line, Tween_Info2, {BackgroundTransparency = 0}):Play()
TweenService:Create(TextBoxContainer, Tween_Info2, {BackgroundTransparency = 0}):Play()
TweenService:Create(TextBoxStroke, Tween_Info2, {Transparency = 0}):Play()
TweenService:Create(KeyTextBox, Tween_Info2, {TextTransparency = 0}):Play()
TweenService:Create(CloseButton, Tween_Info2, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
TweenService:Create(CloseStroke, Tween_Info2, {Transparency = 0}):Play()
TweenService:Create(MainStroke, Tween_Info2, {Transparency = 0}):Play()

for _, Button in ipairs(Buttons) do
	TweenService:Create(Button.button, Tween_Info2, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
	TweenService:Create(Button.stroke, Tween_Info2, {Transparency = 0}):Play()
end

spawn(function()
	while task.wait(0.3) do
		local saved_key = (isfile(config.File) and readfile(config.File)) or (script_key ~= "" and script_key) or nil

		if saved_key and ValidateKey(saved_key) then
			return 
		end
	end
end)
