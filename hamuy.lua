repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer

local CONFIG = {
    DELAY = 5,
    HIDE_CONSOLE = false,
    FAKE_LAG = true,
    BEHAVIOR_RANDOM = true,
    BLOCK_REMOTES = false,
}

-- Smart delay system
local function smartWait()
    local startTime = tick()
    
    while tick() - startTime < CONFIG.DELAY do
        local adonisReady = false
        pcall(function()
            for _, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if v.Name:lower():find("admin") then
                    adonisReady = true
                    break
                end
            end
        end)
        
        if adonisReady and tick() - startTime > 3 then
            task.wait(2)
            break
        end
        
        task.wait(1)
    end
end

smartWait()

-- Metatable protection ringan
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    setreadonly(mt, true)
end)

-- Behavior randomization
if CONFIG.BEHAVIOR_RANDOM then
    task.spawn(function()
        while task.wait(math.random(30, 60)) do
            pcall(function()
                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and math.random(1, 5) == 1 then
                    local originalWS = humanoid.WalkSpeed
                    humanoid.WalkSpeed = originalWS * (math.random(98, 102) / 100)
                    task.wait(0.1)
                    humanoid.WalkSpeed = originalWS
                end
            end)
        end
    end)
end

-- Fake lag system
if CONFIG.FAKE_LAG then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if math.random(1, 50) == 1 then
                    task.wait(math.random(5, 20) / 1000)
                end
            end)
        end
    end)
end

print("✅ Anti Cheat Bypass Active")

--// ANIXLY HUB
local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/anixly-ui/refs/heads/main/AnixlyUi.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local settings = settings
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VoiceChatService = game:GetService("VoiceChatService")

local LocalPlayer = Players.LocalPlayer
local IMAGE_ID = "rbxassetid://2061475061"

local function Notify(title, message, theme, duration)
    AnixlyUI:ShowNotification({
        Title = title,
        Message = message,
        Theme = theme or "info",
        Duration = duration or 2
    })
end

local function GetExecutor()
    local success, result = pcall(function()
        return getexecutorname()
    end)

    if success and result then
        if tostring(result):find("Delta") or tostring(result):find("DELTA") then
            return "Delta"
        end
        return tostring(result)
    end

    local okDelta = pcall(function()
        return game:GetService("CoreGui"):FindFirstChild("Delta")
    end)

    if okDelta then
        local core = game:GetService("CoreGui")
        if core:FindFirstChild("Delta") or core:FindFirstChild("Delta Hub") then
            return "Delta"
        end
        if core:FindFirstChild("Fluxus") then
            return "Fluxus"
        end
        if core:FindFirstChild("Electron") then
            return "Electron"
        end
    end

    if syn then
        return "Synapse X"
    end

    if getsenv and setreadonly then
        return "ScriptWare"
    end

    if isfile and isfolder and not syn then
        return "Krnl"
    end

    return "Unknown"
end

local executorName = GetExecutor()

local Window = AnixlyUI:CreateWindow({
    Title = "Anixly Hub",
    Subtitle = "Version 1.0.0 | " .. executorName,
    Theme = "ANIXLY",

    MiniIcon = IMAGE_ID,
    Logo = IMAGE_ID,

    Size = {
        Width = 540,
        Height = 405
    }
})

local DashboardTab = Window:CreateTab("Dashboard")
local MainTab = Window:CreateTab("Main")
local TeleportTab = Window:CreateTab("Teleport")
local ESPTab = Window:CreateTab("ESP")
local UtilityTab = Window:CreateTab("Utility")

--// DASHBOARD

local DashboardSection = DashboardTab:AddSection("🍭 Information")

DashboardSection:AddLabel("═══════════════════════════════")
DashboardSection:AddLabel("       WELCOME TO ANIXLY HUB")
DashboardSection:AddLabel("═══════════════════════════════")

DashboardSection:AddLabel("📊 INFORMATION:")
DashboardSection:AddLabel("👤 Username: " .. LocalPlayer.Name)
DashboardSection:AddLabel("🆔 User ID: " .. LocalPlayer.UserId)
DashboardSection:AddLabel("⭐ Display Name: " .. LocalPlayer.DisplayName)
DashboardSection:AddLabel("🆔 Game ID: " .. game.PlaceId)
DashboardSection:AddLabel("🌍 Server ID: " .. string.sub(game.JobId, 1, 8) .. "...")
DashboardSection:AddLabel("👥 Players Online: " .. #Players:GetPlayers())

DashboardSection:AddButton({
    Text = "Server Hop",
    Callback = function()
        Notify("SERVER HOP", "Searching for new server...", "warning", 2)

        local servers = {}

        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        end)

        if success and result and result.data then
            for _, server in pairs(result.data) do
                if server.id and server.id ~= game.JobId and server.playing and server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end

            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
            else
                Notify("SERVER HOP", "No other servers found.", "error", 3)
            end
        else
            Notify("SERVER HOP", "Failed to fetch servers.", "error", 3)
        end
    end
})

