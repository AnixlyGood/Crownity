--// Anixly UI Library
--// Version: 1.0.0
--// Premium Dashboard Edition

local AnixlyUI = {}
AnixlyUI.__index = AnixlyUI
AnixlyUI.Version = "1.0.0"

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local function getParent()
    local ok, core = pcall(function()
        return game:GetService("CoreGui")
    end)

    if ok and core then
        return core
    end

    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function tween(obj, props, time, style, direction)
    local info = TweenInfo.new(
        time or 0.22,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(0, 180, 255)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.35
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function gradient(obj, colors, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(colors)
    g.Rotation = rotation or 45
    g.Parent = obj
    return g
end

local function padding(obj, l, r, t, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l or 0)
    p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.Parent = obj
    return p
end

local function makeText(parent, props)
    local label = Instance.new(props.ClassName or "TextLabel")
    label.BackgroundTransparency = props.BackgroundTransparency == nil and 1 or props.BackgroundTransparency
    label.Text = props.Text or ""
    label.TextColor3 = props.TextColor3 or Color3.fromRGB(235, 245, 255)
    label.Font = props.Font or Enum.Font.Gotham
    label.TextSize = props.TextSize or 13
    label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    label.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
    label.TextWrapped = props.TextWrapped or false
    label.Size = props.Size or UDim2.new(1, 0, 1, 0)
    label.Position = props.Position or UDim2.new()
    label.ZIndex = props.ZIndex or parent.ZIndex
    label.Parent = parent
    return label
end

local THEMES = {
    ANIXLY = {
        name = "Anixly",
        bg = Color3.fromRGB(8, 10, 18),
        bg2 = Color3.fromRGB(13, 17, 30),
        card = Color3.fromRGB(18, 24, 40),
        card2 = Color3.fromRGB(22, 29, 48),
        header = Color3.fromRGB(15, 20, 36),
        sidebar = Color3.fromRGB(10, 13, 25),
        text = Color3.fromRGB(235, 245, 255),
        subtext = Color3.fromRGB(145, 165, 190),
        accent = Color3.fromRGB(0, 210, 255),
        accent2 = Color3.fromRGB(140, 70, 255),
        success = Color3.fromRGB(40, 230, 145),
        danger = Color3.fromRGB(255, 70, 95),
        warning = Color3.fromRGB(255, 195, 60)
    },

    TOKYO_NIGHT = {
        name = "Tokyo Night",
        bg = Color3.fromRGB(9, 9, 24),
        bg2 = Color3.fromRGB(16, 17, 36),
        card = Color3.fromRGB(22, 24, 50),
        card2 = Color3.fromRGB(28, 31, 62),
        header = Color3.fromRGB(18, 19, 46),
        sidebar = Color3.fromRGB(12, 12, 30),
        text = Color3.fromRGB(230, 238, 255),
        subtext = Color3.fromRGB(150, 155, 200),
        accent = Color3.fromRGB(0, 255, 255),
        accent2 = Color3.fromRGB(255, 70, 210),
        success = Color3.fromRGB(80, 250, 123),
        danger = Color3.fromRGB(255, 85, 105),
        warning = Color3.fromRGB(241, 250, 140)
    },

    DRACULA = {
        name = "Dracula",
        bg = Color3.fromRGB(32, 34, 44),
        bg2 = Color3.fromRGB(40, 42, 54),
        card = Color3.fromRGB(50, 52, 66),
        card2 = Color3.fromRGB(58, 61, 78),
        header = Color3.fromRGB(45, 47, 60),
        sidebar = Color3.fromRGB(35, 37, 48),
        text = Color3.fromRGB(248, 248, 242),
        subtext = Color3.fromRGB(180, 185, 205),
        accent = Color3.fromRGB(189, 147, 249),
        accent2 = Color3.fromRGB(255, 121, 198),
        success = Color3.fromRGB(80, 250, 123),
        danger = Color3.fromRGB(255, 85, 85),
        warning = Color3.fromRGB(255, 184, 108)
    },

    BLOOD = {
        name = "Blood Moon",
        bg = Color3.fromRGB(20, 4, 8),
        bg2 = Color3.fromRGB(35, 8, 14),
        card = Color3.fromRGB(50, 12, 20),
        card2 = Color3.fromRGB(65, 16, 26),
        header = Color3.fromRGB(60, 10, 22),
        sidebar = Color3.fromRGB(28, 6, 12),
        text = Color3.fromRGB(255, 230, 235),
        subtext = Color3.fromRGB(210, 135, 150),
        accent = Color3.fromRGB(255, 60, 90),
        accent2 = Color3.fromRGB(255, 170, 55),
        success = Color3.fromRGB(60, 230, 130),
        danger = Color3.fromRGB(255, 40, 60),
        warning = Color3.fromRGB(255, 200, 70)
    },

    FOREST = {
        name = "Forest",
        bg = Color3.fromRGB(5, 18, 12),
        bg2 = Color3.fromRGB(10, 30, 20),
        card = Color3.fromRGB(15, 44, 30),
        card2 = Color3.fromRGB(22, 58, 38),
        header = Color3.fromRGB(10, 42, 28),
        sidebar = Color3.fromRGB(6, 25, 16),
        text = Color3.fromRGB(230, 255, 238),
        subtext = Color3.fromRGB(150, 200, 165),
        accent = Color3.fromRGB(70, 235, 140),
        accent2 = Color3.fromRGB(255, 220, 80),
        success = Color3.fromRGB(70, 235, 140),
        danger = Color3.fromRGB(255, 85, 85),
        warning = Color3.fromRGB(255, 220, 80)
    }
}

AnixlyUI.Themes = THEMES

local DEFAULT_SIZE = IsMobile and Vector2.new(330, 360) or Vector2.new(540, 405)
local SIDEBAR_WIDTH = IsMobile and 90 or 118
local HEADER_HEIGHT = IsMobile and 58 or 64
local COMPONENT_HEIGHT = IsMobile and 38 or 42

function AnixlyUI:CreateTheme(id, data)
    if type(id) ~= "string" or type(data) ~= "table" then
        return nil
    end

    THEMES[id] = data
    return data
end

function AnixlyUI:GetThemes()
    local list = {}
    for id, theme in pairs(THEMES) do
        table.insert(list, id)
    end
    table.sort(list)
    return list
end

function AnixlyUI:ShowNotification(config)
    config = config or {}

    local themeName = config.Theme or "info"
    local colors = {
        info = Color3.fromRGB(0, 190, 255),
        success = Color3.fromRGB(40, 230, 145),
        error = Color3.fromRGB(255, 70, 95),
        warning = Color3.fromRGB(255, 195, 60)
    }

    local icons = {
        info = "i",
        success = "✓",
        error = "×",
        warning = "!"
    }

    local accent = colors[themeName] or colors.info
    local title = config.Title or string.upper(themeName)
    local message = config.Message or "Notification"
    local duration = config.Duration or 3

    local gui = Instance.new("ScreenGui")
    gui.Name = "AnixlyNotification"
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = getParent()

    local holder = Instance.new("Frame")
    holder.AnchorPoint = Vector2.new(1, 1)
    holder.Size = UDim2.new(0, IsMobile and 300 or 360, 0, 82)
    holder.Position = UDim2.new(1, 400, 1, -24)
    holder.BackgroundColor3 = Color3.fromRGB(12, 16, 28)
    holder.BackgroundTransparency = 0.04
    holder.BorderSizePixel = 0
    holder.Parent = gui
    corner(holder, 18)
    stroke(holder, accent, 1.4, 0.2)

    gradient(holder, {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 24, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 11, 20))
    }, 30)

    local icon

    if config.Icon then
        icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 42, 0, 42)
        icon.Position = UDim2.new(0, 14, 0.5, -21)
        icon.BackgroundColor3 = accent
        icon.BackgroundTransparency = 0.18
        icon.Image = config.Icon
        icon.ImageColor3 = Color3.new(1, 1, 1)
        icon.ScaleType = Enum.ScaleType.Crop
        icon.Parent = holder
        corner(icon, 14)
    else
        icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 42, 0, 42)
        icon.Position = UDim2.new(0, 14, 0.5, -21)
        icon.BackgroundColor3 = accent
        icon.BackgroundTransparency = 0.08
        icon.Text = icons[themeName] or "i"
        icon.TextColor3 = Color3.new(1, 1, 1)
        icon.Font = Enum.Font.GothamBlack
        icon.TextSize = 22
        icon.Parent = holder
        corner(icon, 14)
    end

    makeText(holder, {
        Text = title,
        TextColor3 = accent,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        Size = UDim2.new(1, -82, 0, 22),
        Position = UDim2.new(0, 68, 0, 14)
    })

    makeText(holder, {
        Text = message,
        TextColor3 = Color3.fromRGB(220, 230, 245),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextWrapped = true,
        Size = UDim2.new(1, -82, 0, 36),
        Position = UDim2.new(0, 68, 0, 36),
        TextYAlignment = Enum.TextYAlignment.Top
    })

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -26, 0, 3)
    bar.Position = UDim2.new(0, 13, 1, -8)
    bar.BackgroundColor3 = accent
    bar.BorderSizePixel = 0
    bar.Parent = holder
    corner(bar, 999)

    tween(holder, {Position = UDim2.new(1, -24, 1, -24)}, 0.38, Enum.EasingStyle.Back)

    if duration > 0 then
        tween(bar, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)
        task.delay(duration, function()
            if gui.Parent then
                tween(holder, {Position = UDim2.new(1, 400, 1, -24)}, 0.28)
                task.wait(0.3)
                gui:Destroy()
            end
        end)
    end
