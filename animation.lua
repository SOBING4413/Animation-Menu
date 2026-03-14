-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- STATE VARIABLES
-- ============================================================
local IsMinimized = false
local ScriptActive = true
local SyncEnabled = false
local LockAnimationEnabled = false
local SelectedPlayer = nil
local AnimationSpeed = 1.0
local EmoteSpeed = 1.0
local CurrentAnimationId = ""
local CurrentAnimationName = ""
local ActiveAnimations = {}
local LockedAnimationTrack = nil
local LockedAnimationId = nil
local LockedAnimationName = nil
local SearchQuery = ""

local ThemeElements = {}

-- ============================================================
-- THEME SYSTEM
-- ============================================================
local Themes = {
    Cyan = {
        accent = Color3.fromRGB(0, 210, 210), accentLight = Color3.fromRGB(60, 255, 255),
        accentDark = Color3.fromRGB(0, 150, 150), gradTop = Color3.fromRGB(8, 24, 28),
        gradBot = Color3.fromRGB(4, 12, 16), cardBg = Color3.fromRGB(10, 24, 28),
        cardBgAlt = Color3.fromRGB(14, 30, 34), cardHover = Color3.fromRGB(18, 40, 46),
        panelBg = Color3.fromRGB(6, 18, 22), stroke = Color3.fromRGB(20, 65, 75),
        strokeLight = Color3.fromRGB(30, 100, 115), textPrimary = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(170, 220, 225), textMuted = Color3.fromRGB(100, 155, 165),
        scrollBar = Color3.fromRGB(0, 210, 210), glow = Color3.fromRGB(0, 255, 255),
    },
    Merah = {
        accent = Color3.fromRGB(230, 55, 65), accentLight = Color3.fromRGB(255, 95, 100),
        accentDark = Color3.fromRGB(170, 30, 35), gradTop = Color3.fromRGB(32, 10, 12),
        gradBot = Color3.fromRGB(14, 6, 8), cardBg = Color3.fromRGB(30, 12, 14),
        cardBgAlt = Color3.fromRGB(36, 15, 17), cardHover = Color3.fromRGB(50, 18, 22),
        panelBg = Color3.fromRGB(22, 9, 11), stroke = Color3.fromRGB(80, 25, 28),
        strokeLight = Color3.fromRGB(120, 40, 45), textPrimary = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(200, 170, 172), textMuted = Color3.fromRGB(140, 110, 112),
        scrollBar = Color3.fromRGB(230, 55, 65), glow = Color3.fromRGB(255, 70, 80),
    },
    Hijau = {
        accent = Color3.fromRGB(40, 200, 100), accentLight = Color3.fromRGB(70, 235, 130),
        accentDark = Color3.fromRGB(25, 150, 70), gradTop = Color3.fromRGB(10, 30, 16),
        gradBot = Color3.fromRGB(6, 14, 9), cardBg = Color3.fromRGB(12, 28, 16),
        cardBgAlt = Color3.fromRGB(15, 33, 20), cardHover = Color3.fromRGB(20, 44, 26),
        panelBg = Color3.fromRGB(9, 22, 13), stroke = Color3.fromRGB(28, 75, 38),
        strokeLight = Color3.fromRGB(40, 110, 55), textPrimary = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(175, 215, 185), textMuted = Color3.fromRGB(110, 150, 120),
        scrollBar = Color3.fromRGB(40, 200, 100), glow = Color3.fromRGB(60, 255, 120),
    },
    Biru = {
        accent = Color3.fromRGB(55, 130, 240), accentLight = Color3.fromRGB(90, 165, 255),
        accentDark = Color3.fromRGB(30, 90, 180), gradTop = Color3.fromRGB(10, 16, 35),
        gradBot = Color3.fromRGB(6, 8, 18), cardBg = Color3.fromRGB(12, 18, 36),
        cardBgAlt = Color3.fromRGB(15, 22, 42), cardHover = Color3.fromRGB(22, 30, 55),
        panelBg = Color3.fromRGB(9, 13, 28), stroke = Color3.fromRGB(28, 45, 85),
        strokeLight = Color3.fromRGB(45, 70, 130), textPrimary = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(175, 195, 225), textMuted = Color3.fromRGB(110, 130, 165),
        scrollBar = Color3.fromRGB(55, 130, 240), glow = Color3.fromRGB(80, 160, 255),
    },
    Ungu = {
        accent = Color3.fromRGB(150, 70, 235), accentLight = Color3.fromRGB(185, 110, 255),
        accentDark = Color3.fromRGB(110, 40, 180), gradTop = Color3.fromRGB(22, 10, 38),
        gradBot = Color3.fromRGB(10, 6, 20), cardBg = Color3.fromRGB(22, 12, 36),
        cardBgAlt = Color3.fromRGB(27, 16, 44), cardHover = Color3.fromRGB(36, 22, 56),
        panelBg = Color3.fromRGB(16, 9, 28), stroke = Color3.fromRGB(60, 28, 90),
        strokeLight = Color3.fromRGB(90, 45, 135), textPrimary = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(205, 185, 225), textMuted = Color3.fromRGB(145, 120, 165),
        scrollBar = Color3.fromRGB(150, 70, 235), glow = Color3.fromRGB(185, 100, 255),
    },
    ["Abu-abu"] = {
        accent = Color3.fromRGB(140, 145, 160), accentLight = Color3.fromRGB(185, 190, 205),
        accentDark = Color3.fromRGB(100, 105, 118), gradTop = Color3.fromRGB(28, 28, 32),
        gradBot = Color3.fromRGB(12, 12, 15), cardBg = Color3.fromRGB(26, 26, 30),
        cardBgAlt = Color3.fromRGB(32, 32, 37), cardHover = Color3.fromRGB(42, 42, 48),
        panelBg = Color3.fromRGB(20, 20, 24), stroke = Color3.fromRGB(55, 55, 62),
        strokeLight = Color3.fromRGB(80, 80, 90), textPrimary = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(185, 185, 195), textMuted = Color3.fromRGB(120, 120, 132),
        scrollBar = Color3.fromRGB(140, 145, 160), glow = Color3.fromRGB(200, 205, 220),
    },
}

local CurrentThemeName = "Cyan"
local CurrentTheme = Themes[CurrentThemeName]

-- ============================================================
-- ANIMATION LIST (DIPERBANYAK + VIRAL + SEARCH)
-- ============================================================
local AnimationList = {
    -- VIRAL
    {name = "Hype Dance", id = "rbxassetid://5917459365", category = "Viral"},
    {name = "Floss Dance", id = "rbxassetid://5917570207", category = "Viral"},
    {name = "Orange Justice", id = "rbxassetid://5918726674", category = "Viral"},
    {name = "Electro Shuffle", id = "rbxassetid://5918622618", category = "Viral"},
    {name = "Renegade", id = "rbxassetid://5915842560", category = "Viral"},
    {name = "Savage Dance", id = "rbxassetid://5915710948", category = "Viral"},
    {name = "Griddy", id = "rbxassetid://11158137076", category = "Viral"},
    {name = "Gangnam Style", id = "rbxassetid://4212455378", category = "Viral"},
    {name = "Default Dance", id = "rbxassetid://5918622618", category = "Viral"},
    {name = "Macarena", id = "rbxassetid://5915773155", category = "Viral"},
    {name = "Toosie Slide", id = "rbxassetid://5915842560", category = "Viral"},
    {name = "Say So Dance", id = "rbxassetid://5915710948", category = "Viral"},
    -- DANCE
    {name = "Robot Dance", id = "rbxassetid://616163682", category = "Dance"},
    {name = "Twist Dance", id = "rbxassetid://5917459365", category = "Dance"},
    {name = "Pop Lock", id = "rbxassetid://5917570207", category = "Dance"},
    {name = "Breakdance", id = "rbxassetid://5918726674", category = "Dance"},
    {name = "Disco Fever", id = "rbxassetid://5918622618", category = "Dance"},
    {name = "Hip Hop", id = "rbxassetid://616163682", category = "Dance"},
    {name = "Moonwalk", id = "rbxassetid://5915842560", category = "Dance"},
    {name = "Shuffle", id = "rbxassetid://5915710948", category = "Dance"},
    {name = "Salsa", id = "rbxassetid://5917459365", category = "Dance"},
    {name = "Charleston", id = "rbxassetid://5917570207", category = "Dance"},
    {name = "Running Man", id = "rbxassetid://5918622618", category = "Dance"},
    -- EMOTE
    {name = "Headless Horseman", id = "rbxassetid://5915773155", category = "Emote"},
    {name = "Levitation", id = "rbxassetid://616006778", category = "Emote"},
    {name = "Salute", id = "rbxassetid://616003345", category = "Emote"},
    {name = "Stadium", id = "rbxassetid://616095330", category = "Emote"},
    {name = "Tilt", id = "rbxassetid://616008087", category = "Emote"},
    {name = "Shrug", id = "rbxassetid://3334392772", category = "Emote"},
    {name = "Wave", id = "rbxassetid://507770239", category = "Emote"},
    {name = "Laugh", id = "rbxassetid://507770818", category = "Emote"},
    {name = "Cheer", id = "rbxassetid://507770677", category = "Emote"},
    {name = "Dab", id = "rbxassetid://5918726674", category = "Emote"},
    {name = "Air Guitar", id = "rbxassetid://5917459365", category = "Emote"},
    {name = "Bow", id = "rbxassetid://507770239", category = "Emote"},
    {name = "Cry", id = "rbxassetid://507770818", category = "Emote"},
    {name = "Flex", id = "rbxassetid://507770677", category = "Emote"},
    {name = "Facepalm", id = "rbxassetid://3334392772", category = "Emote"},
    {name = "Thinking", id = "rbxassetid://616008087", category = "Emote"},
    -- WALK
    {name = "Zombie Walk", id = "rbxassetid://616168032", category = "Walk"},
    {name = "Penguin Walk", id = "rbxassetid://616036843", category = "Walk"},
    {name = "Cowboy Walk", id = "rbxassetid://616168032", category = "Walk"},
    {name = "Sneaky Walk", id = "rbxassetid://616036843", category = "Walk"},
    {name = "Swagger Walk", id = "rbxassetid://616168032", category = "Walk"},
    -- RUN
    {name = "Ninja Run", id = "rbxassetid://656118852", category = "Run"},
    {name = "Naruto Run", id = "rbxassetid://656118852", category = "Run"},
    {name = "Superhero Run", id = "rbxassetid://656118852", category = "Run"},
}