DashboardSection:AddButton({
    Text = "Rejoin Server",
    Callback = function()
        Notify("REJOIN", "Rejoining server...", "warning", 2)
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

local ThemeSection = DashboardTab:AddSection("⚙️ Settings")

ThemeSection:AddDropdown({
    Text = "🎨 Theme",
    Options = AnixlyUI:GetThemes(),
    Default = "ANIXLY",
    Callback = function(themeName)
        Window:SetTheme(themeName)
    end
})

--// MAIN

local MainSection = MainTab:AddSection("⛩️ Main")

-- Noclip
local noclipEnabled = false
local noclipConnection = nil

local function EnableNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function DisableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

MainSection:AddToggle({
    Text = "Noclip",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        if value then
            EnableNoclip()
            Notify("NOCLIP", "Noclip: Enabled", "success", 2)
        else
            DisableNoclip()
            Notify("NOCLIP", "Noclip: Disabled", "info", 2)
        end
    end
})

-- Infinity Jump
local infinityJumpEnabled = false
local jumpConnection = nil

local function EnableInfinityJump()
    if jumpConnection then return end
    jumpConnection = UIS.JumpRequest:Connect(function()
        if infinityJumpEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function DisableInfinityJump()
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
end

MainSection:AddToggle({
    Text = "Infinity Jump",
    Default = false,
    Callback = function(value)
        infinityJumpEnabled = value
        if value then
            EnableInfinityJump()
            Notify("INFINITY JUMP", "Infinity Jump: Enabled", "success", 2)
        else
            DisableInfinityJump()
            Notify("INFINITY JUMP", "Infinity Jump: Disabled", "info", 2)
        end
    end
})

-- Speed Settings
local speedEnabled = false
local originalWalkspeed = 16
local walkspeedValue = 50

MainSection:AddToggle({
    Text = "Speed",
    Default = false,
    Callback = function(value)
        speedEnabled = value
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if value then
                originalWalkspeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = walkspeedValue
                Notify("SPEED", "Speed: Enabled (" .. tostring(walkspeedValue) .. ")", "success", 2)
            else
                humanoid.WalkSpeed = originalWalkspeed
                Notify("SPEED", "Speed: Disabled", "info", 2)
            end
        end
    end
})

MainSection:AddSlider({
    Text = "🏃 WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 50,
    Callback = function(value)
        walkspeedValue = value
        if speedEnabled then
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

--// FLY SCRIPT WITH BUTTON (Taruh di Main Tab)
local FlySection = MainTab:AddSection("✈️ Fly")

local flyActive = false
local flySpeed = 50
local flyBg = nil
local flyBv = nil
local flyConnection = nil
local flyKeys = {w=false, a=false, s=false, d=false, space=false, c=false}

local function StopFly()
    flyActive = false
    if flyBg then 
        flyBg:Destroy() 
        flyBg = nil 
    end
    if flyBv then 
        flyBv:Destroy() 
        flyBv = nil 
    end
    if flyConnection then 
        flyConnection:Disconnect() 
        flyConnection = nil 
    end
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    Notify("FLY", "Fly: Disabled", "info", 2)
end

local function StartFly()
    if flyActive then return end
    
    local char = LocalPlayer.Character
    if not char then 
        Notify("FLY", "No character found!", "error", 2)
        return 
    end
    
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then
        Notify("FLY", "No humanoid found!", "error", 2)
        return
    end
    
    flyActive = true
    humanoid.PlatformStand = true
    
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not torso then 
        flyActive = false
        Notify("FLY", "No torso found!", "error", 2)
        return 
    end
    
    flyBg = Instance.new("BodyGyro", torso)
    flyBg.P = 9e4
    flyBg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBg.cframe = torso.CFrame
    
    flyBv = Instance.new("BodyVelocity", torso)
    flyBv.velocity = Vector3.new(0, 0.1, 0)
    flyBv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyActive then
            if flyBg then 
                flyBg:Destroy() 
                flyBg = nil 
            end
            if flyBv then 
                flyBv:Destroy() 
                flyBv = nil 
            end
            if humanoid then
                humanoid.PlatformStand = false
            end
            return
        end
        
        local cam = workspace.CurrentCamera
        if not cam then return end
        
        local moveVec = Vector3.new(0, 0, 0)
        
        -- Keyboard
        if flyKeys.w then moveVec = moveVec + cam.CFrame.LookVector end
        if flyKeys.s then moveVec = moveVec - cam.CFrame.LookVector end
        if flyKeys.a then moveVec = moveVec - cam.CFrame.RightVector end
        if flyKeys.d then moveVec = moveVec + cam.CFrame.RightVector end
        if flyKeys.space then moveVec = moveVec + Vector3.new(0, 1, 0) end
        if flyKeys.c then moveVec = moveVec - Vector3.new(0, 1, 0) end
        
        -- Analog (kiri)
        local moveDir = humanoid.MoveDirection
        if moveDir and moveDir.Magnitude > 0.1 then
            -- Konversi MoveDirection ke arah kamera
            local forward = cam.CFrame.LookVector * -moveDir.Z
            local right = cam.CFrame.RightVector * moveDir.X
            local analogVec = (forward + right)
            moveVec = moveVec + analogVec
        end
        
        if moveVec.Magnitude > 0 then
            moveVec = moveVec.Unit * flySpeed
            flyBv.velocity = moveVec
        else
            flyBv.velocity = Vector3.new(0, 0, 0)
        end
        
        flyBg.cframe = cam.CFrame
    end)
    
    Notify("FLY", "Fly: Enabled", "success", 3)
end

-- Keyboard handler
local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then flyKeys.w = true end
    if key == Enum.KeyCode.A then flyKeys.a = true end
    if key == Enum.KeyCode.S then flyKeys.s = true end
    if key == Enum.KeyCode.D then flyKeys.d = true end
    if key == Enum.KeyCode.Space then flyKeys.space = true end
    if key == Enum.KeyCode.C then flyKeys.c = true end
end)

UIS.InputEnded:Connect(function(input)
    local key = input.KeyCode
    if key == Enum.KeyCode.W then flyKeys.w = false end
    if key == Enum.KeyCode.A then flyKeys.a = false end
    if key == Enum.KeyCode.S then flyKeys.s = false end
    if key == Enum.KeyCode.D then flyKeys.d = false end
    if key == Enum.KeyCode.Space then flyKeys.space = false end
    if key == Enum.KeyCode.C then flyKeys.c = false end
end)

-- Toggle Fly Button
FlySection:AddToggle({
    Text = "✈️ Fly",
    Default = false,
    Callback = function(value)
        if value then
            StartFly()
        else
            StopFly()
        end
    end
})

-- Speed Slider
FlySection:AddSlider({
    Text = "🚀 Fly Speed",
    Min = 5,
    Max = 200,
    Default = 50,
    Callback = function(value)
        flySpeed = value
        Notify("FLY", "Speed set to: " .. value, "info", 1)
    end
})

--// TELEPORT TAB

-- Teleport to Player
local TeleportToPlayerSection = TeleportTab:AddSection("🎯 Teleport to Player")

local selectedTeleportPlayer = nil
local playerDropdown = nil

local function UpdatePlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

playerDropdown = TeleportToPlayerSection:AddDropdown({
    Text = "Select Player",
    Options = UpdatePlayerList(),
    Default = nil,
    Callback = function(option)
        selectedTeleportPlayer = option
        print("Selected player:", option)
    end
})

TeleportToPlayerSection:AddButton({
    Text = "Teleport to Player",
    Callback = function()
        if not selectedTeleportPlayer or selectedTeleportPlayer == "" then
            Notify("TELEPORT", "Please select a player first.", "warning", 2)
            return
        end
        
        local target = Players:FindFirstChild(selectedTeleportPlayer)
        if not target then
            Notify("TELEPORT", "Player not found!", "error", 2)
            return
        end
        
        local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and myRoot then
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            Notify("TELEPORT", "Teleported to " .. selectedTeleportPlayer, "success", 2)
        else
            Notify("TELEPORT", "Target or character not found.", "error", 2)
        end
    end
})

TeleportToPlayerSection:AddButton({
    Text = "Refresh Player List",
    Callback = function()
        if playerDropdown then
            playerDropdown:SetOptions(UpdatePlayerList())
            Notify("TELEPORT", "Player list refreshed.", "success", 2)
        end
    end
})

-- Spectate Player
local SpectateSection = TeleportTab:AddSection("👁️ Spectate Player")

local viewing = nil
local viewDied = nil
local viewChanged = nil
local isSpectating = false
local originalCameraSubject = nil

local function StopSpectate()
    if isSpectating then
        if viewDied then
            viewDied:Disconnect()
            viewDied = nil
        end
        if viewChanged then
            viewChanged:Disconnect()
            viewChanged = nil
        end
        workspace.CurrentCamera.CameraSubject = originalCameraSubject or LocalPlayer.Character
        viewing = nil
        isSpectating = false
        Notify("SPECTATE", "Stopped spectating", "info", 2)
    end
end

local function StartSpectate(playerName)
    local target = Players:FindFirstChild(playerName)
    if not target then
        Notify("SPECTATE", "Player not found!", "error", 2)
        return false
    end
    
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        Notify("SPECTATE", "Player has no character!", "error", 2)
        return false
    end
    
    StopSpectate()
    
    originalCameraSubject = workspace.CurrentCamera.CameraSubject
    
    viewing = target
    workspace.CurrentCamera.CameraSubject = viewing.Character
    isSpectating = true
    Notify("SPECTATE", "Now viewing " .. target.Name, "success", 2)
    
    local function onCharacterDied()
        repeat task.wait() until target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if isSpectating and viewing == target then
            workspace.CurrentCamera.CameraSubject = target.Character
        end
    end
    
    local function onCameraSubjectChanged()
        if isSpectating and viewing and workspace.CurrentCamera.CameraSubject ~= viewing.Character then
            workspace.CurrentCamera.CameraSubject = viewing.Character
        end
    end
    
    viewDied = target.CharacterAdded:Connect(onCharacterDied)
    viewChanged = workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(onCameraSubjectChanged)
    
    return true
end

local selectedSpectatePlayer = nil
local spectateDropdown = nil

local function UpdateSpectateList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

spectateDropdown = SpectateSection:AddDropdown({
    Text = "Select Player to Spectate",
    Options = UpdateSpectateList(),
    Default = nil,
    Callback = function(option)
        selectedSpectatePlayer = option
        print("Selected player to spectate:", option)
    end
})

SpectateSection:AddButton({
    Text = "Start Spectate",
    Callback = function()
        if not selectedSpectatePlayer or selectedSpectatePlayer == "" then
            Notify("SPECTATE", "Please select a player first.", "warning", 2)
            return
        end
        StartSpectate(selectedSpectatePlayer)
    end
})

SpectateSection:AddButton({
    Text = "Stop Spectate",
    Callback = function()
        StopSpectate()
    end
})

SpectateSection:AddButton({
    Text = "Refresh Player List",
    Callback = function()
        if spectateDropdown then
            spectateDropdown:SetOptions(UpdateSpectateList())
            Notify("SPECTATE", "Player list refreshed.", "success", 2)
        end
    end
})

--// ESP TAB

local ESPSection = ESPTab:AddSection("👁️ ESP Settings")

local espEnabled = false
local espObjects = {}
local espColor = Color3.fromRGB(255, 0, 0)
local espConnection = nil

local espColors = {
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 120),
    Blue = Color3.fromRGB(0, 170, 255),
    Yellow = Color3.fromRGB(255, 220, 0),
    White = Color3.fromRGB(255, 255, 255),
    Purple = Color3.fromRGB(170, 80, 255)
}

local function CreateESP(plr)
    if not plr or plr == LocalPlayer then return end
    local character = plr.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not character or not root then return end
    if espObjects[plr] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Anixly_ESP_Highlight"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = espColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Adornee = character
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Anixly_ESP_Billboard"
    billboard.Size = UDim2.new(0, 200, 0, 45)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "NameLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.45
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = plr.Name
    textLabel.Parent = billboard

    espObjects[plr] = {highlight = highlight, billboard = billboard, textLabel = textLabel}
end

local function RemoveESP(plr)
    local espObj = espObjects[plr]
    if espObj then
        if espObj.highlight then espObj.highlight:Destroy() end
        if espObj.billboard then espObj.billboard:Destroy() end
        espObjects[plr] = nil
    end
end

local function ClearAllESP()
    for plr in pairs(espObjects) do RemoveESP(plr) end
    espObjects = {}
end

local function UpdateAllESP()
    if not espEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then CreateESP(plr) end
    end
end

local function UpdateDistance()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for plr, espObj in pairs(espObjects) do
        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if root and espObj.textLabel then
            local distance = (myRoot.Position - root.Position).Magnitude
            espObj.textLabel.Text = plr.Name .. " [" .. string.format("%.1f", distance) .. "m]"
            if distance < 20 then
                espObj.textLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
            elseif distance < 50 then
                espObj.textLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
            else
                espObj.textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        else
            RemoveESP(plr)
        end
    end
end

ESPSection:AddToggle({
    Text = "Enable ESP",
    Default = false,
    Callback = function(value)
        espEnabled = value
        if value then
            UpdateAllESP()
            if espConnection then espConnection:Disconnect() end
            espConnection = RunService.Heartbeat:Connect(function()
                if espEnabled then
                    UpdateAllESP()
                    UpdateDistance()
                end
            end)
            Notify("ESP", "ESP Enabled", "success", 2)
        else
            if espConnection then espConnection:Disconnect() end
            ClearAllESP()
            Notify("ESP", "ESP Disabled", "info", 2)
        end
    end
})

ESPSection:AddDropdown({
    Text = "ESP Color",
    Options = {"Red", "Green", "Blue", "Yellow", "White", "Purple"},
    Default = "Red",
    Callback = function(option)
        espColor = espColors[option] or Color3.fromRGB(255, 0, 0)
        for _, espObj in pairs(espObjects) do
            if espObj.highlight then
                espObj.highlight.FillColor = espColor
            end
        end
    end
})

-- Auto update ESP when players join/leave
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.7)
        if espEnabled then
            RemoveESP(plr)
            CreateESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    RemoveESP(plr)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            task.wait(0.7)
            if espEnabled then
                RemoveESP(plr)
                CreateESP(plr)
            end
        end)
    end
