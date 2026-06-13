repeat task.wait() until game:IsLoaded()

local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/Uilibary/refs/heads/main/AnixlyUi.lua"))()

local IMAGE_ID = "rbxassetid://2061475061"

local Window = AnixlyUI:CreateWindow({
    Title = "Anixly Hub",
    Subtitle = "Version 1.0.0",
    Theme = "ANIXLY",

    MiniIcon = IMAGE_ID,
    Logo = IMAGE_ID,

    Size = {
        Width = 540,
        Height = 405
    }
})

local DashboardTab = Window:CreateTab("Dashboard", "rbxassetid://6023426945")
local MainTab = Window:CreateTab("Main", "rbxassetid://6023426926")
local ESPTab = Window:CreateTab("ESP", "rbxassetid://6023426926")

local DashboardSection = DashboardTab:AddSection("Information")

DashboardSection:AddLabel("Welcome to Anixly Hub.")
DashboardSection:AddLabel("Version: 1.0.0")
DashboardSection:AddLabel("Status: Online")

DashboardSection:AddButton({
    Text = "Show Info",
    Callback = function()
        AnixlyUI:ShowNotification({
            Title = "ANIXLY HUB",
            Message = "Anixly Hub v1.0.0 berhasil dimuat.",
            Theme = "info",
            Icon = IMAGE_ID,
            Duration = 3
        })
    end
})

local MainSection = MainTab:AddSection("Main Menu")

-- Noclip yang berfungsi
local noclipEnabled = false
local noclipConnection = nil

function EnableNoclip()
    if noclipConnection then return end
    noclipConnection = game:GetService("RunService").Stepped:Connect(function()
        if noclipEnabled and game.Players.LocalPlayer.Character then
            local character = game.Players.LocalPlayer.Character
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function DisableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if game.Players.LocalPlayer.Character then
        local character = game.Players.LocalPlayer.Character
        for _, part in ipairs(character:GetDescendants()) do
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
            AnixlyUI:ShowNotification({
                Title = "NOCLIP",
                Message = "Noclip: Enabled",
                Theme = "success",
                Icon = IMAGE_ID,
                Duration = 2
            })
        else
            DisableNoclip()
            AnixlyUI:ShowNotification({
                Title = "NOCLIP",
                Message = "Noclip: Disabled",
                Theme = "info",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

MainSection:AddDropdown({
    Text = "Select Teleport Cp",
    Options = {"Cp1", "Fast", "Ultra"},
    Default = "Normal",
    Callback = function(option)
        print("Mode:", option)

        AnixlyUI:ShowNotification({
            Title = "Teleport Cp",
            Message = "Cp: " .. tostring(option),
            Theme = "success",
            Icon = IMAGE_ID,
            Duration = 2
        })
    end
})

-- ESP Section
local ESPSection = ESPTab:AddSection("ESP Settings")

local espEnabled = false
local espObjects = {}
local playerList = {}

-- Fungsi untuk membuat ESP
local function CreateESP(player)
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Warna merah untuk musuh/enemy
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Adornee = player.Character
    highlight.Parent = player.Character
    
    -- BillBoardGui untuk nama dan jarak
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character:FindFirstChild("HumanoidRootPart") or player.Character
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "NameLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Text = player.Name
    textLabel.Parent = billboard
    
    return {highlight = highlight, billboard = billboard, textLabel = textLabel}
end

-- Fungsi untuk update jarak
local function UpdateDistance()
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer or not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local localPos = localPlayer.Character.HumanoidRootPart.Position
    
    for _, player in ipairs(playerList) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local espObj = espObjects[player]
            if espObj and espObj.textLabel then
                local distance = (localPos - player.Character.HumanoidRootPart.Position).Magnitude
                local formattedDistance = string.format("%.1f", distance)
                espObj.textLabel.Text = player.Name .. " [" .. formattedDistance .. "m]"
                
                -- Ubah warna berdasarkan jarak
                if distance < 20 then
                    espObj.textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Merah (dekat)
                elseif distance < 50 then
                    espObj.textLabel.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange (sedang)
                else
                    espObj.textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Putih (jauh)
                end
            end
        end
    end
end

-- Fungsi untuk menghapus ESP
local function RemoveESP(player)
    local espObj = espObjects[player]
    if espObj then
        if espObj.highlight then espObj.highlight:Destroy() end
        if espObj.billboard then espObj.billboard:Destroy() end
        espObjects[player] = nil
    end
end

-- Fungsi untuk membersihkan semua ESP
local function ClearAllESP()
    for player, espObj in pairs(espObjects) do
        if espObj.highlight then espObj.highlight:Destroy() end
        if espObj.billboard then espObj.billboard:Destroy() end
    end
    espObjects = {}
end

-- Fungsi untuk update semua ESP
local function UpdateAllESP()
    if not espEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            if not espObjects[player] and player.Character then
                local espObj = CreateESP(player)
                if espObj then
                    espObjects[player] = espObj
                end
            elseif espObjects[player] and (not player.Character or not player.Character.Parent) then
                RemoveESP(player)
            end
        end
    end
end

-- ESP Toggle
ESPSection:AddToggle({
    Text = "Enable ESP",
    Default = false,
    Callback = function(value)
        espEnabled = value
        
        if value then
            -- Update player list
            playerList = {}
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    table.insert(playerList, player)
                end
            end
            
            -- Buat ESP untuk semua pemain
            UpdateAllESP()
            
            -- Update jarak setiap detik
            spawn(function()
                while espEnabled do
                    UpdateDistance()
                    task.wait(0.5)
                end
            end)
            
            -- Monitor karakter yang masuk/keluar
            game.Players.PlayerAdded:Connect(function(player)
                if espEnabled and player ~= game.Players.LocalPlayer then
                    player.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        if espEnabled and player.Character then
                            if espObjects[player] then RemoveESP(player) end
                            local espObj = CreateESP(player)
                            if espObj then espObjects[player] = espObj end
                        end
                    end)
                end
            end)
            
            game.Players.PlayerRemoving:Connect(function(player)
                if espEnabled then
                    RemoveESP(player)
                end
            end)
            
            AnixlyUI:ShowNotification({
                Title = "ESP",
                Message = "ESP Enabled",
                Theme = "success",
                Icon = IMAGE_ID,
                Duration = 2
            })
        else
            ClearAllESP()
            AnixlyUI:ShowNotification({
                Title = "ESP",
                Message = "ESP Disabled",
                Theme = "info",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

-- Pengaturan warna ESP
ESPSection:AddColorPicker({
    Text = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        for _, espObj in pairs(espObjects) do
            if espObj.highlight then
                espObj.highlight.FillColor = color
            end
        end
    end
})

-- Tombol refresh ESP
ESPSection:AddButton({
    Text = "Refresh ESP",
    Callback = function()
        if espEnabled then
            ClearAllESP()
            task.wait(0.5)
            UpdateAllESP()
            AnixlyUI:ShowNotification({
                Title = "ESP",
                Message = "ESP Refreshed",
                Theme = "success",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

-- Auto update karakter untuk ESP
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if espEnabled then
        ClearAllESP()
        task.wait(0.5)
        UpdateAllESP()
    end
end)