-- ============================================================
-- TWEEN HELPERS
-- ============================================================
local function Tween(obj, props, duration, style, dir)
    local info = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function TweenWait(obj, props, duration, style, dir)
    local t = Tween(obj, props, duration, style, dir)
    t.Completed:Wait()
end

local function TweenBounce(obj, props, duration)
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function TweenElastic(obj, props, duration)
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- ============================================================
-- SCREEN GUI
-- ============================================================
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "AnimationControllerGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- ============================================================
-- NOTIFICATION SYSTEM
-- ============================================================
local notifContainer = Instance.new("Frame", gui)
notifContainer.Name = "NotificationContainer"
notifContainer.Size = UDim2.new(0, 340, 1, 0)
notifContainer.Position = UDim2.new(1, -350, 0, 10)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 200

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 8)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local notifOrderCounter = 0
local NotifIcons = {
    success = "✅", error = "❌", info = "ℹ️", warning = "⚠️",
    sync = "🔗", unsync = "🔓", lock = "🔒", unlock = "🔓",
    anim = "🎭", speed = "⚡", player = "👤",
}
local NotifColors = {
    success = Color3.fromRGB(40, 200, 100), error = Color3.fromRGB(230, 55, 65),
    info = Color3.fromRGB(55, 170, 240), warning = Color3.fromRGB(240, 180, 40),
    sync = Color3.fromRGB(0, 210, 210), unsync = Color3.fromRGB(180, 100, 50),
    lock = Color3.fromRGB(150, 70, 235), unlock = Color3.fromRGB(140, 145, 160),
    anim = Color3.fromRGB(230, 55, 65), speed = Color3.fromRGB(255, 200, 40),
    player = Color3.fromRGB(55, 130, 240),
}

local function SendNotification(notifType, titleText, messageText, duration)
    duration = duration or 3.5
    notifOrderCounter = notifOrderCounter + 1
    local notifColor = NotifColors[notifType] or Color3.fromRGB(55, 130, 240)
    local notifIcon = NotifIcons[notifType] or "🔔"

    local notif = Instance.new("Frame", notifContainer)
    notif.Name = "Notif_" .. notifOrderCounter
    notif.Size = UDim2.new(0, 330, 0, 0)
    notif.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.LayoutOrder = notifOrderCounter
    notif.ZIndex = 201
    notif.BackgroundTransparency = 0.02
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 14)

    local notifStroke = Instance.new("UIStroke", notif)
    notifStroke.Color = notifColor
    notifStroke.Thickness = 1.5
    notifStroke.Transparency = 0.3

    local accentBar = Instance.new("Frame", notif)
    accentBar.Size = UDim2.new(0, 4, 0, 0)
    accentBar.Position = UDim2.new(0, 6, 0.5, 0)
    accentBar.AnchorPoint = Vector2.new(0, 0.5)
    accentBar.BackgroundColor3 = notifColor
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 203
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 3)

    local iconLabel = Instance.new("TextLabel", notif)
    iconLabel.Size = UDim2.new(0, 34, 0, 34)
    iconLabel.Position = UDim2.new(0, 18, 0, 12)
    iconLabel.BackgroundColor3 = notifColor
    iconLabel.BackgroundTransparency = 0.82
    iconLabel.Text = notifIcon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.BorderSizePixel = 0
    iconLabel.ZIndex = 204
    Instance.new("UICorner", iconLabel).CornerRadius = UDim.new(0, 10)

    local notifTitle = Instance.new("TextLabel", notif)
    notifTitle.Size = UDim2.new(1, -110, 0, 18)
    notifTitle.Position = UDim2.new(0, 60, 0, 10)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = titleText or "Notification"
    notifTitle.Font = Enum.Font.GothamBlack
    notifTitle.TextSize = 13
    notifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.ZIndex = 204

    local notifMsg = Instance.new("TextLabel", notif)
    notifMsg.Size = UDim2.new(1, -110, 0, 28)
    notifMsg.Position = UDim2.new(0, 60, 0, 28)
    notifMsg.BackgroundTransparency = 1
    notifMsg.Text = messageText or ""
    notifMsg.Font = Enum.Font.Gotham
    notifMsg.TextSize = 11
    notifMsg.TextColor3 = Color3.fromRGB(180, 185, 200)
    notifMsg.TextXAlignment = Enum.TextXAlignment.Left
    notifMsg.TextWrapped = true
    notifMsg.ZIndex = 204

    local notifClose = Instance.new("TextButton", notif)
    notifClose.Size = UDim2.new(0, 26, 0, 26)
    notifClose.Position = UDim2.new(1, -32, 0, 8)
    notifClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notifClose.BackgroundTransparency = 0.92
    notifClose.Text = "✕"
    notifClose.Font = Enum.Font.GothamBold
    notifClose.TextSize = 10
    notifClose.TextColor3 = Color3.fromRGB(140, 140, 155)
    notifClose.BorderSizePixel = 0
    notifClose.AutoButtonColor = false
    notifClose.ZIndex = 205
    Instance.new("UICorner", notifClose).CornerRadius = UDim.new(0, 7)

    local progressBar = Instance.new("Frame", notif)
    progressBar.Size = UDim2.new(1, -16, 0, 3)
    progressBar.Position = UDim2.new(0, 8, 1, -8)
    progressBar.BackgroundColor3 = Color3.fromRGB(30, 32, 45)
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 203
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0, 2)

    local progressFill = Instance.new("Frame", progressBar)
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.BackgroundColor3 = notifColor
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 204
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 2)

    Tween(notif, {Size = UDim2.new(0, 330, 0, 72)}, 0.4, Enum.EasingStyle.Back)
    task.delay(0.15, function() Tween(accentBar, {Size = UDim2.new(0, 4, 1, -12)}, 0.3) end)
    Tween(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)

    local dismissed = false
    local function DismissNotif()
        if dismissed then return end
        dismissed = true
        Tween(notif, {Size = UDim2.new(0, 330, 0, 0), BackgroundTransparency = 1}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.4)
        notif:Destroy()
    end
    notifClose.MouseButton1Click:Connect(DismissNotif)
    task.delay(duration, DismissNotif)
end

-- ============================================================
-- MAIN FRAME & SHADOW
-- ============================================================
local shadow = Instance.new("ImageLabel", gui)
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 1
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.Size = UDim2.new(0, 860, 0, 560)
shadow.Position = UDim2.new(0.5, -430, 0.5, -280)
shadow.ZIndex = 1

local frame = Instance.new("Frame", gui)
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 820, 0, 520)
frame.Position = UDim2.new(0.5, -410, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Visible = false
frame.ZIndex = 2

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)
local mainStroke = Instance.new("UIStroke", frame)
mainStroke.Color = CurrentTheme.stroke
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.1

local mainGrad = Instance.new("UIGradient", frame)
mainGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, CurrentTheme.gradTop),
    ColorSequenceKeypoint.new(1, CurrentTheme.gradBot)
}
mainGrad.Rotation = 145

local OriginalSize = UDim2.new(0, 820, 0, 520)
local OriginalShadowSize = UDim2.new(0, 860, 0, 560)

frame:GetPropertyChangedSignal("Position"):Connect(function()
    shadow.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset - 20, frame.Position.Y.Scale, frame.Position.Y.Offset - 20)
end)

-- ============================================================
-- TOP BAR
-- ============================================================
local topBar = Instance.new("Frame", frame)
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 52)
topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
topBar.BackgroundTransparency = 0.45
topBar.BorderSizePixel = 0
topBar.ZIndex = 5
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 18)

local topBarFill = Instance.new("Frame", topBar)
topBarFill.Size = UDim2.new(1, 0, 0, 20)
topBarFill.Position = UDim2.new(0, 0, 1, -20)
topBarFill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
topBarFill.BackgroundTransparency = 0.45
topBarFill.BorderSizePixel = 0
topBarFill.ZIndex = 5

local accentLine = Instance.new("Frame", frame)
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 0, 52)
accentLine.BackgroundColor3 = CurrentTheme.accent
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 6

local accentGlowGrad = Instance.new("UIGradient", accentLine)
accentGlowGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0.9)
}

task.spawn(function()
    while accentGlowGrad and accentGlowGrad.Parent do
        accentGlowGrad.Offset = Vector2.new(-1, 0)
        TweenWait(accentGlowGrad, {Offset = Vector2.new(1, 0)}, 2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1)
    end
end)

-- Title icon
local titleIconGlow = Instance.new("Frame", topBar)
titleIconGlow.Size = UDim2.new(0, 42, 0, 42)
titleIconGlow.Position = UDim2.new(0, 8, 0.5, -21)
titleIconGlow.BackgroundColor3 = CurrentTheme.accent
titleIconGlow.BackgroundTransparency = 0.75
titleIconGlow.BorderSizePixel = 0
titleIconGlow.ZIndex = 5
Instance.new("UICorner", titleIconGlow).CornerRadius = UDim.new(0, 12)

local titleIcon = Instance.new("TextLabel", topBar)
titleIcon.Size = UDim2.new(0, 36, 0, 36)
titleIcon.Position = UDim2.new(0, 11, 0.5, -18)
titleIcon.BackgroundColor3 = CurrentTheme.accent
titleIcon.Text = "🎭"
titleIcon.Font = Enum.Font.GothamBlack
titleIcon.TextSize = 18
titleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
titleIcon.BorderSizePixel = 0
titleIcon.ZIndex = 6
Instance.new("UICorner", titleIcon).CornerRadius = UDim.new(0, 10)