end

--// UTILITY

-- Anti Lag / Boost FPS
local AntiLagSection = UtilityTab:AddSection("⚡ Boost FPS & Visual")

local antiLagEnabled = false
local antiLagConnection = nil
local noFogEnabled = false
local noBrightEnabled = false
local originalFogEnd = nil
local originalBrightness = nil

-- No Fog
local function SetNoFog(value)
    if value then
        originalFogEnd = Lighting.FogEnd
        Lighting.FogEnd = 0
        Lighting.FogStart = 0
    else
        if originalFogEnd then
            Lighting.FogEnd = originalFogEnd
        else
            Lighting.FogEnd = 100000
        end
        Lighting.FogStart = 0
    end
end

-- No Bright (Dark)
local function SetNoBright(value)
    if value then
        originalBrightness = Lighting.Brightness
        Lighting.Brightness = 0
        Lighting.ClockTime = 0
    else
        if originalBrightness then
            Lighting.Brightness = originalBrightness
        else
            Lighting.Brightness = 1
        end
        Lighting.ClockTime = 14
    end
end

local function ApplyAntiLag()
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
    end
    
    Lighting.GlobalShadows = false
    
    settings().Rendering.QualityLevel = 1
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            pcall(function()
                v.Material = "Plastic"
                v.Reflectance = 0
            end)
        elseif v:IsA("Decal") then
            pcall(function()
                v.Transparency = 1
            end)
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            pcall(function()
                v.Lifetime = NumberRange.new(0)
            end)
        elseif v:IsA("Explosion") then
            pcall(function()
                v.BlastPressure = 1
                v.BlastRadius = 1
            end)
        end
    end
    
    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            pcall(function()
                v.Enabled = false
            end)
        end
    end
    
    if noFogEnabled then
        SetNoFog(true)
    end
    if noBrightEnabled then
        SetNoBright(true)
    end
