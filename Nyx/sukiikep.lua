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

-- God Mode (TARUH SINI)
local godModeEnabled = false
local godModeConnection = nil

local function StartGodMode()
    if godModeConnection then return end
    
    godModeConnection = RunService.Heartbeat:Connect(function()
        if godModeEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                humanoid.BreakJointsOnDeath = false
            end
            
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
        end
    end)
end

local function StopGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid.BreakJointsOnDeath = true
        end
    end
end

MainSection:AddToggle({
    Text = "God Mode",
    Default = false,
    Callback = function(value)
        godModeEnabled = value
        if value then
            StartGodMode()
            Notify("GOD MODE", "God Mode: Enabled - You are immortal!", "success", 3)
        else
            StopGodMode()
            Notify("GOD MODE", "God Mode: Disabled", "info", 2)
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

----V1 AUTO SUMMIT (CP1-CP41)
local AutoSummitV1 = MainTab:AddSection("🏔️ Auto Summit V1")

local autoSummitEnabled = false
local currentCp = 1
local cpDelay = 1
local loopCount = 0
local selectedTargetCP = "CP41"
local isTeleporting = false

local function TeleportToCP(cpNumber)
    if isTeleporting then return false end
    isTeleporting = true
    
    local character = LocalPlayer.Character
    if not character then 
        isTeleporting = false
        return false 
    end
    
    task.wait(0.2)
    
    local checkpointParent = workspace:FindFirstChild("Checkpoints")
    if not checkpointParent then
        checkpointParent = workspace:FindFirstChild("MountKicauMania") or workspace:FindFirstChild("Mount")
    end
    
    if not checkpointParent then
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name:lower():find("checkpoint") or child.Name:lower():find("cp") then
                checkpointParent = child
                break
            end
        end
    end
    
    if not checkpointParent then
        Notify("AUTO SUMMIT", "Checkpoints folder not found!", "error", 2)
        isTeleporting = false
        return false
    end
    
    local cpName = "CP" .. cpNumber
    local cp = checkpointParent:FindFirstChild(cpName)
    
    if not cp then
        cpName = "Checkpoint" .. cpNumber
        cp = checkpointParent:FindFirstChild(cpName)
    end
    
    if not cp then
        for _, child in ipairs(checkpointParent:GetChildren()) do
            if child.Name:lower() == "cp" .. cpNumber or child.Name:lower() == "checkpoint" .. cpNumber then
                cp = child
                break
            end
        end
    end
    
    if not cp then
        Notify("AUTO SUMMIT", "CP" .. cpNumber .. " not found!", "error", 2)
        isTeleporting = false
        return false
    end
    
    if cp:IsA("Model") then
        character:PivotTo(cp:GetPivot() + Vector3.new(0, 3, 0))
    elseif cp:IsA("BasePart") then
        character:PivotTo(cp.CFrame + Vector3.new(0, 3, 0))
    else
        local part = cp:FindFirstChildWhichIsA("BasePart", true)
        if part then
            character:PivotTo(part.CFrame + Vector3.new(0, 3, 0))
        else
            Notify("AUTO SUMMIT", "Target is not a Model or BasePart", "error", 2)
            isTeleporting = false
            return false
        end
    end
    
    task.wait(0.2)
    isTeleporting = false
    return true
end

local function TeleportToSpecificCP(cpNumber)
    if isTeleporting then 
        Notify("AUTO SUMMIT", "Please wait, still teleporting...", "warning", 2)
        return false 
    end
    
    local success = TeleportToCP(cpNumber)
    if success then
        Notify("AUTO SUMMIT", "Teleported to CP" .. cpNumber, "success", 2)
    end
    return success
end

local function StartAutoSummit()
    if isTeleporting then 
        Notify("AUTO SUMMIT", "Please wait, still teleporting...", "warning", 2)
        return
    end
    
    currentCp = 1
    loopCount = loopCount + 1
    
    local targetNum = 41
    if selectedTargetCP and selectedTargetCP ~= "All CP" then
        targetNum = tonumber(selectedTargetCP:match("%d+")) or 41
    end
    
    Notify("AUTO SUMMIT", "Loop #" .. loopCount .. " - Starting from CP1 to " .. selectedTargetCP, "info", 2)
    
    task.spawn(function()
        while autoSummitEnabled and currentCp <= targetNum do
            if isTeleporting then
                task.wait(0.5)
            else
                Notify("AUTO SUMMIT", "Teleporting to CP" .. currentCp, "info", 1)
                TeleportToCP(currentCp)
                currentCp = currentCp + 1
                task.wait(cpDelay)
            end
        end
        
        if currentCp > targetNum and autoSummitEnabled then
            Notify("AUTO SUMMIT", "Reached " .. selectedTargetCP .. "! (Loop #" .. loopCount .. ")", "success", 2)
            Notify("AUTO SUMMIT", "Stopping...", "info", 2)
            autoSummitEnabled = false
        end
    end)
end

local function StopAutoSummit()
    autoSummitEnabled = false
    currentCp = 1
    loopCount = 0
end

local cpOptions = {}
for i = 1, 41 do
    table.insert(cpOptions, "CP" .. i)
end

AutoSummitV1:AddDropdown({
    Text = "Target CP",
    Options = cpOptions,
    Default = "CP41",
    Callback = function(option)
        selectedTargetCP = option
        Notify("AUTO SUMMIT", "Target CP set to: " .. option, "info", 2)
    end
})

AutoSummitV1:AddToggle({
    Text = "Auto Summit",
    Default = false,
    Callback = function(value)
        if value then
            autoSummitEnabled = true
            loopCount = 0
            StartAutoSummit()
            Notify("AUTO SUMMIT", "Auto Summit Mount Kicau Mania: Enabled", "success", 3)
        else
            StopAutoSummit()
            Notify("AUTO SUMMIT", "Auto Summit Mount Kicau Mania: Disabled", "info", 2)
        end
    end
})

AutoSummitV1:AddSlider({
    Text = "⏱️ Delay between CP (seconds)",
    Min = 1,
    Max = 5,
    Default = 1,
    Callback = function(value)
        cpDelay = value
        Notify("AUTO SUMMIT", "CP Delay set to: " .. string.format("%.1f", value) .. " seconds", "info", 1)
    end
})

AutoSummitV1:AddButton({
    Text = "📍 Teleport to Selected CP",
    Callback = function()
        local targetNum = tonumber(selectedTargetCP:match("%d+")) or 1
        TeleportToSpecificCP(targetNum)
    end
})

---V2 AUTO SUMMIT (Checkpoint 1 - Checkpoint 41)
local AutoSummitV2 = MainTab:AddSection("🏔️ Auto Summit V2")

local autoSummitEnabled2 = false
local currentCp2 = 1
local cpDelay2 = 1
local loopCount2 = 0
local selectedTargetCP2 = "Checkpoint 41"
local isTeleporting2 = false

local function TeleportToCP2(cpNumber)
    if isTeleporting2 then return false end
    isTeleporting2 = true
    
    local character = LocalPlayer.Character
    if not character then 
        isTeleporting2 = false
        return false 
    end
    
    task.wait(0.2)
    
    local checkpointParent = workspace:FindFirstChild("Checkpoint")
    if not checkpointParent then
        checkpointParent = workspace:FindFirstChild("Checkpoints")
    end
    
    if not checkpointParent then
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name:lower():find("checkpoint") then
                checkpointParent = child
                break
            end
        end
    end
    
    if not checkpointParent then
        Notify("AUTO SUMMIT", "Checkpoint folder not found!", "error", 2)
        isTeleporting2 = false
        return false
    end
    
    local cpName = "Checkpoint " .. cpNumber
    local cp = checkpointParent:FindFirstChild(cpName)
    
    if not cp then
        cpName = "Checkpoint" .. cpNumber
        cp = checkpointParent:FindFirstChild(cpName)
    end
    
    if not cp then
        cpName = "CP" .. cpNumber
        cp = checkpointParent:FindFirstChild(cpName)
    end
    
    if not cp then
        for _, child in ipairs(checkpointParent:GetChildren()) do
            local childName = child.Name:lower()
            if childName == "checkpoint " .. cpNumber or 
               childName == "checkpoint" .. cpNumber or 
               childName == "cp" .. cpNumber then
                cp = child
                break
            end
        end
    end
    
    if not cp then
        Notify("AUTO SUMMIT", "Checkpoint " .. cpNumber .. " not found!", "error", 2)
        isTeleporting2 = false
        return false
    end
    
    if cp:IsA("Model") then
        character:PivotTo(cp:GetPivot() + Vector3.new(0, 3, 0))
    elseif cp:IsA("BasePart") then
        character:PivotTo(cp.CFrame + Vector3.new(0, 3, 0))
    else
        local part = cp:FindFirstChildWhichIsA("BasePart", true)
        if part then
            character:PivotTo(part.CFrame + Vector3.new(0, 3, 0))
        else
            Notify("AUTO SUMMIT", "Target is not a Model or BasePart", "error", 2)
            isTeleporting2 = false
            return false
        end
    end
    
    task.wait(0.2)
    isTeleporting2 = false
    return true
end

local function TeleportToSpecificCP2(cpNumber)
    if isTeleporting2 then 
        Notify("AUTO SUMMIT", "Please wait, still teleporting...", "warning", 2)
        return false 
    end
    
    local success = TeleportToCP2(cpNumber)
    if success then
        Notify("AUTO SUMMIT", "Teleported to Checkpoint " .. cpNumber, "success", 2)
    end
    return success
end

local function StartAutoSummit2()
    if isTeleporting2 then 
        Notify("AUTO SUMMIT", "Please wait, still teleporting...", "warning", 2)
        return
    end
    
    currentCp2 = 1
    loopCount2 = loopCount2 + 1
    
    local targetNum = 41
    if selectedTargetCP2 and selectedTargetCP2 ~= "All Checkpoint" then
        targetNum = tonumber(selectedTargetCP2:match("%d+")) or 41
    end
    
    Notify("AUTO SUMMIT", "Loop #" .. loopCount2 .. " - Starting from Checkpoint 1 to " .. selectedTargetCP2, "info", 2)
    
    task.spawn(function()
        while autoSummitEnabled2 and currentCp2 <= targetNum do
            if isTeleporting2 then
                task.wait(0.5)
            else
                Notify("AUTO SUMMIT", "Teleporting to Checkpoint " .. currentCp2, "info", 1)
                TeleportToCP2(currentCp2)
                currentCp2 = currentCp2 + 1
                task.wait(cpDelay2)
            end
        end
        
        if currentCp2 > targetNum and autoSummitEnabled2 then
            Notify("AUTO SUMMIT", "Reached " .. selectedTargetCP2 .. "! (Loop #" .. loopCount2 .. ")", "success", 2)
            Notify("AUTO SUMMIT", "Stopping...", "info", 2)
            autoSummitEnabled2 = false
        end
    end)
end

local function StopAutoSummit2()
    autoSummitEnabled2 = false
    currentCp2 = 1
    loopCount2 = 0
end

local cpOptions2 = {}
for i = 1, 41 do
    table.insert(cpOptions2, "Checkpoint " .. i)
end

AutoSummitV2:AddDropdown({
    Text = "Target Checkpoint",
    Options = cpOptions2,
    Default = "Checkpoint 41",
    Callback = function(option)
        selectedTargetCP2 = option
        Notify("AUTO SUMMIT", "Target set to: " .. option, "info", 2)
    end
})

AutoSummitV2:AddToggle({
    Text = "Auto Summit",
    Default = false,
    Callback = function(value)
        if value then
            autoSummitEnabled2 = true
            loopCount2 = 0
            StartAutoSummit2()
            Notify("AUTO SUMMIT", "Auto Summit Mount Kicau Mania: Enabled", "success", 3)
        else
            StopAutoSummit2()
            Notify("AUTO SUMMIT", "Auto Summit Mount Kicau Mania: Disabled", "info", 2)
        end
    end
})

AutoSummitV2:AddSlider({
    Text = "⏱️ Delay between Checkpoint (seconds)",
    Min = 1,
    Max = 5,
    Default = 1,
    Callback = function(value)
        cpDelay2 = value
        Notify("AUTO SUMMIT", "Checkpoint Delay set to: " .. string.format("%.1f", value) .. " seconds", "info", 1)
    end
})

AutoSummitV2:AddButton({
    Text = "📍 Teleport to Selected Checkpoint",
    Callback = function()
        local targetNum = tonumber(selectedTargetCP2:match("%d+")) or 1
        TeleportToSpecificCP2(targetNum)
    end
})

--// TELEPORT AND SPECTATE PLAYER

local TeleportToPlayerSection = TeleportTab:AddSection("🎯 Teleport to Player")
local SpectateSection = TeleportTab:AddSection("👁️ Spectate Player")

local selectedTeleportPlayer = nil
local selectedSpectatePlayer = nil

local playerDropdown = nil
local spectateDropdown = nil

--// SPECTATE VARIABLES

local viewing = nil
local isSpectating = false
local originalCameraSubject = nil

local targetCharacterConnection = nil
local targetRemovingConnection = nil
local cameraChangedConnection = nil

--// PLAYER LIST

local function GetPlayerList()
    local list = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end

    table.sort(list)

    -- Biar dropdown tidak kosong
    if #list == 0 then
        table.insert(list, "No Players")
    end

    return list
end

-- Mendukung beberapa versi dropdown Anixly UI
local function UpdateDropdownOptions(dropdown, options)
    if not dropdown then
        return false
    end

    if typeof(dropdown.SetOptions) == "function" then
        local success = pcall(function()
            dropdown:SetOptions(options)
        end)

        if success then
            return true
        end
    end

    if typeof(dropdown.Refresh) == "function" then
        local success = pcall(function()
            dropdown:Refresh(options)
        end)

        if success then
            return true
        end
    end

    if typeof(dropdown.SetValues) == "function" then
        local success = pcall(function()
            dropdown:SetValues(options)
        end)

        if success then
            return true
        end
    end

    warn("Dropdown tidak mendukung SetOptions, Refresh, atau SetValues")
    return false
end

local function RefreshPlayerDropdowns()
    local list = GetPlayerList()

    UpdateDropdownOptions(playerDropdown, list)
    UpdateDropdownOptions(spectateDropdown, list)

    -- Reset pilihan teleport jika player sudah keluar
    if selectedTeleportPlayer
        and selectedTeleportPlayer ~= "No Players"
        and not Players:FindFirstChild(selectedTeleportPlayer) then

        selectedTeleportPlayer = nil
    end

    -- Reset pilihan spectate jika player sudah keluar
    if selectedSpectatePlayer
        and selectedSpectatePlayer ~= "No Players"
        and not Players:FindFirstChild(selectedSpectatePlayer) then

        selectedSpectatePlayer = nil
    end
end

--// TELEPORT DROPDOWN

playerDropdown = TeleportToPlayerSection:AddDropdown({
    Text = "Select Player",
    Options = GetPlayerList(),
    Default = nil,

    Callback = function(option)
        if option == "No Players" then
            selectedTeleportPlayer = nil
            return
        end

        selectedTeleportPlayer = option
        print("Selected teleport player:", option)
    end
})

--// TELEPORT BUTTON

TeleportToPlayerSection:AddButton({
    Text = "Teleport to Player",

    Callback = function()
        if not selectedTeleportPlayer
            or selectedTeleportPlayer == ""
            or selectedTeleportPlayer == "No Players" then

            Notify(
                "TELEPORT",
                "Please select a player first.",
                "warning",
                2
            )

            return
        end

        local target = Players:FindFirstChild(selectedTeleportPlayer)

        if not target then
            selectedTeleportPlayer = nil
            RefreshPlayerDropdowns()

            Notify(
                "TELEPORT",
                "Player sudah keluar dari server.",
                "error",
                2
            )

            return
        end

        local myCharacter =
            LocalPlayer.Character
            or LocalPlayer.CharacterAdded:Wait()

        local targetCharacter = target.Character

        local myRoot =
            myCharacter
            and myCharacter:FindFirstChild("HumanoidRootPart")

        local targetRoot =
            targetCharacter
            and targetCharacter:FindFirstChild("HumanoidRootPart")

        if not myRoot or not targetRoot then
            Notify(
                "TELEPORT",
                "Character target belum siap.",
                "error",
                2
            )

            return
        end

        myCharacter:PivotTo(
            targetRoot.CFrame * CFrame.new(0, 3, 3)
        )

        Notify(
            "TELEPORT",
            "Teleported to " .. target.Name,
            "success",
            2
        )
    end
})

--// SPECTATE FUNCTIONS

local function DisconnectSpectateConnections()
    if targetCharacterConnection then
        targetCharacterConnection:Disconnect()
        targetCharacterConnection = nil
    end

    if targetRemovingConnection then
        targetRemovingConnection:Disconnect()
        targetRemovingConnection = nil
    end

    if cameraChangedConnection then
        cameraChangedConnection:Disconnect()
        cameraChangedConnection = nil
    end
end

local function GetCharacterHumanoid(plr)
    local character = plr and plr.Character

    if not character then
        return nil
    end

    return character:FindFirstChildWhichIsA("Humanoid")
end

local function RestoreLocalCamera()
    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    local localHumanoid =
        GetCharacterHumanoid(LocalPlayer)

    if originalCameraSubject
        and originalCameraSubject.Parent then

        camera.CameraSubject = originalCameraSubject

    elseif localHumanoid then
        camera.CameraSubject = localHumanoid
    end
end

local function StopSpectate(showNotification)
    DisconnectSpectateConnections()

    RestoreLocalCamera()

    viewing = nil
    isSpectating = false

    if showNotification ~= false then
        Notify(
            "SPECTATE",
            "Stopped spectating",
            "info",
            2
        )
    end
end

local function SetSpectateTarget(target)
    if not isSpectating or viewing ~= target then
        return false
    end

    local camera = workspace.CurrentCamera
    local targetHumanoid = GetCharacterHumanoid(target)

    if not camera or not targetHumanoid then
        return false
    end

    camera.CameraSubject = targetHumanoid
    return true
end

local function StartSpectate(playerName)
    local target = Players:FindFirstChild(playerName)

    if not target or target == LocalPlayer then
        Notify(
            "SPECTATE",
            "Player not found!",
            "error",
            2
        )

        return false
    end

    local targetHumanoid = GetCharacterHumanoid(target)

    if not targetHumanoid then
        Notify(
            "SPECTATE",
            "Character target belum siap!",
            "error",
            2
        )

        return false
    end

    if isSpectating then
        StopSpectate(false)
    end

    local camera = workspace.CurrentCamera

    if not camera then
        Notify(
            "SPECTATE",
            "Camera tidak ditemukan!",
            "error",
            2
        )

        return false
    end

    originalCameraSubject = camera.CameraSubject
    viewing = target
    isSpectating = true

    camera.CameraSubject = targetHumanoid

    -- Saat target respawn, kamera otomatis pindah ke karakter barunya
    targetCharacterConnection = target.CharacterAdded:Connect(function(character)
        local humanoid =
            character:WaitForChild("Humanoid", 10)

        if humanoid
            and isSpectating
            and viewing == target then

            task.wait(0.2)

            local currentCamera = workspace.CurrentCamera

            if currentCamera then
                currentCamera.CameraSubject = humanoid
            end
        end
    end)

    -- Pastikan kamera tetap mengikuti target
    cameraChangedConnection =
        camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()

            if not isSpectating or viewing ~= target then
                return
            end

            local humanoid = GetCharacterHumanoid(target)

            if humanoid
                and camera.CameraSubject ~= humanoid then

                camera.CameraSubject = humanoid
            end
        end)

    Notify(
        "SPECTATE",
        "Now viewing " .. target.Name,
        "success",
        2
    )

    return true
end

--// SPECTATE DROPDOWN

spectateDropdown = SpectateSection:AddDropdown({
    Text = "Select Player to Spectate",
    Options = GetPlayerList(),
    Default = nil,

    Callback = function(option)
        if option == "No Players" then
            selectedSpectatePlayer = nil
            return
        end

        selectedSpectatePlayer = option
        print("Selected spectate player:", option)
    end
})

--// SPECTATE BUTTONS

SpectateSection:AddButton({
    Text = "Start Spectate",

    Callback = function()
        if not selectedSpectatePlayer
            or selectedSpectatePlayer == ""
            or selectedSpectatePlayer == "No Players" then

            Notify(
                "SPECTATE",
                "Please select a player first.",
                "warning",
                2
            )

            return
        end

        StartSpectate(selectedSpectatePlayer)
    end
})

SpectateSection:AddButton({
    Text = "Stop Spectate",

    Callback = function()
        StopSpectate(true)
    end
})

--// AUTO REFRESH PLAYER LIST

Players.PlayerAdded:Connect(function(plr)
    task.wait(0.3)
    RefreshPlayerDropdowns()

    Notify(
        "PLAYER LIST",
        plr.Name .. " joined the server.",
        "info",
        2
    )
end)

Players.PlayerRemoving:Connect(function(plr)
    if selectedTeleportPlayer == plr.Name then
        selectedTeleportPlayer = nil
    end

    if selectedSpectatePlayer == plr.Name then
        selectedSpectatePlayer = nil
    end

    if viewing == plr then
        StopSpectate(false)

        Notify(
            "SPECTATE",
            "Target left the server.",
            "warning",
            2
        )
    end

    task.defer(function()
        RefreshPlayerDropdowns()
    end)
end)

-- Kalau karakter sendiri respawn, hentikan spectate
LocalPlayer.CharacterAdded:Connect(function()
    if isSpectating then
        StopSpectate(false)
    end
end)

-- Refresh pertama kali setelah UI selesai dibuat
task.defer(function()
    RefreshPlayerDropdowns()
end)

--// UTILITY

local UtilitySection = UtilityTab:AddSection("🛡️ Anti Staff")

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

UtilitySection:AddToggle({
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

-- Hide Name Tag
local HideNameSection = MainTab:AddSection("👀 Hide Name Tag")

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

-- Anti Lag / Boost FPS
local AntiLagSection = UtilityTab:AddSection("⚡ Boost FPS & Visual")

local antiLagEnabled = false
local antiLagConnection = nil
local noFogEnabled = false
local noBrightEnabled = false
local originalFogEnd = nil
local originalBrightness = nil

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

local BypassSection = UtilityTab:AddSection("💬 Bypass Voice Chat")

local chatGui = nil
local voiceBypassEnabled = false

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

--// ANTI AFK AUTO ENABLE
local lastInput = tick()
local antiAFKConnection = nil

UIS.InputBegan:Connect(function() lastInput = tick() end)
UIS.InputChanged:Connect(function() lastInput = tick() end)

local function SimulateInput()
    UIS.InputBegan:Fire(Enum.KeyCode.W, Enum.UserInputState.Begin)
    task.wait(0.1)
    UIS.InputEnded:Fire(Enum.KeyCode.W, Enum.UserInputState.End)
end

local function StartAntiAFK()
    if antiAFKConnection then return end
    antiAFKConnection = RunService.Heartbeat:Connect(function()
        if tick() - lastInput > 50 then
            SimulateInput()
            lastInput = tick()
        end
    end)
end

StartAntiAFK()

print("🌸 Nyx Hub Loaded Successfully!")
print("💤 Anti AFK Active!")
print("🔥 Anti Cheat Bypass Active!")