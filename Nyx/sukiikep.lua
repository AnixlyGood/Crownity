repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        setreadonly(mt, false)
        
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            
            if method == "Kick" then
                return nil
            end
            
            if method == "FireServer" or method == "InvokeServer" then
                local success, remoteName = pcall(function()
                    if self and typeof(self) == "Instance" then
                        return tostring(self.Name):lower()
                    end
                    return ""
                end)
                
                if success and remoteName and remoteName ~= "" then
                    local dangerous = {
                        "detect", "anticheat", "security", "cheat",
                        "exploit", "admin", "ban", "kick", "report",
                        "namecall", "instance", "detector"
                    }
                    for _, word in ipairs(dangerous) do
                        if remoteName:find(word) then
                            if method == "InvokeServer" then
                                return nil
                            end
                            return
                        end
                    end
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        mt.__index = newcclosure(function(self, key)
            if key == "__namecall" then
                return nil
            end
            return oldIndex(self, key)
        end)
        
        setreadonly(mt, true)
    end
end)

pcall(function()
    local fake = {
        isExploiter = false,
        cheating = false,
        detected = false,
        flagged = false,
        banned = false,
        namecallHooked = false
    }
    for key, value in pairs(fake) do
        pcall(function()
            _G[key] = value
            getgenv()[key] = value
        end)
    end
end)

pcall(function()
    local toRemove = {}
    for _, container in ipairs({
        game:GetService("ReplicatedStorage"),
        game:GetService("ServerScriptService"),
        game:GetService("Workspace")
    }) do
        for _, script in ipairs(container:GetDescendants()) do
            if script:IsA("Script") or script:IsA("LocalScript") or script:IsA("ModuleScript") then
                local name = script.Name:lower()
                if name:find("namecall") or name:find("detector") or name:find("instance") or
                   name:find("anticheat") or name:find("security") or name:find("detect") then
                    table.insert(toRemove, script)
                end
            end
        end
    end
    for _, script in ipairs(toRemove) do
        pcall(function() script:Destroy() end)
    end
end)