end

local function StartAntiLag()
    if antiLagConnection then return end
    
    ApplyAntiLag()
    
    antiLagConnection = workspace.DescendantAdded:Connect(function(child)
        task.spawn(function()
            if antiLagEnabled then
                if child:IsA("ForceField") or child:IsA("Sparkles") or child:IsA("Smoke") or child:IsA("Fire") then
                    RunService.Heartbeat:Wait()
                    pcall(function() child:Destroy() end)
                elseif child:IsA("Part") or child:IsA("UnionOperation") or child:IsA("MeshPart") then
                    pcall(function()
                        child.Material = "Plastic"
                        child.Reflectance = 0
                    end)
                elseif child:IsA("Decal") then
                    pcall(function()
                        child.Transparency = 1
                    end)
                elseif child:IsA("ParticleEmitter") or child:IsA("Trail") then
                    pcall(function()
                        child.Lifetime = NumberRange.new(0)
                    end)
                end
            end
        end)
    end)
end

local function StopAntiLag()
    if antiLagConnection then
        antiLagConnection:Disconnect()
        antiLagConnection = nil
    end
end

AntiLagSection:AddToggle({
    Text = "Boost FPS",
    Default = false,
    Callback = function(value)
        antiLagEnabled = value
        if value then
            StartAntiLag()
            Notify("BOOST FPS", "Boost FPS enabled - Graphics reduced", "success", 3)
        else
            StopAntiLag()
            Notify("BOOST FPS", "Boost FPS disabled", "info", 2)
        end
    end
})