local titleIconStroke = Instance.new("UIStroke", titleIcon)
titleIconStroke.Color = CurrentTheme.accentLight
titleIconStroke.Thickness = 1.5
titleIconStroke.Transparency = 0.4

task.spawn(function()
    while titleIconGlow and titleIconGlow.Parent do
        TweenWait(titleIconGlow, {BackgroundTransparency = 0.6, Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0, 6, 0.5, -23)}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenWait(titleIconGlow, {BackgroundTransparency = 0.8, Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0, 8, 0.5, -21)}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    end
end)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(0, 350, 0, 24)
title.Position = UDim2.new(0, 56, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Animation Menu"
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextColor3 = CurrentTheme.textPrimary
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6

local subtitle = Instance.new("TextLabel", topBar)
subtitle.Size = UDim2.new(0, 350, 0, 14)
subtitle.Position = UDim2.new(0, 56, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.Text = "by Sobing4413"
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 10
subtitle.TextColor3 = CurrentTheme.textMuted
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 6

-- Control Buttons
local function CreateControlBtn(name, text, hoverColor, posX, textSz)
    local btn = Instance.new("TextButton", topBar)
    btn.Name = name
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = UDim2.new(1, posX, 0.5, -16)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.92
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = textSz or 14
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 6
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
    btn.MouseEnter:Connect(function()
        TweenBounce(btn, {Size = UDim2.new(0, 36, 0, 36), Position = UDim2.new(1, posX - 2, 0.5, -18)}, 0.2)
        Tween(btn, {BackgroundColor3 = hoverColor, BackgroundTransparency = 0.12, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end)
    btn.MouseLeave:Connect(function()
        TweenBounce(btn, {Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, posX, 0.5, -16)}, 0.2)
        Tween(btn, {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92, TextColor3 = Color3.fromRGB(180, 180, 190)}, 0.2)
    end)
    return btn
end

local closeBtn = CreateControlBtn("CloseBtn", "✕", Color3.fromRGB(220, 50, 50), -44, 13)
local minimizeBtn = CreateControlBtn("MinimizeBtn", "—", Color3.fromRGB(220, 180, 40), -82, 14)
local themeBtn = CreateControlBtn("ThemeBtn", "◆", CurrentTheme.accent, -120, 12)

closeBtn.MouseButton1Click:Connect(function()
    SendNotification("info", "Menutup GUI", "Animation Menu ditutup...", 2)
    task.wait(0.3)
    Tween(frame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    Tween(shadow, {ImageTransparency = 1}, 0.3)
    task.wait(0.55)
    gui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    if IsMinimized then
        IsMinimized = false
        TweenBounce(frame, {Size = OriginalSize}, 0.4)
        Tween(shadow, {Size = OriginalShadowSize, ImageTransparency = 0.5}, 0.35)
    else
        IsMinimized = true
        Tween(frame, {Size = UDim2.new(0, 820, 0, 52)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(shadow, {Size = UDim2.new(0, 860, 0, 92), ImageTransparency = 0.7}, 0.35)
    end
end)

-- ============================================================
-- THEME SELECTOR
-- ============================================================
local themePanel = Instance.new("Frame", gui)
themePanel.Name = "ThemePanel"
themePanel.Size = UDim2.new(0, 220, 0, 0)
themePanel.Position = UDim2.new(0.5, 280, 0.5, -260)
themePanel.BackgroundColor3 = Color3.fromRGB(14, 16, 24)
themePanel.BorderSizePixel = 0
themePanel.Visible = false
themePanel.ZIndex = 50
themePanel.ClipsDescendants = true
Instance.new("UICorner", themePanel).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", themePanel).Color = Color3.fromRGB(40, 44, 58)

local themePanelHeader = Instance.new("TextLabel", themePanel)
themePanelHeader.Size = UDim2.new(1, -16, 0, 28)
themePanelHeader.Position = UDim2.new(0, 8, 0, 6)
themePanelHeader.BackgroundTransparency = 1
themePanelHeader.Text = "🎨 PILIH TEMA"
themePanelHeader.Font = Enum.Font.GothamBlack
themePanelHeader.TextSize = 11
themePanelHeader.TextColor3 = Color3.fromRGB(150, 155, 175)
themePanelHeader.TextXAlignment = Enum.TextXAlignment.Left
themePanelHeader.ZIndex = 51

local RefreshAnimationList
local UpdatePlayerList

local function ApplyTheme(themeName)
    CurrentThemeName = themeName
    CurrentTheme = Themes[themeName]
    mainGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, CurrentTheme.gradTop), ColorSequenceKeypoint.new(1, CurrentTheme.gradBot)}
    mainStroke.Color = CurrentTheme.stroke
    accentLine.BackgroundColor3 = CurrentTheme.accent
    titleIcon.BackgroundColor3 = CurrentTheme.accent
    titleIconGlow.BackgroundColor3 = CurrentTheme.accent
    titleIconStroke.Color = CurrentTheme.accentLight
    title.TextColor3 = CurrentTheme.textPrimary
    subtitle.TextColor3 = CurrentTheme.textMuted
    for _, elem in ipairs(ThemeElements) do
        if elem.obj and elem.obj.Parent then
            if elem.prop == "BackgroundColor3" then Tween(elem.obj, {BackgroundColor3 = CurrentTheme[elem.themeKey]}, 0.3)
            elseif elem.prop == "TextColor3" then Tween(elem.obj, {TextColor3 = CurrentTheme[elem.themeKey]}, 0.3)
            elseif elem.prop == "Color" then Tween(elem.obj, {Color = CurrentTheme[elem.themeKey]}, 0.3)
            elseif elem.prop == "ScrollBarImageColor3" then elem.obj.ScrollBarImageColor3 = CurrentTheme[elem.themeKey]
            end
        end
    end
    if RefreshAnimationList then RefreshAnimationList() end
    if UpdatePlayerList then UpdatePlayerList() end
    SendNotification("info", "Tema Diubah ✨", "Tema: " .. themeName, 2.5)
end

local themeOrder = {"Merah", "Hijau", "Biru", "Ungu", "Cyan", "Abu-abu"}
local themeBtnList = {}
for idx, name in ipairs(themeOrder) do
    local theme = Themes[name]
    local optBtn = Instance.new("TextButton", themePanel)
    optBtn.Size = UDim2.new(1, -16, 0, 38)
    optBtn.Position = UDim2.new(0, 8, 0, 34 + (idx - 1) * 42)
    optBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
    optBtn.Text = ""
    optBtn.BorderSizePixel = 0
    optBtn.AutoButtonColor = false
    optBtn.ZIndex = 51
    Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 10)

    local colorDot = Instance.new("Frame", optBtn)
    colorDot.Size = UDim2.new(0, 18, 0, 18)
    colorDot.Position = UDim2.new(0, 10, 0.5, -9)
    colorDot.BackgroundColor3 = theme.accent
    colorDot.BorderSizePixel = 0
    colorDot.ZIndex = 52
    Instance.new("UICorner", colorDot).CornerRadius = UDim.new(1, 0)

    local nameLabel = Instance.new("TextLabel", optBtn)
    nameLabel.Size = UDim2.new(1, -50, 1, 0)
    nameLabel.Position = UDim2.new(0, 36, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 52

    local check = Instance.new("TextLabel", optBtn)
    check.Name = "Check"
    check.Size = UDim2.new(0, 22, 0, 22)
    check.Position = UDim2.new(1, -30, 0.5, -11)
    check.BackgroundTransparency = 1
    check.Text = (name == CurrentThemeName) and "✓" or ""
    check.Font = Enum.Font.GothamBold
    check.TextSize = 15
    check.TextColor3 = theme.accent
    check.ZIndex = 52

    optBtn.MouseButton1Click:Connect(function()
        ApplyTheme(name)
        for _, b in ipairs(themeBtnList) do
            local c = b:FindFirstChild("Check")
            if c then c.Text = "" end
        end
        check.Text = "✓"
        task.wait(0.2)
        Tween(themePanel, {Size = UDim2.new(0, 220, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.35)
        themePanel.Visible = false
    end)
    table.insert(themeBtnList, optBtn)
end

local themePanelFullHeight = 34 + #themeOrder * 42 + 10
themeBtn.MouseButton1Click:Connect(function()
    if themePanel.Visible then
        Tween(themePanel, {Size = UDim2.new(0, 220, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.35)
        themePanel.Visible = false
    else
        themePanel.Size = UDim2.new(0, 220, 0, 0)
        themePanel.Visible = true
        TweenBounce(themePanel, {Size = UDim2.new(0, 220, 0, themePanelFullHeight)}, 0.35)
    end
end)

-- ============================================================
-- LEFT PANEL
-- ============================================================
local leftPanel = Instance.new("Frame", frame)
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 260, 1, -64)
leftPanel.Position = UDim2.new(0, 10, 0, 58)
leftPanel.BackgroundColor3 = CurrentTheme.panelBg
leftPanel.BackgroundTransparency = 0.1
leftPanel.BorderSizePixel = 0
leftPanel.ZIndex = 3
leftPanel.ClipsDescendants = true
Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", leftPanel).Color = Color3.fromRGB(30, 34, 46)
table.insert(ThemeElements, {obj = leftPanel, prop = "BackgroundColor3", themeKey = "panelBg"})

-- Toggle Button Helper
local function CreateToggleButton(parent, yPos, defaultText, onColor)
    local toggleBtn = Instance.new("TextButton", parent)
    toggleBtn.Size = UDim2.new(1, -20, 0, 34)
    toggleBtn.Position = UDim2.new(0, 10, 0, yPos)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 5
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)
    local toggleStroke = Instance.new("UIStroke", toggleBtn)
    toggleStroke.Color = Color3.fromRGB(45, 50, 60)
    toggleStroke.Thickness = 1.5

    local track = Instance.new("Frame", toggleBtn)
    track.Size = UDim2.new(0, 46, 0, 22)
    track.Position = UDim2.new(0, 8, 0.5, -11)
    track.BackgroundColor3 = Color3.fromRGB(40, 42, 52)
    track.BorderSizePixel = 0
    track.ZIndex = 6
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(140, 142, 155)
    knob.BorderSizePixel = 0
    knob.ZIndex = 8
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel", toggleBtn)
    label.Size = UDim2.new(1, -66, 1, 0)
    label.Position = UDim2.new(0, 60, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = defaultText
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextColor3 = Color3.fromRGB(130, 132, 148)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 6

    local isOn = false
    local function UpdateVisual(state)
        isOn = state
        if isOn then
            Tween(track, {BackgroundColor3 = onColor}, 0.3)
            TweenElastic(knob, {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.5)
            Tween(toggleStroke, {Color = onColor}, 0.3)
            Tween(label, {TextColor3 = onColor}, 0.2)
        else
            Tween(track, {BackgroundColor3 = Color3.fromRGB(40, 42, 52)}, 0.3)
            TweenElastic(knob, {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Color3.fromRGB(140, 142, 155)}, 0.5)
            Tween(toggleStroke, {Color = Color3.fromRGB(45, 50, 60)}, 0.3)
            Tween(label, {TextColor3 = Color3.fromRGB(130, 132, 148)}, 0.2)
        end
    end
    return toggleBtn, label, UpdateVisual
end

-- COPY EMOTE SECTION
local syncSection = Instance.new("Frame", leftPanel)
syncSection.Size = UDim2.new(1, -16, 0, 70)
syncSection.Position = UDim2.new(0, 8, 0, 8)
syncSection.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
syncSection.BorderSizePixel = 0
syncSection.ZIndex = 4
Instance.new("UICorner", syncSection).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", syncSection).Color = Color3.fromRGB(30, 36, 52)

local syncTitle = Instance.new("TextLabel", syncSection)
syncTitle.Size = UDim2.new(1, -12, 0, 16)
syncTitle.Position = UDim2.new(0, 10, 0, 6)
syncTitle.BackgroundTransparency = 1
syncTitle.Text = "🔗 COPY EMOTE PLAYER"
syncTitle.Font = Enum.Font.GothamBlack
syncTitle.TextSize = 9
syncTitle.TextColor3 = Color3.fromRGB(0, 200, 180)
syncTitle.TextXAlignment = Enum.TextXAlignment.Left
syncTitle.ZIndex = 5

local syncToggle, syncLabel, UpdateSyncVisual = CreateToggleButton(syncSection, 26, "OFF — Klik untuk Copy Emote", Color3.fromRGB(0, 210, 210))

local syncConnection = nil
local function StartSyncFromPlayer()
    if syncConnection then syncConnection:Disconnect(); syncConnection = nil end
    if not SyncEnabled or not SelectedPlayer then return end
    local lastCopiedAnimId = ""
    syncConnection = RunService.Heartbeat:Connect(function()
        if not SyncEnabled or not SelectedPlayer then return end
        local targetPlayer = Players:FindFirstChild(SelectedPlayer)
        if not targetPlayer or not targetPlayer.Character then return end
        local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not targetHumanoid then return end
        local targetAnimator = targetHumanoid:FindFirstChildOfClass("Animator")
        if not targetAnimator then return end
        local playingTracks = targetAnimator:GetPlayingAnimationTracks()
        local bestTrack, bestPri = nil, -1
        for _, t in ipairs(playingTracks) do
            local priNum = 0
            local pri = t.Priority
            if pri == Enum.AnimationPriority.Action4 then priNum = 6
            elseif pri == Enum.AnimationPriority.Action3 then priNum = 5
            elseif pri == Enum.AnimationPriority.Action2 then priNum = 4
            elseif pri == Enum.AnimationPriority.Action then priNum = 3
            elseif pri == Enum.AnimationPriority.Movement then priNum = 2
            elseif pri == Enum.AnimationPriority.Idle then priNum = 1 end
            if priNum > bestPri and t.IsPlaying then bestPri = priNum; bestTrack = t end
        end
        if bestTrack and bestTrack.Animation then
            local animId = bestTrack.Animation.AnimationId
            if animId and animId ~= "" and animId ~= lastCopiedAnimId then
                lastCopiedAnimId = animId
                local myChar = player.Character
                if not myChar then return end
                local myHum = myChar:FindFirstChildOfClass("Humanoid")
                if not myHum then return end
                local myAnim = myHum:FindFirstChildOfClass("Animator")
                if not myAnim then myAnim = Instance.new("Animator", myHum) end
                for _, tr in pairs(ActiveAnimations) do if tr and tr.IsPlaying then tr:Stop(0.2) end end
                ActiveAnimations = {}
                local animation = Instance.new("Animation")
                animation.AnimationId = animId
                local ok, newTrack = pcall(function() return myAnim:LoadAnimation(animation) end)
                if ok and newTrack then
                    newTrack.Priority = Enum.AnimationPriority.Action4
                    newTrack.Looped = bestTrack.Looped
                    newTrack:Play()
                    newTrack:AdjustSpeed(bestTrack.Speed * AnimationSpeed)
                    CurrentAnimationId = animId
                    CurrentAnimationName = "Copied from " .. SelectedPlayer
                    ActiveAnimations[animId] = newTrack
                end
            end
        end
    end)
end

syncToggle.MouseButton1Click:Connect(function()
    SyncEnabled = not SyncEnabled
    UpdateSyncVisual(SyncEnabled)
    if SyncEnabled then
        if not SelectedPlayer then
            syncLabel.Text = "ON — Pilih player dulu!"
            SendNotification("warning", "Copy Emote AKTIF ⚠️", "Pilih player dari daftar kanan!", 3)
        else
            syncLabel.Text = "ON — Copying " .. SelectedPlayer
            SendNotification("sync", "Copy Emote AKTIF 🔗", "Kamu mengikuti emote dari " .. SelectedPlayer, 3)
        end
        StartSyncFromPlayer()
    else
        syncLabel.Text = "OFF — Klik untuk Copy Emote"
        SendNotification("unsync", "Copy Emote NONAKTIF", "Berhenti mengikuti animasi.", 2.5)
        if syncConnection then syncConnection:Disconnect(); syncConnection = nil end
    end
end)

-- LOCK ANIMATION SECTION
local lockSection = Instance.new("Frame", leftPanel)
lockSection.Size = UDim2.new(1, -16, 0, 70)
lockSection.Position = UDim2.new(0, 8, 0, 84)
lockSection.BackgroundColor3 = Color3.fromRGB(16, 12, 28)
lockSection.BorderSizePixel = 0
lockSection.ZIndex = 4
Instance.new("UICorner", lockSection).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", lockSection).Color = Color3.fromRGB(40, 28, 60)

local lockTitle = Instance.new("TextLabel", lockSection)
lockTitle.Size = UDim2.new(1, -12, 0, 16)
lockTitle.Position = UDim2.new(0, 10, 0, 6)
lockTitle.BackgroundTransparency = 1
lockTitle.Text = "🔒 LOCK ANIMATION"
lockTitle.Font = Enum.Font.GothamBlack
lockTitle.TextSize = 9
lockTitle.TextColor3 = Color3.fromRGB(180, 120, 255)
lockTitle.TextXAlignment = Enum.TextXAlignment.Left
lockTitle.ZIndex = 5

local lockToggle, lockLabel, UpdateLockVisual = CreateToggleButton(lockSection, 26, "OFF — Animasi normal", Color3.fromRGB(150, 70, 235))

lockToggle.MouseButton1Click:Connect(function()
    LockAnimationEnabled = not LockAnimationEnabled
    UpdateLockVisual(LockAnimationEnabled)
    if LockAnimationEnabled then
        lockLabel.Text = "ON — Animasi Terkunci!"
        SendNotification("lock", "Lock AKTIF 🔒", "Animasi tetap saat bergerak.", 3)
        if CurrentAnimationId ~= "" then
            local ch = player.Character
            if ch then
                local hum = ch:FindFirstChildOfClass("Humanoid")
                if hum then
                    local anim = hum:FindFirstChildOfClass("Animator")
                    if anim then
                        local existing = ActiveAnimations[CurrentAnimationId]
                        if existing and existing.IsPlaying then
                            LockedAnimationTrack = existing
                            LockedAnimationId = CurrentAnimationId
                            LockedAnimationName = CurrentAnimationName
                            existing.Looped = true
                            existing.Priority = Enum.AnimationPriority.Action4
                        end
                    end
                end
            end
        end
    else
        lockLabel.Text = "OFF — Animasi normal"
        SendNotification("unlock", "Lock NONAKTIF", "Animasi kembali normal.", 2.5)
        if LockedAnimationTrack then LockedAnimationTrack:Stop(0.3) end
        LockedAnimationTrack = nil; LockedAnimationId = nil; LockedAnimationName = nil
    end
end)

-- SPEED CONTROLS
local speedSection = Instance.new("Frame", leftPanel)
speedSection.Size = UDim2.new(1, -16, 0, 160)
speedSection.Position = UDim2.new(0, 8, 0, 160)
speedSection.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
speedSection.BorderSizePixel = 0
speedSection.ZIndex = 4
speedSection.ClipsDescendants = true
Instance.new("UICorner", speedSection).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", speedSection).Color = Color3.fromRGB(30, 36, 52)

local speedTitle = Instance.new("TextLabel", speedSection)
speedTitle.Size = UDim2.new(1, -12, 0, 16)
speedTitle.Position = UDim2.new(0, 10, 0, 6)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "⚡ SPEED CONTROL"
speedTitle.Font = Enum.Font.GothamBlack
speedTitle.TextSize = 9
speedTitle.TextColor3 = Color3.fromRGB(255, 200, 40)
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.ZIndex = 5

local animSpeedLabel = Instance.new("TextLabel", speedSection)
animSpeedLabel.Size = UDim2.new(1, -20, 0, 14)
animSpeedLabel.Position = UDim2.new(0, 10, 0, 26)
animSpeedLabel.BackgroundTransparency = 1
animSpeedLabel.Text = "🎭 Animation Speed: 1.0x"
animSpeedLabel.Font = Enum.Font.GothamMedium
animSpeedLabel.TextSize = 10
animSpeedLabel.TextColor3 = Color3.fromRGB(180, 185, 200)
animSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
animSpeedLabel.ZIndex = 5

local function CreateSpeedButtons(parent, yPos, currentSpeed, onSpeedChange)
    local speeds = {0.5, 1.0, 1.5, 2.0, 3.0, 5.0}
    local allBtns = {}
    local gap, w = 4, 35
    for i, spd in ipairs(speeds) do
        local row = (i <= 4) and 0 or 1
        local col = (i <= 4) and (i - 1) or (i - 5)
        local spdBtn = Instance.new("TextButton", parent)
        spdBtn.Size = UDim2.new(0, w, 0, 24)
        spdBtn.Position = UDim2.new(0, 10 + col * (w + gap), 0, yPos + row * 28)
        spdBtn.BackgroundColor3 = (spd == currentSpeed) and Color3.fromRGB(0, 180, 170) or Color3.fromRGB(28, 30, 42)
        spdBtn.Text = spd .. "x"
        spdBtn.Font = Enum.Font.GothamBold
        spdBtn.TextSize = 9
        spdBtn.TextColor3 = (spd == currentSpeed) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 155, 170)
        spdBtn.BorderSizePixel = 0
        spdBtn.AutoButtonColor = false
        spdBtn.ZIndex = 6
        Instance.new("UICorner", spdBtn).CornerRadius = UDim.new(0, 6)
        allBtns[i] = {btn = spdBtn, speed = spd}
        spdBtn.MouseButton1Click:Connect(function()
            currentSpeed = spd
            onSpeedChange(spd)
            for _, d in ipairs(allBtns) do
                local a = d.speed == spd
                Tween(d.btn, {BackgroundColor3 = a and Color3.fromRGB(0, 180, 170) or Color3.fromRGB(28, 30, 42), TextColor3 = a and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 155, 170)}, 0.2)
            end
        end)
    end
end

CreateSpeedButtons(speedSection, 42, 1.0, function(speed)
    AnimationSpeed = speed
    animSpeedLabel.Text = "🎭 Animation Speed: " .. speed .. "x"
    SendNotification("speed", "Anim Speed ⚡", speed .. "x", 2)
    for _, tr in pairs(ActiveAnimations) do if tr and tr.IsPlaying then tr:AdjustSpeed(speed) end end
    if LockedAnimationTrack and LockedAnimationTrack.IsPlaying then LockedAnimationTrack:AdjustSpeed(speed) end
end)

local emoteSpeedLabel = Instance.new("TextLabel", speedSection)
emoteSpeedLabel.Size = UDim2.new(1, -20, 0, 14)
emoteSpeedLabel.Position = UDim2.new(0, 10, 0, 98)
emoteSpeedLabel.BackgroundTransparency = 1
emoteSpeedLabel.Text = "💃 Emote Speed: 1.0x"
emoteSpeedLabel.Font = Enum.Font.GothamMedium
emoteSpeedLabel.TextSize = 10
emoteSpeedLabel.TextColor3 = Color3.fromRGB(180, 185, 200)
emoteSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
emoteSpeedLabel.ZIndex = 5

CreateSpeedButtons(speedSection, 114, 1.0, function(speed)
    EmoteSpeed = speed
    emoteSpeedLabel.Text = "💃 Emote Speed: " .. speed .. "x"
    SendNotification("speed", "Emote Speed ⚡", speed .. "x", 2)
end)

-- CUSTOM ANIMATION ID
local customSection = Instance.new("Frame", leftPanel)
customSection.Size = UDim2.new(1, -16, 0, 70)
customSection.Position = UDim2.new(0, 8, 0, 326)
customSection.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
customSection.BorderSizePixel = 0
customSection.ZIndex = 4
Instance.new("UICorner", customSection).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", customSection).Color = Color3.fromRGB(30, 36, 52)

local customTitle = Instance.new("TextLabel", customSection)
customTitle.Size = UDim2.new(1, -12, 0, 16)
customTitle.Position = UDim2.new(0, 10, 0, 6)
customTitle.BackgroundTransparency = 1
customTitle.Text = "🆔 CUSTOM ANIMATION ID"
customTitle.Font = Enum.Font.GothamBlack
customTitle.TextSize = 9
customTitle.TextColor3 = CurrentTheme.textMuted
customTitle.TextXAlignment = Enum.TextXAlignment.Left
customTitle.ZIndex = 5
table.insert(ThemeElements, {obj = customTitle, prop = "TextColor3", themeKey = "textMuted"})

local animIdInput = Instance.new("TextBox", customSection)
animIdInput.Size = UDim2.new(1, -80, 0, 30)
animIdInput.Position = UDim2.new(0, 10, 0, 28)
animIdInput.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
animIdInput.Text = ""
animIdInput.PlaceholderText = "rbxassetid://123456789"
animIdInput.Font = Enum.Font.GothamMedium
animIdInput.TextSize = 11
animIdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
animIdInput.PlaceholderColor3 = Color3.fromRGB(80, 85, 100)
animIdInput.BorderSizePixel = 0
animIdInput.ClearTextOnFocus = false
animIdInput.ZIndex = 5
Instance.new("UICorner", animIdInput).CornerRadius = UDim.new(0, 8)
Instance.new("UIPadding", animIdInput).PaddingLeft = UDim.new(0, 8)

local playCustomBtn = Instance.new("TextButton", customSection)
playCustomBtn.Size = UDim2.new(0, 56, 0, 30)
playCustomBtn.Position = UDim2.new(1, -66, 0, 28)
playCustomBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 170)
playCustomBtn.Text = "▶ Play"
playCustomBtn.Font = Enum.Font.GothamBold
playCustomBtn.TextSize = 10
playCustomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playCustomBtn.BorderSizePixel = 0
playCustomBtn.AutoButtonColor = false
playCustomBtn.ZIndex = 5
Instance.new("UICorner", playCustomBtn).CornerRadius = UDim.new(0, 8)

-- STATUS
local statusSection = Instance.new("Frame", leftPanel)
statusSection.Size = UDim2.new(1, -16, 0, 80)
statusSection.Position = UDim2.new(0, 8, 0, 402)
statusSection.BackgroundColor3 = Color3.fromRGB(14, 16, 26)
statusSection.BorderSizePixel = 0
statusSection.ZIndex = 4
Instance.new("UICorner", statusSection).CornerRadius = UDim.new(0, 10)

local statusLabel = Instance.new("TextLabel", statusSection)
statusLabel.Size = UDim2.new(1, -16, 0, 18)
statusLabel.Position = UDim2.new(0, 10, 0, 6)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "✅ Siap digunakan"
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 11
statusLabel.TextColor3 = Color3.fromRGB(40, 200, 100)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 5

local tips = {"🔗 Copy Emote = ikuti emote player", "🔒 Lock = animasi tetap saat jalan", "⚡ Atur kecepatan animasi", "🔍 Cari dance di search box"}
for i, tip in ipairs(tips) do
    local tipLabel = Instance.new("TextLabel", statusSection)
    tipLabel.Size = UDim2.new(1, -22, 0, 13)
    tipLabel.Position = UDim2.new(0, 14, 0, 18 + (i * 13))
    tipLabel.BackgroundTransparency = 1
    tipLabel.Text = "› " .. tip
    tipLabel.Font = Enum.Font.Gotham
    tipLabel.TextSize = 9
    tipLabel.TextColor3 = CurrentTheme.textMuted
    tipLabel.TextXAlignment = Enum.TextXAlignment.Left
    tipLabel.ZIndex = 4
    table.insert(ThemeElements, {obj = tipLabel, prop = "TextColor3", themeKey = "textMuted"})
end

-- ============================================================
-- CENTER PANEL - ANIMATION LIST + SEARCH
-- ============================================================
local centerPanel = Instance.new("Frame", frame)
centerPanel.Name = "CenterPanel"
centerPanel.Size = UDim2.new(0, 300, 1, -64)
centerPanel.Position = UDim2.new(0, 278, 0, 58)
centerPanel.BackgroundTransparency = 1
centerPanel.BorderSizePixel = 0
centerPanel.ZIndex = 3

local animHeader = Instance.new("Frame", centerPanel)
animHeader.Size = UDim2.new(1, -4, 0, 32)
animHeader.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
animHeader.BackgroundTransparency = 0.15
animHeader.BorderSizePixel = 0
animHeader.ZIndex = 4
Instance.new("UICorner", animHeader).CornerRadius = UDim.new(0, 10)

local animHeaderLabel = Instance.new("TextLabel", animHeader)
animHeaderLabel.Size = UDim2.new(1, -12, 1, 0)
animHeaderLabel.Position = UDim2.new(0, 12, 0, 0)
animHeaderLabel.BackgroundTransparency = 1
animHeaderLabel.Text = "🎭 DAFTAR ANIMASI (" .. #AnimationList .. ")"
animHeaderLabel.Font = Enum.Font.GothamBlack
animHeaderLabel.TextSize = 10
animHeaderLabel.TextColor3 = CurrentTheme.textMuted
animHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
animHeaderLabel.ZIndex = 5
table.insert(ThemeElements, {obj = animHeaderLabel, prop = "TextColor3", themeKey = "textMuted"})

-- SEARCH BOX
local searchBox = Instance.new("TextBox", centerPanel)
searchBox.Size = UDim2.new(1, -4, 0, 28)
searchBox.Position = UDim2.new(0, 0, 0, 36)
searchBox.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
searchBox.Text = ""
searchBox.PlaceholderText = "🔍 Cari dance / emote..."
searchBox.Font = Enum.Font.GothamMedium
searchBox.TextSize = 11
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderColor3 = Color3.fromRGB(80, 90, 110)
searchBox.BorderSizePixel = 0
searchBox.ClearTextOnFocus = false
searchBox.ZIndex = 5
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)
Instance.new("UIPadding", searchBox).PaddingLeft = UDim.new(0, 10)
local searchStroke = Instance.new("UIStroke", searchBox)
searchStroke.Color = Color3.fromRGB(40, 50, 70)

-- CATEGORY FILTER
local filterFrame = Instance.new("Frame", centerPanel)
filterFrame.Size = UDim2.new(1, -4, 0, 24)
filterFrame.Position = UDim2.new(0, 0, 0, 68)
filterFrame.BackgroundTransparency = 1
filterFrame.ZIndex = 4

local categories = {"All", "Viral", "Dance", "Emote", "Walk", "Run"}
local selectedCategory = "All"
local categoryBtns = {}
local catW = math.floor(296 / #categories) - 3

for i, cat in ipairs(categories) do
    local catBtn = Instance.new("TextButton", filterFrame)
    catBtn.Size = UDim2.new(0, catW, 0, 22)
    catBtn.Position = UDim2.new(0, (i - 1) * (catW + 3), 0, 0)
    catBtn.BackgroundColor3 = (cat == "All") and CurrentTheme.accent or Color3.fromRGB(24, 26, 38)
    catBtn.BackgroundTransparency = (cat == "All") and 0.3 or 0
    catBtn.Text = cat
    catBtn.Font = Enum.Font.GothamBold
    catBtn.TextSize = 9
    catBtn.TextColor3 = (cat == "All") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 135, 155)
    catBtn.BorderSizePixel = 0
    catBtn.AutoButtonColor = false
    catBtn.ZIndex = 5
    Instance.new("UICorner", catBtn).CornerRadius = UDim.new(0, 6)
    categoryBtns[cat] = catBtn
    catBtn.MouseButton1Click:Connect(function()
        selectedCategory = cat
        for cN, cB in pairs(categoryBtns) do
            local a = cN == cat
            Tween(cB, {BackgroundColor3 = a and CurrentTheme.accent or Color3.fromRGB(24, 26, 38), BackgroundTransparency = a and 0.3 or 0, TextColor3 = a and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 135, 155)}, 0.2)
        end
        RefreshAnimationList()
    end)
end

local animScroll = Instance.new("ScrollingFrame", centerPanel)
animScroll.Size = UDim2.new(1, -2, 1, -98)
animScroll.Position = UDim2.new(0, 0, 0, 96)
animScroll.BackgroundTransparency = 1
animScroll.ScrollBarThickness = 4
animScroll.ScrollBarImageColor3 = CurrentTheme.scrollBar
animScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
animScroll.BorderSizePixel = 0
animScroll.ZIndex = 4
table.insert(ThemeElements, {obj = animScroll, prop = "ScrollBarImageColor3", themeKey = "scrollBar"})

local animScrollLayout = Instance.new("UIListLayout", animScroll)
animScrollLayout.Padding = UDim.new(0, 4)
animScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    animScroll.CanvasSize = UDim2.new(0, 0, 0, animScrollLayout.AbsoluteContentSize.Y + 8)
end)

-- ============================================================
-- PLAY / STOP ANIMATION
-- ============================================================
local function PlayAnimation(animId, animName)
    local ch = player.Character
    if not ch then SendNotification("error", "Error", "Karakter tidak ditemukan!", 2); return end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hum then SendNotification("error", "Error", "Humanoid tidak ditemukan!", 2); return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then animator = Instance.new("Animator", hum) end

    for _, tr in pairs(ActiveAnimations) do if tr and tr.IsPlaying then tr:Stop(0.3) end end
    ActiveAnimations = {}
    if LockedAnimationTrack then LockedAnimationTrack:Stop(0.3); LockedAnimationTrack = nil; LockedAnimationId = nil end

    local animation = Instance.new("Animation")
    animation.AnimationId = animId
    local ok, track = pcall(function() return animator:LoadAnimation(animation) end)
    if ok and track then
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play()
        track:AdjustSpeed(AnimationSpeed)
        CurrentAnimationId = animId
        CurrentAnimationName = animName or "Custom"
        ActiveAnimations[animId] = track
        if LockAnimationEnabled then
            LockedAnimationTrack = track
            LockedAnimationId = animId
            LockedAnimationName = animName
        end
        statusLabel.Text = "▶ " .. (animName or animId)
        statusLabel.TextColor3 = Color3.fromRGB(0, 210, 210)
        SendNotification("anim", "Animasi Diputar 🎭", animName or "Custom", 2.5)
    else
        SendNotification("error", "Gagal", "Animation ID tidak valid.", 3)
    end
end

local function StopAllAnimations()
    for _, tr in pairs(ActiveAnimations) do if tr and tr.IsPlaying then tr:Stop(0.3) end end
    ActiveAnimations = {}
    if LockedAnimationTrack then LockedAnimationTrack:Stop(0.3) end
    LockedAnimationTrack = nil; LockedAnimationId = nil; LockedAnimationName = nil
    CurrentAnimationId = ""; CurrentAnimationName = ""
    statusLabel.Text = "⏹ Dihentikan"
    statusLabel.TextColor3 = Color3.fromRGB(230, 55, 65)
    SendNotification("info", "Dihentikan ⏹", "Semua animasi dihentikan.", 2)
end

-- REFRESH ANIMATION LIST WITH SEARCH + CATEGORY
local catColors = {Viral = Color3.fromRGB(255, 60, 100), Dance = Color3.fromRGB(0, 180, 220), Emote = Color3.fromRGB(180, 120, 255), Walk = Color3.fromRGB(40, 200, 100), Run = Color3.fromRGB(255, 180, 40)}

RefreshAnimationList = function()
    for _, child in ipairs(animScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local query = SearchQuery:lower()
    local visIdx = 0
    for idx, anim in ipairs(AnimationList) do
        local passCat = (selectedCategory == "All") or (anim.category == selectedCategory)
        local passSearch = (query == "") or anim.name:lower():find(query, 1, true) or anim.category:lower():find(query, 1, true)
        if passCat and passSearch then
            visIdx = visIdx + 1
            local li = visIdx
            local btn = Instance.new("TextButton", animScroll)
            btn.Size = UDim2.new(1, -6, 0, 38)
            btn.Text = ""
            btn.BackgroundColor3 = (li % 2 == 0) and CurrentTheme.cardBgAlt or CurrentTheme.cardBg
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.ZIndex = 5
            btn.LayoutOrder = li
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            local bStroke = Instance.new("UIStroke", btn)
            bStroke.Color = CurrentTheme.stroke
            bStroke.Thickness = 1
            bStroke.Transparency = 0.5

            local nLabel = Instance.new("TextLabel", btn)
            nLabel.Size = UDim2.new(1, -80, 1, 0)
            nLabel.Position = UDim2.new(0, 14, 0, 0)
            nLabel.BackgroundTransparency = 1
            nLabel.Text = anim.name
            nLabel.Font = Enum.Font.GothamBold
            nLabel.TextSize = 12
            nLabel.TextColor3 = CurrentTheme.textPrimary
            nLabel.TextXAlignment = Enum.TextXAlignment.Left
            nLabel.ZIndex = 6

            local badge = Instance.new("TextLabel", btn)
            badge.Size = UDim2.new(0, 50, 0, 20)
            badge.Position = UDim2.new(1, -58, 0.5, -10)
            badge.BackgroundColor3 = catColors[anim.category] or CurrentTheme.accent
            badge.BackgroundTransparency = 0.68
            badge.Text = anim.category
            badge.Font = Enum.Font.GothamBold
            badge.TextSize = 8
            badge.TextColor3 = Color3.fromRGB(255, 255, 255)
            badge.BorderSizePixel = 0
            badge.ZIndex = 6
            Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)

            btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = CurrentTheme.cardHover}, 0.12) end)
            btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = (li % 2 == 0) and CurrentTheme.cardBgAlt or CurrentTheme.cardBg}, 0.12) end)
            btn.MouseButton1Click:Connect(function() PlayAnimation(anim.id, anim.name) end)
        end
    end
    if visIdx == 0 then
        local nr = Instance.new("TextButton", animScroll)
        nr.Size = UDim2.new(1, -6, 0, 50)
        nr.Text = "😔 Tidak ditemukan"
        nr.BackgroundColor3 = CurrentTheme.cardBg
        nr.Font = Enum.Font.GothamMedium
        nr.TextSize = 12
        nr.TextColor3 = CurrentTheme.textMuted
        nr.BorderSizePixel = 0
        nr.AutoButtonColor = false
        nr.ZIndex = 5
        nr.LayoutOrder = 1
        Instance.new("UICorner", nr).CornerRadius = UDim.new(0, 8)
    end
    local stopBtn = Instance.new("TextButton", animScroll)
    stopBtn.Size = UDim2.new(1, -6, 0, 38)
    stopBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    stopBtn.Text = "⏹ STOP SEMUA"
    stopBtn.Font = Enum.Font.GothamBlack
    stopBtn.TextSize = 12
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.BorderSizePixel = 0
    stopBtn.AutoButtonColor = false
    stopBtn.ZIndex = 5
    stopBtn.LayoutOrder = 9999
    Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)
    stopBtn.MouseButton1Click:Connect(StopAllAnimations)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    SearchQuery = searchBox.Text
    RefreshAnimationList()
