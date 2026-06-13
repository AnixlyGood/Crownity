repeat task.wait() until game:IsLoaded()

local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/Uilibary/refs/heads/main/AnixlyUi.lua"))()

local IMAGE_ID = "rbxassetid://2061475061"

AnixlyUI:ShowKeySystem({
    Title = "ANIXLY KEY",
    Subtitle = "Masukkan key untuk membuka Anixly Hub",
    Key = "anixly123",
    Icon = IMAGE_ID,

    Callback = function(success)
        if not success then
            return
        end

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

        local MainTab = Window:CreateTab("Main", "rbxassetid://6023426945")
        local PlayerTab = Window:CreateTab("Player", "rbxassetid://6023426959")
        local InfoTab = Window:CreateTab("Info", "rbxassetid://6023426926")

        local MainSection = MainTab:AddSection("Main Menu")

        MainSection:AddToggle({
            Text = "Auto Farm",
            Default = false,
            Callback = function(value)
                AnixlyUI:ShowNotification({
                    Title = "ANIXLY",
                    Message = "Auto Farm: " .. tostring(value),
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
            end
        })

        MainSection:AddButton({
            Text = "Test Notification",
            Callback = function()
                AnixlyUI:ShowNotification({
                    Title = "SUCCESS",
                    Message = "Anixly UI v1.0.0 berhasil jalan.",
                    Theme = "success",
                    Icon = IMAGE_ID,
                    Duration = 3
                })
            end
        })

        local PlayerSection = PlayerTab:AddSection("Player Settings")

        PlayerSection:AddSlider({
            Text = "Speed Value",
            Min = 1,
            Max = 100,
            Default = 16,
            Callback = function(value)
                print("Speed:", value)
            end
        })

        PlayerSection:AddKeybind({
            Text = "Open Key",
            Default = "RightShift",
            Callback = function(key)
                print("Keybind diganti:", key)
            end,
            Pressed = function()
                print("Keybind ditekan")
            end
        })

        local Progress = PlayerSection:AddProgressBar({
            Text = "Loading Bar"
        })

        PlayerSection:AddButton({
            Text = "Test Progress",
            Callback = function()
                for i = 0, 100, 10 do
                    Progress:SetProgress(i)
                    task.wait(0.1)
                end
            end
        })

        local InfoSection = InfoTab:AddSection("Dashboard")

        InfoSection:AddImage({
            Image = IMAGE_ID,
            Text = "ANIXLY HUB",
            Height = 170
        })

        InfoSection:AddLabel("Status: Online")
        InfoSection:AddLabel("Version: 1.0.0")
        InfoSection:AddLabel("Key: Verified")

        InfoSection:AddButton({
            Text = "Info Notification",
            Callback = function()
                AnixlyUI:ShowNotification({
                    Title = "INFO",
                    Message = "Ini tab Info model baru.",
                    Theme = "info",
                    Icon = IMAGE_ID,
                    Duration = 3
                })
            end
        })
    end
})