AntiLagSection:AddToggle({
    Text = "No Fog",
    Default = false,
    Callback = function(value)
        noFogEnabled = value
        SetNoFog(value)
        if value then
            Notify("NO FOG", "Fog removed! Better visibility", "success", 2)
        else
            Notify("NO FOG", "Fog restored", "info", 2)
        end
    end
})

AntiLagSection:AddToggle({
    Text = "No Bright",
    Default = false,
    Callback = function(value)
        noBrightEnabled = value
        SetNoBright(value)
        if value then
            Notify("NO BRIGHT", "Dark mode enabled", "success", 2)
        else
            Notify("NO BRIGHT", "Brightness restored", "info", 2)
        end
    end
})

-- Anti Staff
local AntiStaffSection = UtilityTab:AddSection("🛡️ Anti Staff")

local staffKeywords = {
    "admin", "mod", "moderator", "owner", "creator", "dev", "developer",
    "staff", "manager", "super", "helper", "head", "coordinator"
}

local antiStaffEnabled = false
local antiStaffConnection = nil

local function CheckForStaff()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local nameLower = plr.Name:lower()
            local displayLower = plr.DisplayName:lower()
            for _, keyword in ipairs(staffKeywords) do
                if nameLower:find(keyword) or displayLower:find(keyword) then
                    return true, plr.Name, keyword
                end
            end
        end
    end
    return false, nil, nil