end

function AnixlyUI:ShowKeySystem(config)
    config = config or {}

    local correctKey = config.Key or "admin123"
    local callback = config.Callback or function() end
    local title = config.Title or "ANIXLY KEY"
    local subtitle = config.Subtitle or "Enter your key to unlock the script"

    local gui = Instance.new("ScreenGui")
    gui.Name = "AnixlyKeySystem"
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = getParent()

    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blur.BackgroundTransparency = 0.35
    blur.Parent = gui

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Size = UDim2.new(0, IsMobile and 330 or 420, 0, 310)
    panel.Position = UDim2.new(0.5, 0, 0.5, 25)
    panel.BackgroundColor3 = Color3.fromRGB(12, 16, 30)
    panel.BackgroundTransparency = 0.03
    panel.BorderSizePixel = 0
    panel.Parent = gui
    corner(panel, 24)
    stroke(panel, Color3.fromRGB(0, 210, 255), 1.5, 0.16)

    gradient(panel, {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 27, 48)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(13, 16, 31)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 17, 48))
    }, 35)

    makeText(panel, {
        Text = "◆",
        TextColor3 = Color3.fromRGB(0, 210, 255),
        Font = Enum.Font.GothamBlack,
        TextSize = 38,
        Size = UDim2.new(1, 0, 0, 46),
        Position = UDim2.new(0, 0, 0, 26),
        TextXAlignment = Enum.TextXAlignment.Center
    })

    makeText(panel, {
        Text = title,
        TextColor3 = Color3.fromRGB(245, 250, 255),
        Font = Enum.Font.GothamBlack,
        TextSize = 24,
        Size = UDim2.new(1, -50, 0, 30),
        Position = UDim2.new(0, 25, 0, 78),
        TextXAlignment = Enum.TextXAlignment.Center
    })

    makeText(panel, {
        Text = subtitle,
        TextColor3 = Color3.fromRGB(145, 165, 195),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextWrapped = true,
        Size = UDim2.new(1, -60, 0, 36),
        Position = UDim2.new(0, 30, 0, 113),
        TextXAlignment = Enum.TextXAlignment.Center
    })

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -54, 0, 48)
    input.Position = UDim2.new(0, 27, 0, 162)
    input.BackgroundColor3 = Color3.fromRGB(8, 12, 24)
    input.TextColor3 = Color3.fromRGB(235, 245, 255)
    input.PlaceholderText = "Paste key here..."
    input.PlaceholderColor3 = Color3.fromRGB(95, 115, 145)
    input.Text = ""
    input.Font = Enum.Font.GothamBold
    input.TextSize = 15
    input.ClearTextOnFocus = false
    input.Parent = panel
    corner(input, 14)
    stroke(input, Color3.fromRGB(0, 210, 255), 1, 0.55)
    padding(input, 14, 14, 0, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -54, 0, 48)
    btn.Position = UDim2.new(0, 27, 0, 224)
    btn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    btn.Text = "VERIFY KEY"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = panel
    corner(btn, 14)
    gradient(btn, {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 70, 255))
    }, 0)

    local status = makeText(panel, {
        Text = "",
        TextColor3 = Color3.fromRGB(255, 80, 100),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Size = UDim2.new(1, -54, 0, 20),
        Position = UDim2.new(0, 27, 1, -28),
        TextXAlignment = Enum.TextXAlignment.Center
    })

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 32, 0, 32)
    close.Position = UDim2.new(1, -44, 0, 12)
    close.BackgroundColor3 = Color3.fromRGB(255, 70, 95)
    close.Text = "×"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.Font = Enum.Font.GothamBlack
    close.TextSize = 18
    close.AutoButtonColor = false
    close.Parent = panel
    corner(close, 10)

    local function deny()
        status.Text = "Invalid key. Try again."
        input.Text = ""

        local old = panel.Position
        for i = 1, 6 do
            tween(panel, {Position = old + UDim2.new(0, (i % 2 == 0 and 9 or -9), 0, 0)}, 0.04)
            task.wait(0.04)
        end
        tween(panel, {Position = old}, 0.1)
    end

    local function verify()
        if input.Text == correctKey then
            status.Text = "Access granted."
            status.TextColor3 = Color3.fromRGB(40, 230, 145)
            tween(panel, {Size = panel.Size + UDim2.new(0, 16, 0, 12)}, 0.2, Enum.EasingStyle.Back)
            task.wait(0.25)
            gui:Destroy()
            callback(true)
            AnixlyUI:ShowNotification({
                Title = "SUCCESS",
                Message = "Welcome to Anixly v" .. AnixlyUI.Version,
                Theme = "success",
                Duration = 2.5
            })
        else
            deny()
        end
    end

    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundTransparency = 0.08}, 0.16)
    end)

    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundTransparency = 0}, 0.16)
    end)

    btn.MouseButton1Click:Connect(verify)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then verify() end
    end)

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
        callback(false)
    end)

    tween(panel, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.35, Enum.EasingStyle.Back)
