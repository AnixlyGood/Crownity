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

local DashboardSection = DashboardTab:AddSection("Information")

DashboardSection:AddLabel("Welcome to Anixly Hub.")
DashboardSection:AddLabel("Version: 1.0.0")
DashboardSection:AddLabel("Status: Online")
DashboardSection:AddLabel("Developer: AnixlyGood")
DashboardSection:AddLabel("Gunakan menu Main untuk fitur utama.")

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

MainSection:AddToggle({
    Text = "Example Toggle",
    Default = false,
    Callback = function(value)
        AnixlyUI:ShowNotification({
            Title = "TOGGLE",
            Message = "Toggle sekarang: " .. tostring(value),
            Theme = "info",
            Icon = IMAGE_ID,
            Duration = 2
        })
    end
})

MainSection:AddDropdown({
    Text = "Pilih Mode",
    Options = {"Normal", "Fast", "Ultra"},
    Default = "Normal",
    Callback = function(option)
        print("Mode:", option)

        AnixlyUI:ShowNotification({
            Title = "MODE",
            Message = "Mode dipilih: " .. tostring(option),
            Theme = "success",
            Icon = IMAGE_ID,
            Duration = 2
        })
    end
})

MainSection:AddButton({
    Text = "Test Notification",
    Callback = function()
        AnixlyUI:ShowNotification({
            Title = "SUCCESS",
            Message = "Notification berhasil jalan.",
            Theme = "success",
            Icon = IMAGE_ID,
            Duration = 3
        })
    end
})