end

local function StartAntiStaff()
    if antiStaffConnection then return end
    antiStaffConnection = RunService.Heartbeat:Connect(function()
        if antiStaffEnabled then
            local found, name, keyword = CheckForStaff()
            if found then
                Notify("⚠️ STAFF DETECTED", name .. " [" .. keyword .. "] - Hopping server...", "error", 5)
                task.wait(1)
                local servers = {}
                local success, result = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
                end)
                if success and result and result.data then
                    for _, v in pairs(result.data) do
                        if v.playing and v.id ~= game.JobId then
                            table.insert(servers, v.id)
                        end
                    end
                    if #servers > 0 then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
                    else
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    end
                else
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end
        end
    end)
end

local function StopAntiStaff()
    if antiStaffConnection then
        antiStaffConnection:Disconnect()
        antiStaffConnection = nil
    end
end

AntiStaffSection:AddToggle({
    Text = "Anti Staff",
    Default = false,
    Callback = function(value)
        antiStaffEnabled = value
        if value then
            StartAntiStaff()
            Notify("ANTI STAFF", "Anti Staff: Enabled", "success", 3)
        else
            StopAntiStaff()
            Notify("ANTI STAFF", "Anti Staff: Disabled", "info", 2)
        end
    end
})

-- Anti AFK
local AntiAFKSection = UtilityTab:AddSection("💤 Anti AFK")

local antiAFKEnabled = false
local afkConnection = nil
local lastInput = tick()

UIS.InputBegan:Connect(function() lastInput = tick() end)
UIS.InputChanged:Connect(function() lastInput = tick() end)

local function SimulateInput()
    UIS.InputBegan:Fire(Enum.KeyCode.W, Enum.UserInputState.Begin)
    task.wait(0.1)
    UIS.InputEnded:Fire(Enum.KeyCode.W, Enum.UserInputState.End)
end

local function StartAntiAFK()
    if afkConnection then return end
    afkConnection = RunService.Heartbeat:Connect(function()
        if antiAFKEnabled then
            if tick() - lastInput > 50 then
                SimulateInput()
                lastInput = tick()
            end
        end
    end)
end

local function StopAntiAFK()
    if afkConnection then
        afkConnection:Disconnect()
        afkConnection = nil
    end
end

AntiAFKSection:AddToggle({
    Text = "Anti AFK",
    Default = false,
    Callback = function(value)
        antiAFKEnabled = value
        if value then
            StartAntiAFK()
            Notify("ANTI AFK", "Anti AFK: Enabled", "success", 3)
        else
            StopAntiAFK()
            Notify("ANTI AFK", "Anti AFK: Disabled", "info", 2)
        end
    end
})

-- Hide Name Tag
local HideNameSection = UtilityTab:AddSection("👀 Hide Name Tag")

local hideNameEnabled = false
local hideNameLoop = nil
local hideNameConnections = {}

local function HidePlayerName(plr)
    if not hideNameEnabled then return end
    if not plr then return end
    
    local character = plr.Character
    if character then
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.NameDisplayDistance = 0
            end)
        end
        
        for _, child in ipairs(character:GetDescendants()) do
            if child:IsA("BillboardGui") then
                pcall(function()
                    child.Enabled = false
                end)
            end
        end
    end
end

local function StartHideName()
    if hideNameLoop then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        HidePlayerName(plr)
    end
    
    hideNameLoop = RunService.Heartbeat:Connect(function()
        if hideNameEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                HidePlayerName(plr)
            end
        end
    end)
    
    local playerAddedConn = Players.PlayerAdded:Connect(function(plr)
        task.wait(0.5)
        HidePlayerName(plr)
    end)
    table.insert(hideNameConnections, playerAddedConn)
    
    local charAddedConn = LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        HidePlayerName(LocalPlayer)
    end)
    table.insert(hideNameConnections, charAddedConn)
    
    for _, plr in ipairs(Players:GetPlayers()) do
        local charAddedConn2 = plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            HidePlayerName(plr)
        end)
        table.insert(hideNameConnections, charAddedConn2)
    end
end

local function StopHideName()
    if hideNameLoop then
        hideNameLoop:Disconnect()
        hideNameLoop = nil
    end
    
    for _, conn in ipairs(hideNameConnections) do
        pcall(function() conn:Disconnect() end)
    end
    hideNameConnections = {}
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            local humanoid = plr.Character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                pcall(function()
                    humanoid.NameDisplayDistance = 100
                end)
            end
            for _, child in ipairs(plr.Character:GetDescendants()) do
                if child:IsA("BillboardGui") then
                    pcall(function()
                        child.Enabled = true
                    end)
                end
            end
        end
    end