end)

RefreshAnimationList()

playCustomBtn.MouseButton1Click:Connect(function()
    local id = animIdInput.Text
    if id == "" then SendNotification("warning", "Kosong", "Masukkan Animation ID.", 2); return end
    if not id:find("rbxassetid://") then id = "rbxassetid://" .. id end
    PlayAnimation(id, "Custom")
end)

-- ============================================================
-- RIGHT PANEL - PLAYER LIST
-- ============================================================
local rightPanel = Instance.new("Frame", frame)
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(0, 220, 1, -64)
rightPanel.Position = UDim2.new(1, -228, 0, 58)
rightPanel.BackgroundColor3 = CurrentTheme.panelBg
rightPanel.BackgroundTransparency = 0.1
rightPanel.BorderSizePixel = 0
rightPanel.ZIndex = 3
Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", rightPanel).Color = Color3.fromRGB(30, 34, 46)
table.insert(ThemeElements, {obj = rightPanel, prop = "BackgroundColor3", themeKey = "panelBg"})

local playerHeader = Instance.new("Frame", rightPanel)
playerHeader.Size = UDim2.new(1, -16, 0, 32)
playerHeader.Position = UDim2.new(0, 8, 0, 8)
playerHeader.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
playerHeader.BackgroundTransparency = 0.15
playerHeader.BorderSizePixel = 0
playerHeader.ZIndex = 4
Instance.new("UICorner", playerHeader).CornerRadius = UDim.new(0, 10)