pcall(function()
    local rs = game:GetService("ReplicatedStorage")
    for _, remote in ipairs(rs:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = remote.Name:lower()
            if name:find("detect") or name:find("namecall") or name:find("instance") or
               name:find("anticheat") or name:find("security") then
                pcall(function() remote:Destroy() end)
            end
        end
    end
end)

pcall(function()
    if getconnections then
        for _, conn in ipairs(getconnections(game:GetService("ScriptContext").Error)) do
            pcall(function() conn:Disable() end)
        end
    end
end)

local CONFIG = {
    DELAY = 8,
    HIDE_CONSOLE = false,
    FAKE_LAG = true,
    BEHAVIOR_RANDOM = true,
    BLOCK_REMOTES = true,
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
        
        if adonisReady and tick() - startTime > 5 then
            task.wait(2)
            break
        end
        
        task.wait(1)
    end
end

smartWait()

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        setreadonly(mt, false)
        setreadonly(mt, true)
    end
end)

if CONFIG.BLOCK_REMOTES then
    local blockedRemotes = {
        "Detected", "Kick", "Ban", "AdminDetection",
        "AntiCheat", "Security", "LogExploit",
        "AntiCheatDetection", "ReportExploit", "BanUser"
    }
    
    local suspiciousPatterns = {
        "detect", "kick", "ban", "log", "report",
        "anticheat", "antitool", "cheatdetect"
    }
    
    local allowedRemotes = {
        "ResetCP", "Teleport", "SummitKitRemotes", "Checkpoints",
        "TeleportTo", "CP", "MountSalora", "MountMahoni"
    }
    
    if not getgenv().namecallHooked then
        getgenv().namecallHooked = true
        pcall(function()
            local mt = getrawmetatable(game)
            if mt and mt.__namecall then
                local originalNamecall = mt.__namecall
                setreadonly(mt, false)
                
                mt.__namecall = newcclosure(function(self, ...)
                    local args = {...}
                    local method = getnamecallmethod()
                    
                    if method == "Kick" then
                        return nil
                    end
                    
                    if method == "FireServer" or method == "InvokeServer" then
                        local success2, remoteName = pcall(function() 
                            if self and typeof(self) == "Instance" then
                                return tostring(self.Name):lower()
                            end
                            return ""
                        end)
                        
                        if success2 and remoteName and remoteName ~= "" then
                            local isAllowed = false
                            for _, allowed in ipairs(allowedRemotes) do
                                if remoteName:find(allowed:lower(), 1, true) then
                                    isAllowed = true
                                    break
                                end
                            end
                            
                            if isAllowed then
                                return originalNamecall(self, table.unpack(args))
                            end
                            
                            for _, blocked in ipairs(blockedRemotes) do
                                if remoteName:find(blocked:lower(), 1, true) then
                                    if method == "InvokeServer" then
                                        return nil
                                    end
                                    return
                                end
                            end
                            
                            for _, pattern in ipairs(suspiciousPatterns) do
                                if remoteName:find(pattern, 1, true) then
                                    if method == "InvokeServer" then
                                        return nil
                                    end
                                    return
                                end
                            end
                        end
                    end
                    
                    return originalNamecall(self, table.unpack(args))
                end)
                
                setreadonly(mt, true)
            end
        end)
    end
    
    if not getgenv().playerKickHooked then
        getgenv().playerKickHooked = true
        pcall(function()
            if player then
                local kickMethod = player.Kick
                if kickMethod and typeof(kickMethod) == "function" then
                    player.Kick = newcclosure(function(...)
                        return nil
                    end)
                end
            end
            
            local playerMeta = getrawmetatable(player)
            if playerMeta then
                setreadonly(playerMeta, false)
                local oldIndex = playerMeta.__index
                playerMeta.__index = newcclosure(function(self, key)
                    if key == "Kick" then
                        return function() end
                    end
                    return oldIndex(self, key)
                end)
                setreadonly(playerMeta, true)
            end
        end)
    end
end

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

-- GUI detection blocking
task.spawn(function()
    pcall(function()
        local playerGui = player:WaitForChild("PlayerGui", 10)
        if playerGui then
            playerGui.DescendantAdded:Connect(function(gui)
                pcall(function()
                    if gui and gui.Parent and (gui:IsA("TextLabel") or gui:IsA("TextBox")) then
                        local success, text = pcall(function() return gui.Text:lower() end)
                        if success and text and (text:find("detect") or text:find("kick") or text:find("ban")) then
                            pcall(function()
                                gui.Text = ""
                                gui.Visible = false
                            end)
                        end
                    end
                end)
            end)
        end
    end)
end)

--// ANIXLY HUB
local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/anixly-ui/refs/heads/main/AnixlyUi.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

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

    return "Unknown Executor"
end

local executorName = GetExecutor()

local Window = AnixlyUI:CreateWindow({
    Title = "Nyx Hub",
    Subtitle = "Version 1.0.0 | " .. executorName, 
    Theme = "ANIXLY",

    MiniIcon = IMAGE_ID,
    Logo = IMAGE_ID,

    Size = {
        Width = 540,
        Height = 405
    }
})

local MainTab = Window:CreateTab("Main")
local ESPTab = Window:CreateTab("ESP")
local TeleportTab = Window:CreateTab("Teleport")
local UtilityTab = Window:CreateTab("Utility")

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

-- INVISIBLE MODE
local InvisibleSection = MainTab:AddSection("👻 Invisible Mode")

-- No Fall Damage
local noFallDamageEnabled = false
local noFallConnection = nil

local function StartNoFallDamage()
    if noFallConnection then return end
    
    noFallConnection = RunService.Heartbeat:Connect(function()
        if noFallDamageEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.FloorMaterial == Enum.Material.Air then
                    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart and rootPart.Velocity.Y < -30 then
                        rootPart.Velocity = Vector3.new(rootPart.Velocity.X, -20, rootPart.Velocity.Z)
                    end
                end
            end
        end
    end)
end

local function StopNoFallDamage()
    if noFallConnection then
        noFallConnection:Disconnect()
        noFallConnection = nil
    end
end

InvisibleSection:AddToggle({
    Text = "No Fall Damage",
    Default = false,
    Callback = function(value)
        noFallDamageEnabled = value
        if value then
            StartNoFallDamage()
            Notify("NO FALL", "No Fall Damage: Enabled", "success", 2)
        else
            StopNoFallDamage()
            Notify("NO FALL", "No Fall Damage: Disabled", "info", 2)
        end
    end
})

local invisibleEnabled = false
local invisibleConnection = nil

local function StartInvisible()
    if invisibleConnection then return end
    
    invisibleConnection = RunService.Heartbeat:Connect(function()
        if invisibleEnabled and LocalPlayer.Character then
            local character = LocalPlayer.Character
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            end
        end
    end)
end

local function StopInvisible()
    if invisibleConnection then
        invisibleConnection:Disconnect()
        invisibleConnection = nil
    end
    
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
        end
    end
end

InvisibleSection:AddToggle({
    Text = "Invisible",
    Default = false,
    Callback = function(value)
        invisibleEnabled = value
        if value then
            StartInvisible()
            Notify("INVISIBLE", "Invisible: Enabled - You are now invisible!", "success", 3)
        else
            StopInvisible()
            Notify("INVISIBLE", "Invisible: Disabled", "info", 2)
        end
    end
})

-- FLY SECTION
local FlySection = MainTab:AddSection("🛸 Fly")

local flyActive = false
local flySpeed = 50

local flyGyro = nil
local flyVelocity = nil

local renderConnection = nil
local inputBeganConnection = nil
local inputEndedConnection = nil
local diedConnection = nil

local flyKeys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Up = false,
    Down = false
}