end

HideNameSection:AddToggle({
    Text = "Hide Name",
    Default = false,
    Callback = function(value)
        hideNameEnabled = value
        if value then
            StartHideName()
            Notify("HIDE NAME", "Name tags hidden for all players!", "success", 3)
        else
            StopHideName()
            Notify("HIDE NAME", "Name tags restored", "info", 2)
        end
    end
})

--// BYPASS CHAT & VOICE CHAT SECTION
local BypassSection = UtilityTab:AddSection("💬 Bypass Chat & Voice Chat")

local chatBypassEnabled = false
local chatGui = nil
local voiceBypassEnabled = false

-- Word replacements
local bypassWords = {
    ["anjing"] = "anj{{aieixzvzx:ing}}",
    ["babi"] = "ba{{aieixzvzx:bi}}",
    ["ngentot"] = "ngen{{aieixzvzx:tot}}",
    ["kontol"] = "kon{{aieixzvzx:tol}}",
    ["memek"] = "me{{aieixzvzx:mek}}",
    ["goblok"] = "gob{{aieixzvzx:lok}}",
    ["tolol"] = "to{{aieixzvzx:lol}}",
    ["bangsat"] = "bang{{aieixzvzx:sat}}",
    ["keparat"] = "kepa{{aieixzvzx:rat}}",
    ["kimak"] = "ki{{aieixzvzx:mak}}",
    ["jancok"] = "jan{{aieixzvzx:cok}}",
    ["pukimak"] = "pu{{aieixzvzx:kimak}}",
    ["sialan"] = "sia{{aieixzvzx:lan}}",
    ["brengsek"] = "bren{{aieixzvzx:gsek}}",
    ["bacot"] = "ba{{aieixzvzx:cot}}",
    ["asu"] = "a{{aieixzvzx:su}}",
    ["tai"] = "ta{{aieixzvzx:i}}",
    ["monyet"] = "mony{{aieixzvzx:et}}",
    ["setan"] = "se{{aieixzvzx:tan}}",
}