end

function AnixlyUI:CreateWindow(config)
    config = config or {}

    local window = {}
    window.Title = config.Title or "Anixly Hub"
    window.Subtitle = config.Subtitle or ("Version " .. AnixlyUI.Version)
    window.ThemeId = config.Theme or "ANIXLY"
    window.Theme = THEMES[window.ThemeId] or THEMES.ANIXLY
    window.Width = (config.Size and config.Size.Width) or DEFAULT_SIZE.X
    window.Height = (config.Size and config.Size.Height) or DEFAULT_SIZE.Y
    window.Tabs = {}
    window.TabButtons = {}
    window.ConfigData = {}
    window.MiniIcon = config.MiniIcon or config.Logo or "rbxassetid://2061475061"
    window.Logo = config.Logo or window.MiniIcon

    local theme = window.Theme

    local gui = Instance.new("ScreenGui")
    gui.Name = "AnixlyUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = getParent()

    local glow = Instance.new("Frame")
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Size = UDim2.new(0, window.Width + 10, 0, window.Height + 10)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.BackgroundColor3 = theme.accent
    glow.BackgroundTransparency = 0.72
    glow.BorderSizePixel = 0
    glow.Parent = gui
    corner(glow, 26)

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Size = UDim2.new(0, window.Width, 0, window.Height)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundColor3 = theme.bg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    corner(main, 22)
    local mainStroke = stroke(main, theme.accent, 1.2, 0.25)

    gradient(main, {
        ColorSequenceKeypoint.new(0, theme.bg2),
        ColorSequenceKeypoint.new(0.55, theme.bg),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 13, 35))
    }, 35)

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
    header.BackgroundColor3 = theme.header
    header.BackgroundTransparency = 0.04
    header.BorderSizePixel = 0
    header.Parent = main

    local headerIcon = Instance.new("ImageLabel")
    headerIcon.Name = "HeaderIcon"
    headerIcon.Size = UDim2.new(0, IsMobile and 38 or 42, 0, IsMobile and 38 or 42)
    headerIcon.Position = UDim2.new(0, 14, 0.5, -(IsMobile and 19 or 21))
    headerIcon.BackgroundColor3 = theme.card
    headerIcon.BackgroundTransparency = 0.05
    headerIcon.Image = window.MiniIcon
    headerIcon.ImageColor3 = Color3.new(1, 1, 1)
    headerIcon.ScaleType = Enum.ScaleType.Crop
    headerIcon.Parent = header
    corner(headerIcon, 13)
    stroke(headerIcon, theme.accent, 1, 0.35)

    makeText(header, {
        Text = window.Title,
        TextColor3 = theme.text,
        Font = Enum.Font.GothamBlack,
        TextSize = IsMobile and 13 or 15,
        Size = UDim2.new(1, -215, 0, 25),
        Position = UDim2.new(0, 64, 0, IsMobile and 8 or 10)
    })

    makeText(header, {
        Text = window.Subtitle,
        TextColor3 = theme.subtext,
        Font = Enum.Font.GothamMedium,
        TextSize = IsMobile and 9 or 10,
        Size = UDim2.new(1, -215, 0, 18),
        Position = UDim2.new(0, 64, 0, IsMobile and 30 or 33)
    })

    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 78, 1, 0)
    controls.Position = UDim2.new(1, -88, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = header

    local minimize = Instance.new("TextButton")
    minimize.Size = UDim2.new(0, 28, 0, 28)
    minimize.Position = UDim2.new(0, 6, 0.5, -14)
    minimize.BackgroundColor3 = theme.warning
    minimize.Text = "–"
    minimize.TextColor3 = Color3.fromRGB(40, 30, 0)
    minimize.Font = Enum.Font.GothamBlack
    minimize.TextSize = 18
    minimize.AutoButtonColor = false
    minimize.Parent = controls
    corner(minimize, 999)

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(0, 42, 0.5, -14)
    close.BackgroundColor3 = theme.danger
    close.Text = "×"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.Font = Enum.Font.GothamBlack
    close.TextSize = 18
    close.AutoButtonColor = false
    close.Parent = controls
    corner(close, 999)

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -HEADER_HEIGHT)
    sidebar.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT)
    sidebar.BackgroundColor3 = theme.sidebar
    sidebar.BackgroundTransparency = 0.04
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main

    local sideList = Instance.new("UIListLayout")
    sideList.Padding = UDim.new(0, 7)
    sideList.SortOrder = Enum.SortOrder.LayoutOrder
    sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideList.Parent = sidebar

    padding(sidebar, 8, 8, 10, 10)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -(SIDEBAR_WIDTH + 12), 1, -(HEADER_HEIGHT + 12))
    content.Position = UDim2.new(0, SIDEBAR_WIDTH + 8, 0, HEADER_HEIGHT + 8)
    content.BackgroundTransparency = 1
    content.Parent = main

    local mini = Instance.new("ImageButton")
    mini.Size = UDim2.new(0, IsMobile and 52 or 60, 0, IsMobile and 52 or 60)
    mini.Position = UDim2.new(0, 18, 0.5, -29)
    mini.BackgroundColor3 = theme.header
    mini.Image = window.MiniIcon
    mini.ImageColor3 = Color3.new(1, 1, 1)
    mini.ScaleType = Enum.ScaleType.Crop
    mini.Visible = false
    mini.AutoButtonColor = false
    mini.Parent = gui
    mini.ZIndex = 100
    corner(mini, 18)
    stroke(mini, theme.accent, 1.6, 0.1)

    local resize = Instance.new("TextButton")
    resize.Size = UDim2.new(0, 24, 0, 24)
    resize.Position = UDim2.new(1, -28, 1, -28)
    resize.BackgroundColor3 = theme.card2
    resize.Text = "↘"
    resize.TextColor3 = theme.accent
    resize.Font = Enum.Font.GothamBlack
    resize.TextSize = 14
    resize.AutoButtonColor = false
    resize.Parent = main
    resize.ZIndex = 20
    corner(resize, 8)
    stroke(resize, theme.accent, 1, 0.45)

    local function updateGlow()
        glow.Size = UDim2.new(0, main.Size.X.Offset + 10, 0, main.Size.Y.Offset + 10)
        glow.Position = main.Position
    end

    local dragging, resizing, miniDragging = false, false, false
    local dragStart, posStart, sizeStart, miniStart
    local miniMove = 0

    local dragBtn = Instance.new("TextButton")
    dragBtn.Size = UDim2.new(1, -100, 1, 0)
    dragBtn.BackgroundTransparency = 1
    dragBtn.Text = ""
    dragBtn.Parent = header

    dragBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            posStart = main.Position
        end
    end)

    resize.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            dragStart = input.Position
            sizeStart = main.Size
        end
    end)

    mini.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniDragging = true
            miniMove = 0
            dragStart = input.Position
            miniStart = mini.Position
        end
    end)

    mini.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniDragging = false
            if miniMove <= 10 then
                main.Visible = true
                glow.Visible = true
                mini.Visible = false
            end
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        if dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(posStart.X.Scale, posStart.X.Offset + delta.X, posStart.Y.Scale, posStart.Y.Offset + delta.Y)
            updateGlow()
        elseif resizing then
            local delta = input.Position - dragStart
            local newW = math.clamp(sizeStart.X.Offset + delta.X, IsMobile and 310 or 420, 850)
            local newH = math.clamp(sizeStart.Y.Offset + delta.Y, IsMobile and 320 or 340, 650)
            main.Size = UDim2.new(0, newW, 0, newH)
            updateGlow()
        elseif miniDragging then
            local delta = input.Position - dragStart
            miniMove = delta.Magnitude
            mini.Position = UDim2.new(miniStart.X.Scale, miniStart.X.Offset + delta.X, miniStart.Y.Scale, miniStart.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            resizing = false
        end
    end)

    minimize.MouseButton1Click:Connect(function()
        main.Visible = false
        glow.Visible = false
        mini.Visible = true
    end)

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
        AnixlyUI:ShowNotification({
            Title = "ANIXLY",
            Message = "Window closed.",
            Theme = "info",
            Duration = 2
        })
    end)

    function window:SetTheme(id)
        if not THEMES[id] then
            AnixlyUI:ShowNotification({
                Title = "THEME ERROR",
                Message = "Theme not found: " .. tostring(id),
                Theme = "error",
                Duration = 2.5
            })
            return
        end

        self.ThemeId = id
        self.Theme = THEMES[id]
        theme = self.Theme

        glow.BackgroundColor3 = theme.accent
        main.BackgroundColor3 = theme.bg
        mainStroke.Color = theme.accent
        header.BackgroundColor3 = theme.header
        sidebar.BackgroundColor3 = theme.sidebar
        headerIcon.BackgroundColor3 = theme.card
        mini.BackgroundColor3 = theme.header
        mini.ImageColor3 = Color3.new(1, 1, 1)
        resize.TextColor3 = theme.accent

        AnixlyUI:ShowNotification({
            Title = "THEME",
            Message = "Changed to " .. theme.name,
            Theme = "success",
            Duration = 2
        })
    end

    function window:GetCurrentTheme()
        return self.Theme
    end

    function window:CreateTab(name, icon)
        local tab = {}
        tab.Name = name
        tab.Sections = {}
        tab.CurrentOrder = 1

        local container = Instance.new("ScrollingFrame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = IsMobile and 3 or 4
        container.ScrollBarImageColor3 = theme.accent
        container.AutomaticCanvasSize = Enum.AutomaticSize.Y
        container.CanvasSize = UDim2.new(0, 0, 0, 0)
        container.Visible = false
        container.Parent = content

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container

        padding(container, 4, 8, 4, 12)

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, IsMobile and 48 or 54)
        tabBtn.BackgroundColor3 = theme.bg2
        tabBtn.BackgroundTransparency = 0.03
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.LayoutOrder = #self.Tabs + 1
        tabBtn.Parent = sidebar
        corner(tabBtn, 14)
        local tabStroke = stroke(tabBtn, theme.accent, 1, 0.8)

        local iconLabel = Instance.new("ImageLabel")
        iconLabel.Size = UDim2.new(0, IsMobile and 22 or 25, 0, IsMobile and 22 or 25)
        iconLabel.Position = UDim2.new(0.5, -(IsMobile and 11 or 12), 0, 7)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = icon or ""
        iconLabel.ImageColor3 = Color3.fromRGB(180, 210, 235)
        iconLabel.Parent = tabBtn

        makeText(tabBtn, {
            Text = name,
            TextColor3 = theme.subtext,
            Font = Enum.Font.GothamBold,
            TextSize = IsMobile and 9 or 10,
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 1, -20),
            TextXAlignment = Enum.TextXAlignment.Center
        })

        local buttonData = {
            button = tabBtn,
            stroke = tabStroke,
            icon = iconLabel,
            container = container
        }

        table.insert(self.Tabs, tab)
        table.insert(self.TabButtons, buttonData)

        local function activate()
            for _, data in ipairs(self.TabButtons) do
                data.container.Visible = false
                tween(data.button, {BackgroundColor3 = theme.bg2, BackgroundTransparency = 0.03}, 0.18)
                data.stroke.Transparency = 0.8
                data.icon.ImageColor3 = Color3.fromRGB(180, 210, 235)
                local txt = data.button:FindFirstChildOfClass("TextLabel")
                if txt then txt.TextColor3 = theme.subtext end
            end

            container.Visible = true
            container.Position = UDim2.new(0, 18, 0, 0)
            tween(container, {Position = UDim2.new(0, 0, 0, 0)}, 0.25)
            tween(tabBtn, {BackgroundColor3 = theme.accent, BackgroundTransparency = 0}, 0.18)
            tabStroke.Transparency = 0.1
            iconLabel.ImageColor3 = Color3.new(1, 1, 1)

            local txt = tabBtn:FindFirstChildOfClass("TextLabel")
            if txt then txt.TextColor3 = Color3.new(1, 1, 1) end
        end

        tabBtn.MouseButton1Click:Connect(activate)

        function tab:AddSection(title)
            local section = {}
            section.Title = title
            section.Items = {}
            section.Expanded = true

            local headerFrame = Instance.new("TextButton")
            headerFrame.Size = UDim2.new(1, 0, 0, 40)
            headerFrame.BackgroundColor3 = theme.card2
            headerFrame.BackgroundTransparency = 0.06
            headerFrame.Text = ""
            headerFrame.AutoButtonColor = false
            headerFrame.LayoutOrder = tab.CurrentOrder
            headerFrame.Parent = container
            tab.CurrentOrder += 1
            corner(headerFrame, 13)
            stroke(headerFrame, theme.accent, 1, 0.65)

            makeText(headerFrame, {
                Text = title,
                TextColor3 = theme.text,
                Font = Enum.Font.GothamBlack,
                TextSize = IsMobile and 12 or 13,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 14, 0, 0)
            })

            local arrow = makeText(headerFrame, {
                Text = "⌄",
                TextColor3 = theme.accent,
                Font = Enum.Font.GothamBlack,
                TextSize = 18,
                Size = UDim2.new(0, 30, 1, 0),
                Position = UDim2.new(1, -38, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Center
            })

            headerFrame.MouseButton1Click:Connect(function()
                section.Expanded = not section.Expanded
                arrow.Text = section.Expanded and "⌄" or "›"
                for _, item in ipairs(section.Items) do
                    item.Visible = section.Expanded
                end
            end)

            local function baseComponent(height)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, height or COMPONENT_HEIGHT)
                frame.BackgroundColor3 = theme.card
                frame.BackgroundTransparency = 0.04
                frame.BorderSizePixel = 0
                frame.LayoutOrder = tab.CurrentOrder
                frame.Visible = section.Expanded
                frame.Parent = container
                tab.CurrentOrder += 1
                corner(frame, 12)
                stroke(frame, theme.accent, 1, 0.86)
                table.insert(section.Items, frame)
                return frame
            end

            function section:AddButton(cfg)
                cfg = cfg or {}
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
                btn.BackgroundColor3 = theme.card
                btn.BackgroundTransparency = 0.04
                btn.Text = cfg.Text or "Button"
                btn.TextColor3 = theme.text
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = IsMobile and 12 or 13
                btn.AutoButtonColor = false
                btn.LayoutOrder = tab.CurrentOrder
                btn.Visible = section.Expanded
                btn.Parent = container
                tab.CurrentOrder += 1
                corner(btn, 12)
                stroke(btn, theme.accent, 1, 0.75)
                table.insert(section.Items, btn)

                btn.MouseEnter:Connect(function()
                    tween(btn, {BackgroundColor3 = theme.card2}, 0.14)
                end)

                btn.MouseLeave:Connect(function()
                    tween(btn, {BackgroundColor3 = theme.card}, 0.14)
                end)

                btn.MouseButton1Click:Connect(function()
                    tween(btn, {Size = UDim2.new(1, -6, 0, COMPONENT_HEIGHT)}, 0.07)
                    task.wait(0.07)
                    tween(btn, {Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)}, 0.12)
                    if cfg.Callback then cfg.Callback() end
                end)

                return btn
            end

            function section:AddLabel(text)
                local label = makeText(container, {
                    Text = text or "Label",
                    TextColor3 = theme.subtext,
                    Font = Enum.Font.GothamMedium,
                    TextSize = IsMobile and 11 or 12,
                    Size = UDim2.new(1, 0, 0, 26),
                    TextWrapped = true
                })
                label.LayoutOrder = tab.CurrentOrder
                label.Visible = section.Expanded
                tab.CurrentOrder += 1
                table.insert(section.Items, label)
                return label
            end

            function section:AddToggle(cfg)
                cfg = cfg or {}
                local frame = baseComponent(COMPONENT_HEIGHT)

                makeText(frame, {
                    Text = cfg.Text or "Toggle",
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 12 or 13,
                    Size = UDim2.new(1, -75, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0)
                })

                local state = cfg.Default or false
                local track = Instance.new("Frame")
                track.Size = UDim2.new(0, 48, 0, 24)
                track.Position = UDim2.new(1, -60, 0.5, -12)
                track.BackgroundColor3 = state and theme.success or theme.danger
                track.BorderSizePixel = 0
                track.Parent = frame
                corner(track, 999)

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 18, 0, 18)
                knob.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                knob.BackgroundColor3 = Color3.new(1, 1, 1)
                knob.BorderSizePixel = 0
                knob.Parent = track
                corner(knob, 999)

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.Parent = frame

                local key = "Toggle_" .. tostring(cfg.Text or "Toggle")
                window.ConfigData[key] = state

                local function set(value)
                    state = value
                    window.ConfigData[key] = state
                    tween(track, {BackgroundColor3 = state and theme.success or theme.danger}, 0.18)
                    tween(knob, {Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.18)
                    if cfg.Callback then cfg.Callback(state) end
                end

                btn.MouseButton1Click:Connect(function()
                    set(not state)
                end)

                return {
                    Set = set,
                    Get = function() return state end
                }
            end

            function section:AddDropdown(cfg)
                cfg = cfg or {}
                cfg.Options = cfg.Options or {}

                local frame = baseComponent(COMPONENT_HEIGHT)
                frame.ClipsDescendants = true

                makeText(frame, {
                    Text = cfg.Text or "Dropdown",
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 12 or 13,
                    Size = UDim2.new(1, -125, 0, COMPONENT_HEIGHT),
                    Position = UDim2.new(0, 12, 0, 0)
                })

                local value = cfg.Default or cfg.Options[1] or "-"
                local valueLabel = makeText(frame, {
                    Text = tostring(value),
                    TextColor3 = theme.accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 11 or 12,
                    Size = UDim2.new(0, 105, 0, COMPONENT_HEIGHT),
                    Position = UDim2.new(1, -118, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local key = "Dropdown_" .. tostring(cfg.Text or "Dropdown")
                window.ConfigData[key] = value
                local open = false
                local itemHeight = 30

                local list = Instance.new("Frame")
                list.Size = UDim2.new(1, -18, 0, 0)
                list.Position = UDim2.new(0, 9, 0, COMPONENT_HEIGHT)
                list.BackgroundColor3 = theme.bg2
                list.BorderSizePixel = 0
                list.ClipsDescendants = true
                list.Parent = frame
                corner(list, 10)
                stroke(list, theme.accent, 1, 0.7)

                local listLayout = Instance.new("UIListLayout")
                listLayout.Padding = UDim.new(0, 4)
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Parent = list
                padding(list, 6, 6, 6, 6)

                local function refresh()
                    for _, child in ipairs(list:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end

                    for _, opt in ipairs(cfg.Options) do
                        local item = Instance.new("TextButton")
                        item.Size = UDim2.new(1, 0, 0, itemHeight)
                        item.BackgroundColor3 = opt == value and theme.accent or theme.card
                        item.Text = tostring(opt)
                        item.TextColor3 = Color3.new(1, 1, 1)
                        item.Font = Enum.Font.GothamBold
                        item.TextSize = 12
                        item.AutoButtonColor = false
                        item.Parent = list
                        corner(item, 8)

                        item.MouseButton1Click:Connect(function()
                            value = opt
                            valueLabel.Text = tostring(value)
                            window.ConfigData[key] = value
                            open = false
                            tween(frame, {Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)}, 0.18)
                            if cfg.Callback then cfg.Callback(value) end
                        end)
                    end
                end

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.Parent = frame

                btn.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        refresh()
                        local height = COMPONENT_HEIGHT + (#cfg.Options * (itemHeight + 4)) + 18
                        tween(frame, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
                        tween(list, {Size = UDim2.new(1, -18, 0, height - COMPONENT_HEIGHT - 10)}, 0.2)
                    else
                        tween(frame, {Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)}, 0.18)
                    end
                end)

                return {
                    Set = function(v)
                        value = v
                        valueLabel.Text = tostring(v)
                        window.ConfigData[key] = v
                    end,
                    Get = function() return value end
                }
            end

            function section:AddSlider(cfg)
                cfg = cfg or {}
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local value = math.clamp(cfg.Default or min, min, max)

                local frame = baseComponent(58)

                makeText(frame, {
                    Text = cfg.Text or "Slider",
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 12 or 13,
                    Size = UDim2.new(1, -90, 0, 24),
                    Position = UDim2.new(0, 12, 0, 5)
                })

                local valueBox = Instance.new("TextBox")
                valueBox.Size = UDim2.new(0, 72, 0, 24)
                valueBox.Position = UDim2.new(1, -84, 0, 5)
                valueBox.BackgroundColor3 = theme.bg2
                valueBox.Text = tostring(value)
                valueBox.TextColor3 = theme.accent
                valueBox.Font = Enum.Font.GothamBold
                valueBox.TextSize = 12
                valueBox.Parent = frame
                corner(valueBox, 8)
                stroke(valueBox, theme.accent, 1, 0.75)

                local bar = Instance.new("Frame")
                bar.Size = UDim2.new(1, -24, 0, 8)
                bar.Position = UDim2.new(0, 12, 1, -18)
                bar.BackgroundColor3 = theme.bg2
                bar.BorderSizePixel = 0
                bar.Parent = frame
                corner(bar, 999)

                local fill = Instance.new("Frame")
                fill.BackgroundColor3 = theme.accent
                fill.BorderSizePixel = 0
                fill.Parent = bar
                corner(fill, 999)

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 18, 0, 18)
                knob.BackgroundColor3 = Color3.new(1, 1, 1)
                knob.BorderSizePixel = 0
                knob.Parent = bar
                knob.ZIndex = 5
                corner(knob, 999)

                local key = "Slider_" .. tostring(cfg.Text or "Slider")
                window.ConfigData[key] = value

                local function apply(v, callback)
                    value = math.clamp(v, min, max)
                    value = math.floor(value * 100) / 100
                    valueBox.Text = tostring(value)

                    local percent = (value - min) / (max - min)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    knob.Position = UDim2.new(percent, -9, 0.5, -9)
                    window.ConfigData[key] = value

                    if callback ~= false and cfg.Callback then
                        cfg.Callback(value)
                    end
                end

                apply(value, false)

                local draggingSlider = false

                local function fromInput(input)
                    local x = input.Position.X
                    local pos = bar.AbsolutePosition.X
                    local size = bar.AbsoluteSize.X
                    if size <= 0 then return end

                    local percent = math.clamp((x - pos) / size, 0, 1)
                    apply(min + (max - min) * percent)
                end

                bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = true
                        fromInput(input)
                    end
                end)

                UIS.InputChanged:Connect(function(input)
                    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        fromInput(input)
                    end
                end)

                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = false
                    end
                end)

                valueBox.FocusLost:Connect(function()
                    local n = tonumber(valueBox.Text)
                    if n then
                        apply(n)
                    else
                        valueBox.Text = tostring(value)
                    end
                end)

                return {
                    Set = function(v) apply(v) end,
                    Get = function() return value end
                }
            end

            function section:AddKeybind(cfg)
                cfg = cfg or {}

                local frame = baseComponent(COMPONENT_HEIGHT)
                local current = cfg.Default or "None"
                local listening = false

                makeText(frame, {
                    Text = cfg.Text or "Keybind",
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 12 or 13,
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0)
                })

                local keyText = makeText(frame, {
                    Text = current,
                    TextColor3 = theme.accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    Size = UDim2.new(0, 85, 1, 0),
                    Position = UDim2.new(1, -96, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local key = "Keybind_" .. tostring(cfg.Text or "Keybind")
                window.ConfigData[key] = current

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.Parent = frame

                btn.MouseButton1Click:Connect(function()
                    listening = true
                    keyText.Text = "Press..."
                end)

                UIS.InputBegan:Connect(function(input, processed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        current = input.KeyCode.Name
                        keyText.Text = current
                        window.ConfigData[key] = current
                        if cfg.Callback then cfg.Callback(current) end
                    elseif not listening and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == current then
                        if cfg.Pressed then cfg.Pressed() end
                    end
                end)

                return {
                    Set = function(v)
                        current = v
                        keyText.Text = tostring(v)
                        window.ConfigData[key] = current
                    end,
                    Get = function() return current end
                }
            end

            function section:AddImage(cfg)
                cfg = cfg or {}

                local height = cfg.Height or 140
                local frame = baseComponent(height)
                frame.ClipsDescendants = true

                local image = Instance.new("ImageLabel")
                image.Name = "Image"
                image.Size = UDim2.new(1, -18, 1, cfg.Text and -34 or -18)
                image.Position = UDim2.new(0, 9, 0, 9)
                image.BackgroundTransparency = 1
                image.Image = cfg.Image or window.Logo
                image.ImageColor3 = Color3.new(1, 1, 1)
                image.ScaleType = cfg.ScaleType or Enum.ScaleType.Crop
                image.Parent = frame
                corner(image, cfg.Radius or 12)

                if cfg.Text then
                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1, -18, 0, 22)
                    text.Position = UDim2.new(0, 9, 1, -27)
                    text.BackgroundTransparency = 1
                    text.Text = cfg.Text
                    text.TextColor3 = theme.accent
                    text.Font = Enum.Font.GothamBlack
                    text.TextSize = IsMobile and 11 or 12
                    text.TextXAlignment = Enum.TextXAlignment.Center
                    text.Parent = frame
                end

                return image
            end

            function section:AddProgressBar(cfg)
                cfg = cfg or {}
                local frame = baseComponent(48)

                makeText(frame, {
                    Text = cfg.Text or "Progress",
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 12 or 13,
                    Size = UDim2.new(1, -90, 0, 22),
                    Position = UDim2.new(0, 12, 0, 5)
                })

                local percentLabel = makeText(frame, {
                    Text = "0%",
                    TextColor3 = theme.accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    Size = UDim2.new(0, 70, 0, 22),
                    Position = UDim2.new(1, -82, 0, 5),
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local bar = Instance.new("Frame")
                bar.Size = UDim2.new(1, -24, 0, 8)
                bar.Position = UDim2.new(0, 12, 1, -15)
                bar.BackgroundColor3 = theme.bg2
                bar.BorderSizePixel = 0
                bar.Parent = frame
                corner(bar, 999)

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = theme.accent
                fill.BorderSizePixel = 0
                fill.Parent = bar
                corner(fill, 999)

                return {
                    SetProgress = function(percent)
                        percent = math.clamp(percent or 0, 0, 100)
                        percentLabel.Text = tostring(math.floor(percent)) .. "%"
                        tween(fill, {Size = UDim2.new(percent / 100, 0, 1, 0)}, 0.2)
                        window.ConfigData[(cfg.Text or "Progress") .. "_progress"] = percent
                    end
                }
            end

            return section
        end

        if #self.Tabs == 1 then
            activate()
        end

        return tab
    end

    local settings = window:CreateTab("Settings", "rbxassetid://6023426945")
    local themeSection = settings:AddSection("Theme Settings")

    themeSection:AddDropdown({
        Text = "Theme",
        Options = AnixlyUI:GetThemes(),
        Default = window.ThemeId,
        Callback = function(selected)
            window:SetTheme(selected)
        end
    })

    themeSection:AddLabel("Anixly UI v" .. AnixlyUI.Version)

    return window
end

return AnixlyUI