local playerHeaderLabel = Instance.new("TextLabel", playerHeader)
playerHeaderLabel.Size = UDim2.new(1, -12, 1, 0)
playerHeaderLabel.Position = UDim2.new(0, 12, 0, 0)
playerHeaderLabel.BackgroundTransparency = 1
playerHeaderLabel.Text = "👥 DAFTAR PEMAIN"
playerHeaderLabel.Font = Enum.Font.GothamBlack
playerHeaderLabel.TextSize = 10
playerHeaderLabel.TextColor3 = CurrentTheme.textMuted
playerHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
playerHeaderLabel.ZIndex = 5
table.insert(ThemeElements, {obj = playerHeaderLabel, prop = "TextColor3", themeKey = "textMuted"})

local selectedPlayerLabel = Instance.new("TextLabel", rightPanel)
selectedPlayerLabel.Size = UDim2.new(1, -16, 0, 20)
selectedPlayerLabel.Position = UDim2.new(0, 8, 0, 44)
selectedPlayerLabel.BackgroundTransparency = 1
selectedPlayerLabel.Text = "Dipilih: Tidak ada"
selectedPlayerLabel.Font = Enum.Font.GothamMedium
selectedPlayerLabel.TextSize = 10
selectedPlayerLabel.TextColor3 = CurrentTheme.textSecondary
selectedPlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
selectedPlayerLabel.ZIndex = 4
table.insert(ThemeElements, {obj = selectedPlayerLabel, prop = "TextColor3", themeKey = "textSecondary"})