-- Buat UI (posisi tengah layar)
local function CreateChatGUI()
    if chatGui then return end
    
    chatGui = Instance.new("ScreenGui")
    chatGui.Name = "ChatBypasser"
    chatGui.Parent = game:GetService("CoreGui")
    chatGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Parent = chatGui
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size = UDim2.new(0, 320, 0, 112)
    frame.Active = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = Color3.fromRGB(80, 130, 255)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.25

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Parent = frame
    titleBar.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 34)
    titleBar.Active = true

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    local titleFix = Instance.new("Frame")
    titleFix.Parent = titleBar
    titleFix.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.Size = UDim2.new(1, 0, 0, 12)

    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Parent = titleBar
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 12, 0, 8)
    titleText.Size = UDim2.new(1, -60, 0, 18)
    titleText.Text = "Chat Bypasser"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 13
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.BackgroundColor3 = Color3.fromRGB(225, 70, 85)
    closeBtn.BorderSizePixel = 0
    closeBtn.Position = UDim2.new(1, -32, 0, 6)
    closeBtn.Size = UDim2.new(0, 24, 0, 22)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 7)
    closeCorner.Parent = closeBtn

    -- Content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = frame
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Position = UDim2.new(0, 0, 0, 34)
    contentFrame.Size = UDim2.new(1, 0, 1, -34)

    -- TextBox
    local textBox = Instance.new("TextBox")
    textBox.Parent = contentFrame
    textBox.BackgroundColor3 = Color3.fromRGB(34, 34, 46)
    textBox.BorderSizePixel = 0
    textBox.Position = UDim2.new(0, 12, 0, 11)
    textBox.Size = UDim2.new(1, -92, 0, 34)
    textBox.PlaceholderText = "Type message..."
    textBox.PlaceholderColor3 = Color3.fromRGB(125, 125, 140)
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 13
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.TextXAlignment = Enum.TextXAlignment.Left

    local textPadding = Instance.new("UIPadding")
    textPadding.PaddingLeft = UDim.new(0, 10)
    textPadding.PaddingRight = UDim.new(0, 8)
    textPadding.Parent = textBox

    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 8)
    textBoxCorner.Parent = textBox

    local textStroke = Instance.new("UIStroke")
    textStroke.Parent = textBox
    textStroke.Color = Color3.fromRGB(65, 65, 80)
    textStroke.Thickness = 1
    textStroke.Transparency = 0.45

    -- Send button
    local sendBtn = Instance.new("TextButton")
    sendBtn.Parent = contentFrame
    sendBtn.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
    sendBtn.BorderSizePixel = 0
    sendBtn.Position = UDim2.new(1, -68, 0, 11)
    sendBtn.Size = UDim2.new(0, 56, 0, 34)
    sendBtn.Text = "Send"
    sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendBtn.TextSize = 12
    sendBtn.Font = Enum.Font.GothamBold

    local sendCorner = Instance.new("UICorner")
    sendCorner.CornerRadius = UDim.new(0, 8)
    sendCorner.Parent = sendBtn

    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = contentFrame
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 12, 0, 52)
    statusLabel.Size = UDim2.new(1, -24, 0, 18)
    statusLabel.Text = "Ready"
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 165)
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    
    -- Drag functionality
    local dragging = false
    local dragStart = nil
    local frameStart = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = frame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newX = frameStart.X.Offset + delta.X
            local newY = frameStart.Y.Offset + delta.Y
            frame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
    
    -- Fungsi untuk mengirim pesan via chat
    local function SendMessage(message)
        if message == "" then 
            statusLabel.Text = "Cannot send empty message"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            task.wait(1)
            statusLabel.Text = "Ready"
            statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            return 
        end
        
        local finalMessage = message
        for word, replacement in pairs(bypassWords) do
            finalMessage = finalMessage:gsub(word, replacement)
            finalMessage = finalMessage:gsub(word:upper(), replacement:upper())
            finalMessage = finalMessage:gsub(word:sub(1,1):upper() .. word:sub(2), replacement:sub(1,1):upper() .. replacement:sub(2))
        end
        
        local success = false
        
        local remote = ReplicatedStorage:FindFirstChild("SayMessageRequest")
        if remote then
            pcall(function()
                remote:FireServer(finalMessage, "All")
                success = true
            end)
        end
        
        if not success then
            for _, child in ipairs(ReplicatedStorage:GetChildren()) do
                if child.Name:find("Chat") or child.Name:find("Say") or child.Name:find("Message") then
                    if child:IsA("RemoteEvent") then
                        pcall(function()
                            child:FireServer(finalMessage, "All")
                            success = true
                        end)
                        if success then break end
                    end
                end
            end
        end
        
        if not success then
            local textChatService = game:GetService("TextChatService")
            local textChannels = textChatService and textChatService:FindFirstChild("TextChannels")
            local generalChannel = textChannels and textChannels:FindFirstChild("RBXGeneral")
            if generalChannel then
                pcall(function()
                    generalChannel:SendAsync(finalMessage)
                    success = true
                end)
            end
        end
        
        if success then
            statusLabel.Text = "Sent: " .. message:sub(1, 30)
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            textBox.Text = ""
            task.wait(1.5)
            statusLabel.Text = "Ready"
            statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        else
            statusLabel.Text = "Failed to send message"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            task.wait(2)
            statusLabel.Text = "Ready"
            statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
    
    sendBtn.MouseButton1Click:Connect(function()
        SendMessage(textBox.Text)
    end)
    
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SendMessage(textBox.Text)
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
        chatBypassEnabled = false
        Notify("CHAT BYPASS", "Chat bypass disabled", "info", 2)
    end)
    
    return frame
end

-- Chat Bypass Toggle
local function StartChatBypass()
    if chatBypassEnabled then return end
    
    local frame = CreateChatGUI()
    if frame then
        frame.Visible = true
        chatBypassEnabled = true
        Notify("CHAT BYPASS", "Chat bypass ready! Type your message", "success", 3)
    end
end

local function StopChatBypass()
    if chatGui then
        chatGui:Destroy()
        chatGui = nil
    end
    chatBypassEnabled = false
end

BypassSection:AddToggle({
    Text = "Chat Bypasser [Beta]",
    Default = false,
    Callback = function(value)
        if value then
            StartChatBypass()
        else
            StopChatBypass()
        end
    end
})

-- Voice Chat Bypass
local function StartVoiceBypass()
    if voiceBypassEnabled then return end
    
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            local namecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                if getnamecallmethod() == "IsVoiceEnabledForUserIdAsync" then
                    return true
                end
                return namecall(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
    
    voiceBypassEnabled = true
    Notify("VOICE BYPASS", "Voice chat forced enabled!", "success", 3)
end

local function StopVoiceBypass()
    voiceBypassEnabled = false
    Notify("VOICE BYPASS", "Voice bypass disabled", "info", 2)
end

BypassSection:AddToggle({
    Text = "Voice Chat Bypasser [Beta]",
    Default = false,
    Callback = function(value)
        if value then
            StartVoiceBypass()
        else
            StopVoiceBypass()
        end
    end
})

-- Auto update all features when character respawns
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.6)
    if speedEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = walkspeedValue end
    end
    if noclipEnabled then EnableNoclip() end
    if infinityJumpEnabled then EnableInfinityJump() end
end)

print("✅ Anixly Hub Loaded Successfully!")