local function ResetFlyKeys()
    for key in pairs(flyKeys) do
        flyKeys[key] = false
    end
end

local function DisconnectFlyConnections()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end

    if inputBeganConnection then
        inputBeganConnection:Disconnect()
        inputBeganConnection = nil
    end

    if inputEndedConnection then
        inputEndedConnection:Disconnect()
        inputEndedConnection = nil
    end

    if diedConnection then
        diedConnection:Disconnect()
        diedConnection = nil
    end
end

local function StopFly(silent)
    flyActive = false

    DisconnectFlyConnections()
    ResetFlyKeys()

    if flyGyro then
        flyGyro:Destroy()
        flyGyro = nil
    end

    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if humanoid then
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
    end

    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    if not silent then
        Notify("FLY", "Fly: Disabled", "info", 2)
    end
end

local function StartFly()
    if flyActive then
        return
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not character or not humanoid or not root then
        Notify("FLY", "Character belum siap!", "error", 2)
        return
    end

    DisconnectFlyConnections()
    ResetFlyKeys()

    flyActive = true
    humanoid.PlatformStand = true
    humanoid.AutoRotate = false

    flyGyro = Instance.new("BodyGyro")
    flyGyro.Name = "NyxFlyGyro"
    flyGyro.P = 90000
    flyGyro.D = 1000
    flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyGyro.CFrame = root.CFrame
    flyGyro.Parent = root

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.Name = "NyxFlyVelocity"
    flyVelocity.P = 1500
    flyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = root

    inputBeganConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not flyActive then
            return
        end

        local key = input.KeyCode

        if key == Enum.KeyCode.W then
            flyKeys.W = true

        elseif key == Enum.KeyCode.A then
            flyKeys.A = true

        elseif key == Enum.KeyCode.S then
            flyKeys.S = true

        elseif key == Enum.KeyCode.D then
            flyKeys.D = true

        elseif key == Enum.KeyCode.Space
            or key == Enum.KeyCode.E then

            flyKeys.Up = true

        elseif key == Enum.KeyCode.LeftControl
            or key == Enum.KeyCode.RightControl
            or key == Enum.KeyCode.C
            or key == Enum.KeyCode.Q then

            flyKeys.Down = true
        end
    end)

    inputEndedConnection = UIS.InputEnded:Connect(function(input)
        local key = input.KeyCode

        if key == Enum.KeyCode.W then
            flyKeys.W = false

        elseif key == Enum.KeyCode.A then
            flyKeys.A = false

        elseif key == Enum.KeyCode.S then
            flyKeys.S = false

        elseif key == Enum.KeyCode.D then
            flyKeys.D = false

        elseif key == Enum.KeyCode.Space
            or key == Enum.KeyCode.E then

            flyKeys.Up = false

        elseif key == Enum.KeyCode.LeftControl
            or key == Enum.KeyCode.RightControl
            or key == Enum.KeyCode.C
            or key == Enum.KeyCode.Q then

            flyKeys.Down = false
        end
    end)

    diedConnection = humanoid.Died:Connect(function()
        StopFly(true)
    end)

    renderConnection = RunService.RenderStepped:Connect(function()
        if not flyActive then
            return
        end

        if not character.Parent or humanoid.Health <= 0 then
            StopFly(true)
            return
        end

        local camera = workspace.CurrentCamera

        if not camera or not flyGyro or not flyVelocity then
            return
        end

        local cameraForward = camera.CFrame.LookVector
        local cameraRight = camera.CFrame.RightVector

        local moveVector = Vector3.zero

        local keyboardMoving =
            flyKeys.W
            or flyKeys.A
            or flyKeys.S
            or flyKeys.D

        if flyKeys.W then
            moveVector += cameraForward
        end

        if flyKeys.S then
            moveVector -= cameraForward
        end

        if flyKeys.A then
            moveVector -= cameraRight
        end

        if flyKeys.D then
            moveVector += cameraRight
        end

        if not keyboardMoving then
            local moveDirection = humanoid.MoveDirection

            if moveDirection.Magnitude > 0.05 then
                local flatForward = Vector3.new(
                    cameraForward.X,
                    0,
                    cameraForward.Z
                )

                local flatRight = Vector3.new(
                    cameraRight.X,
                    0,
                    cameraRight.Z
                )

                if flatForward.Magnitude > 0.001 then
                    flatForward = flatForward.Unit
                else
                    flatForward = Vector3.new(0, 0, -1)
                end

                if flatRight.Magnitude > 0.001 then
                    flatRight = flatRight.Unit
                else
                    flatRight = Vector3.new(1, 0, 0)
                end

                local forwardAmount = moveDirection:Dot(flatForward)
                local rightAmount = moveDirection:Dot(flatRight)

                moveVector += cameraForward * forwardAmount
                moveVector += cameraRight * rightAmount
            end
        end

        if flyKeys.Up then
            moveVector += Vector3.new(0, 1, 0)
        end

        if flyKeys.Down then
            moveVector -= Vector3.new(0, 1, 0)
        end

        if moveVector.Magnitude > 0.05 then
            flyVelocity.Velocity = moveVector.Unit * flySpeed
        else
            flyVelocity.Velocity = Vector3.zero
        end

        flyGyro.CFrame = CFrame.lookAt(
            root.Position,
            root.Position + cameraForward,
            camera.CFrame.UpVector
        )
    end)

    Notify("FLY", "Fly: Enabled", "success", 2)
end

FlySection:AddToggle({
    Text = "Fly",
    Default = false,
    Callback = function(value)
        if value then
            StartFly()
        else
            StopFly()
        end
    end
})

FlySection:AddSlider({
    Text = "🚀 Fly Speed",
    Min = 5,
    Max = 200,
    Default = 50,
    Callback = function(value)
        flySpeed = tonumber(value) or 50
        Notify("FLY", "Speed: " .. tostring(flySpeed), "info", 1)
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    if flyActive then
        StopFly(true)
    end
end)