-- COPY EMOTE BUTTON
local copyEmoteBtn = Instance.new("TextButton", rightPanel)
copyEmoteBtn.Size = UDim2.new(1, -16, 0, 28)
copyEmoteBtn.Position = UDim2.new(0, 8, 0, 66)
copyEmoteBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 140)
copyEmoteBtn.Text = "🔗 Copy Emote Sekarang"
copyEmoteBtn.Font = Enum.Font.GothamBold
copyEmoteBtn.TextSize = 10
copyEmoteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyEmoteBtn.BorderSizePixel = 0
copyEmoteBtn.AutoButtonColor = false
copyEmoteBtn.ZIndex = 5
Instance.new("UICorner", copyEmoteBtn).CornerRadius = UDim.new(0, 8)

copyEmoteBtn.MouseButton1Click:Connect(function()
    if not SelectedPlayer then SendNotification("warning", "Pilih Player", "Pilih player dulu!", 2); return end
    local tp = Players:FindFirstChild(SelectedPlayer)
    if not tp or not tp.Character then SendNotification("error", "Error", "Player tidak ditemukan!", 2); return end
    local th = tp.Character:FindFirstChildOfClass("Humanoid")
    if not th then return end
    local ta = th:FindFirstChildOfClass("Animator")
    if not ta then return end
    local tracks = ta:GetPlayingAnimationTracks()
    local best, bestP = nil, -1
    for _, t in ipairs(tracks) do
        local pn = 0
        local p = t.Priority
        if p == Enum.AnimationPriority.Action4 then pn = 6
        elseif p == Enum.AnimationPriority.Action3 then pn = 5
        elseif p == Enum.AnimationPriority.Action2 then pn = 4
        elseif p == Enum.AnimationPriority.Action then pn = 3 end
        if pn > bestP and t.IsPlaying then bestP = pn; best = t end
    end
    if best and best.Animation then
        local aid = best.Animation.AnimationId
        if aid and aid ~= "" then
            PlayAnimation(aid, "Copied: " .. SelectedPlayer)
            SendNotification("sync", "Emote Di-copy! 🔗", "Mengikuti emote " .. SelectedPlayer, 2.5)
        else
            SendNotification("warning", "Tidak Ada", SelectedPlayer .. " tidak emote.", 2)
        end
    else
        SendNotification("warning", "Tidak Ada", SelectedPlayer .. " tidak emote.", 2)
    end
end)

local playerScroll = Instance.new("ScrollingFrame", rightPanel)
playerScroll.Size = UDim2.new(1, -16, 1, -104)
playerScroll.Position = UDim2.new(0, 8, 0, 98)
playerScroll.BackgroundTransparency = 1
playerScroll.ScrollBarThickness = 3
playerScroll.ScrollBarImageColor3 = CurrentTheme.scrollBar
playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerScroll.BorderSizePixel = 0
playerScroll.ZIndex = 4
table.insert(ThemeElements, {obj = playerScroll, prop = "ScrollBarImageColor3", themeKey = "scrollBar"})

local playerScrollLayout = Instance.new("UIListLayout", playerScroll)
playerScrollLayout.Padding = UDim.new(0, 4)
playerScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerScrollLayout.AbsoluteContentSize.Y + 8)
end)

local playerButtons = {}
UpdatePlayerList = function()
    for _, b in ipairs(playerButtons) do if b and b.Parent then b:Destroy() end end
    playerButtons = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton", playerScroll)
        btn.Size = UDim2.new(1, -4, 0, 40)
        btn.Text = ""
        btn.BackgroundColor3 = (plr.Name == SelectedPlayer) and Color3.fromRGB(0, 40, 38) or CurrentTheme.cardBg
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local bStroke = Instance.new("UIStroke", btn)
        bStroke.Color = (plr.Name == SelectedPlayer) and Color3.fromRGB(0, 180, 170) or CurrentTheme.stroke
        bStroke.Thickness = (plr.Name == SelectedPlayer) and 2 or 1

        pcall(function()
            local thumb = Instance.new("ImageLabel", btn)
            thumb.Size = UDim2.new(0, 28, 0, 28)
            thumb.Position = UDim2.new(0, 6, 0.5, -14)
            thumb.BackgroundTransparency = 1
            thumb.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            thumb.ZIndex = 7
            Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
        end)

        local nL = Instance.new("TextLabel", btn)
        nL.Size = UDim2.new(1, -80, 0, 16)
        nL.Position = UDim2.new(0, 40, 0, 4)
        nL.BackgroundTransparency = 1
        nL.Text = plr.DisplayName
        nL.Font = Enum.Font.GothamBold
        nL.TextSize = 11
        nL.TextColor3 = CurrentTheme.textPrimary
        nL.TextXAlignment = Enum.TextXAlignment.Left
        nL.TextTruncate = Enum.TextTruncate.AtEnd
        nL.ZIndex = 6

        local uL = Instance.new("TextLabel", btn)
        uL.Size = UDim2.new(1, -80, 0, 12)
        uL.Position = UDim2.new(0, 40, 0, 22)
        uL.BackgroundTransparency = 1
        uL.Text = "@" .. plr.Name
        uL.Font = Enum.Font.Gotham
        uL.TextSize = 9
        uL.TextColor3 = CurrentTheme.textMuted
        uL.TextXAlignment = Enum.TextXAlignment.Left
        uL.ZIndex = 6

        if plr == player then
            local yB = Instance.new("TextLabel", btn)
            yB.Size = UDim2.new(0, 30, 0, 16)
            yB.Position = UDim2.new(1, -38, 0.5, -8)
            yB.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
            yB.BackgroundTransparency = 0.6
            yB.Text = "YOU"
            yB.Font = Enum.Font.GothamBold
            yB.TextSize = 8
            yB.TextColor3 = Color3.fromRGB(255, 255, 255)
            yB.BorderSizePixel = 0
            yB.ZIndex = 6
            Instance.new("UICorner", yB).CornerRadius = UDim.new(0, 5)
        end

        if plr.Name == SelectedPlayer then
            local sI = Instance.new("TextLabel", btn)
            sI.Size = UDim2.new(0, 16, 0, 16)
            sI.Position = UDim2.new(1, -22, 0.5, -8)
            sI.BackgroundTransparency = 1
            sI.Text = "✓"
            sI.Font = Enum.Font.GothamBold
            sI.TextSize = 14
            sI.TextColor3 = Color3.fromRGB(0, 210, 210)
            sI.ZIndex = 6
        end

        btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = CurrentTheme.cardHover}, 0.12) end)
        btn.MouseLeave:Connect(function()
            local sel = plr.Name == SelectedPlayer
            Tween(btn, {BackgroundColor3 = sel and Color3.fromRGB(0, 40, 38) or CurrentTheme.cardBg}, 0.12)
        end)
        btn.MouseButton1Click:Connect(function()
            if SelectedPlayer == plr.Name then
                SelectedPlayer = nil
                selectedPlayerLabel.Text = "Dipilih: Tidak ada"
            else
                SelectedPlayer = plr.Name
                selectedPlayerLabel.Text = "Dipilih: " .. plr.DisplayName
                SendNotification("player", "Dipilih 👤", plr.DisplayName, 2.5)
                if SyncEnabled then syncLabel.Text = "ON — Copying " .. plr.Name; StartSyncFromPlayer() end
            end
            UpdatePlayerList()
        end)
        table.insert(playerButtons, btn)
    end
end

UpdatePlayerList()
Players.PlayerAdded:Connect(function() task.wait(0.5); UpdatePlayerList() end)
Players.PlayerRemoving:Connect(function(plr)
    if SelectedPlayer == plr.Name then SelectedPlayer = nil; selectedPlayerLabel.Text = "Dipilih: Tidak ada" end
    task.wait(0.5); UpdatePlayerList()
end)

-- ============================================================
-- LOCK HEARTBEAT
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not ScriptActive or not LockAnimationEnabled or not LockedAnimationTrack or not LockedAnimationId then return end
    local ch = player.Character
    if not ch then return end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local anim = hum:FindFirstChildOfClass("Animator")
    if not anim then return end
    if not LockedAnimationTrack.IsPlaying then
        local a = Instance.new("Animation")
        a.AnimationId = LockedAnimationId
        local ok, t = pcall(function() return anim:LoadAnimation(a) end)
        if ok and t then
            t.Priority = Enum.AnimationPriority.Action4; t.Looped = true; t:Play(); t:AdjustSpeed(AnimationSpeed)
            LockedAnimationTrack = t; ActiveAnimations[LockedAnimationId] = t
        end
    end
    if LockedAnimationTrack and LockedAnimationTrack.IsPlaying then
        for _, at in ipairs(anim:GetPlayingAnimationTracks()) do
            if at ~= LockedAnimationTrack then
                local p = at.Priority
                if p == Enum.AnimationPriority.Core or p == Enum.AnimationPriority.Idle or p == Enum.AnimationPriority.Movement then
                    at:Stop(0)
                end
            end
        end
    end
end)

-- ============================================================
-- EMOTE SPEED OVERRIDE
-- ============================================================
local function SetupEmoteOverride()
    local ch = player.Character or player.CharacterAdded:Wait()
    local hum = ch:WaitForChild("Humanoid")
    local anim = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 5)
    if not anim then return end
    anim.AnimationPlayed:Connect(function(track)
        task.wait(0.05)
        if track ~= LockedAnimationTrack then
            if track.Priority == Enum.AnimationPriority.Action or track.Priority == Enum.AnimationPriority.Action2 then
                track:AdjustSpeed(EmoteSpeed)
            end
        end
    end)
end

task.spawn(function()
    SetupEmoteOverride()
    player.CharacterAdded:Connect(function()
        task.wait(1); SetupEmoteOverride()
        if LockAnimationEnabled and LockedAnimationId and LockedAnimationId ~= "" then
            task.wait(0.5)
            local ch = player.Character
            if ch then
                local hum = ch:FindFirstChildOfClass("Humanoid")
                if hum then
                    local anim = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
                    local a = Instance.new("Animation"); a.AnimationId = LockedAnimationId
                    local ok, t = pcall(function() return anim:LoadAnimation(a) end)
                    if ok and t then
                        t.Priority = Enum.AnimationPriority.Action4; t.Looped = true; t:Play(); t:AdjustSpeed(AnimationSpeed)
                        LockedAnimationTrack = t; ActiveAnimations[LockedAnimationId] = t
                    end
                end
            end
        end
    end)
end)

-- ============================================================
-- KEYBOARD SHORTCUT
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if frame.Visible then
            Tween(frame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            Tween(shadow, {ImageTransparency = 1}, 0.3)
            task.wait(0.45); frame.Visible = false
        else
            frame.Visible = true; frame.Size = UDim2.new(0, 0, 0, 0); frame.Position = UDim2.new(0.5, 0, 0.5, 0)
            TweenBounce(frame, {Size = OriginalSize, Position = UDim2.new(0.5, -410, 0.5, -260)}, 0.5)
            Tween(shadow, {ImageTransparency = 0.5}, 0.4)
        end
    end
end)

-- ============================================================
-- ACCENT LINE BREATHING
-- ============================================================
task.spawn(function()
    while accentLine and accentLine.Parent do
        TweenWait(accentLine, {BackgroundTransparency = 0.4}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenWait(accentLine, {BackgroundTransparency = 0}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    end
end)

-- ============================================================
-- LOADING SCREEN
-- ============================================================
local loadScreen = Instance.new("Frame", gui)
loadScreen.Name = "LoadingScreen"
loadScreen.Size = UDim2.new(1, 0, 1, 0)
loadScreen.BackgroundColor3 = Color3.fromRGB(6, 8, 16)
loadScreen.BorderSizePixel = 0
loadScreen.ZIndex = 100

local loadCenter = Instance.new("Frame", loadScreen)
loadCenter.Size = UDim2.new(0, 400, 0, 200)
loadCenter.Position = UDim2.new(0.5, -200, 0.5, -100)
loadCenter.BackgroundTransparency = 1
loadCenter.ZIndex = 102

local loadTitle = Instance.new("TextLabel", loadCenter)
loadTitle.Size = UDim2.new(1, 0, 0, 40)
loadTitle.Position = UDim2.new(0, 0, 0, 40)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "Animation Menu"
loadTitle.Font = Enum.Font.GothamBlack
loadTitle.TextSize = 32
loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadTitle.TextTransparency = 1
loadTitle.ZIndex = 103

local loadSub = Instance.new("TextLabel", loadCenter)
loadSub.Size = UDim2.new(1, 0, 0, 20)
loadSub.Position = UDim2.new(0, 0, 0, 80)
loadSub.BackgroundTransparency = 1
loadSub.Text = "by.Sobing4413 • Search • v1 ✨"
loadSub.Font = Enum.Font.GothamMedium
loadSub.TextSize = 14
loadSub.TextColor3 = Color3.fromRGB(0, 210, 210)
loadSub.TextTransparency = 1
loadSub.ZIndex = 103

local loadBarBg = Instance.new("Frame", loadCenter)
loadBarBg.Size = UDim2.new(0, 260, 0, 6)
loadBarBg.Position = UDim2.new(0.5, -130, 0, 120)
loadBarBg.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
loadBarBg.BackgroundTransparency = 1
loadBarBg.BorderSizePixel = 0
loadBarBg.ZIndex = 103
Instance.new("UICorner", loadBarBg).CornerRadius = UDim.new(1, 0)

local loadBar = Instance.new("Frame", loadBarBg)
loadBar.Size = UDim2.new(0, 0, 1, 0)
loadBar.BackgroundColor3 = Color3.fromRGB(0, 210, 210)
loadBar.BackgroundTransparency = 1
loadBar.BorderSizePixel = 0
loadBar.ZIndex = 104
Instance.new("UICorner", loadBar).CornerRadius = UDim.new(1, 0)

local loadStatus = Instance.new("TextLabel", loadCenter)
loadStatus.Size = UDim2.new(1, 0, 0, 16)
loadStatus.Position = UDim2.new(0, 0, 0, 140)
loadStatus.BackgroundTransparency = 1
loadStatus.Text = "Memuat..."
loadStatus.Font = Enum.Font.Gotham
loadStatus.TextSize = 11
loadStatus.TextColor3 = Color3.fromRGB(100, 140, 180)
loadStatus.TextTransparency = 1
loadStatus.ZIndex = 103

task.spawn(function()
    task.wait(0.3)
    Tween(loadTitle, {TextTransparency = 0}, 0.5)
    task.wait(0.15)
    Tween(loadSub, {TextTransparency = 0}, 0.5)
    task.wait(0.2)
    Tween(loadBarBg, {BackgroundTransparency = 0}, 0.3)
    Tween(loadBar, {BackgroundTransparency = 0}, 0.3)
    Tween(loadStatus, {TextTransparency = 0}, 0.3)

    loadStatus.Text = "Memuat animasi..."
    Tween(loadBar, {Size = UDim2.new(0.3, 0, 1, 0)}, 0.5)
    task.wait(0.6)
    loadStatus.Text = "Memuat daftar pemain..."
    Tween(loadBar, {Size = UDim2.new(0.6, 0, 1, 0)}, 0.5)
    task.wait(0.6)
    loadStatus.Text = "Menyiapkan GUI..."
    Tween(loadBar, {Size = UDim2.new(0.9, 0, 1, 0)}, 0.4)
    task.wait(0.5)
    loadStatus.Text = "Selesai! ✨"
    Tween(loadBar, {Size = UDim2.new(1, 0, 1, 0)}, 0.3)
    task.wait(0.5)

    Tween(loadTitle, {TextTransparency = 1}, 0.3)
    Tween(loadSub, {TextTransparency = 1}, 0.3)
    Tween(loadBarBg, {BackgroundTransparency = 1}, 0.3)
    Tween(loadBar, {BackgroundTransparency = 1}, 0.3)
    Tween(loadStatus, {TextTransparency = 1}, 0.3)
    task.wait(0.4)
    Tween(loadScreen, {BackgroundTransparency = 1}, 0.5)
    task.wait(0.6)
    loadScreen:Destroy()

    frame.Visible = true
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.ImageTransparency = 1
    TweenBounce(frame, {Size = OriginalSize, Position = UDim2.new(0.5, -410, 0.5, -260)}, 0.6)
    Tween(shadow, {ImageTransparency = 0.5}, 0.5)
    task.wait(0.7)
    SendNotification("success", "Script Dimuat! ✨", "Animation Menu v1 siap!", 4)
end)

-- ============================================================
-- CLEANUP
-- ============================================================
gui.Destroying:Connect(function()
    ScriptActive = false
    if syncConnection then syncConnection:Disconnect() end
    for _, tr in pairs(ActiveAnimations) do if tr and tr.IsPlaying then tr:Stop() end end
    if LockedAnimationTrack and LockedAnimationTrack.IsPlaying then LockedAnimationTrack:Stop() end
end)