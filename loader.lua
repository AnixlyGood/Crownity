repeat task.wait() until game:IsLoaded()

local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/Uilibary/refs/heads/main/AnixlyUi.lua"))()

local IMAGE_ID = "rbxassetid://2061475061"

AnixlyUI:ShowKeySystem({
    Title = "ANIXLY KEY",
    Subtitle = "Masukkan key untuk membuka Anixly Hub",
    Key = "anixly123",

    Callback = function(success)
        if not success then
            return
        end

        local Window = AnixlyUI:CreateWindow({
            Title = "Anixly Hub",
            Theme = "ANIXLY",

            MiniIcon = IMAGE_ID,
            Logo = IMAGE_ID,
            LogoText = "",

            Size = {
                Width = 520,
                Height = 390
            }
        })

        local MainTab = Window:CreateTab("Main", "rbxassetid://6023426945")
        local PlayerTab = Window:CreateTab("Player", "rbxassetid://6023426959")
        local MiscTab = Window:CreateTab("Misc", "rbxassetid://6023426926")

        local MainSection = MainTab:AddSection("Main Menu")

        MainSection:AddToggle({
            Text = "Auto Farm",
            Default = false,
            Callback = function(value)
                AnixlyUI:ShowNotification({
                    Title = "Anixly Notification",
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

        local MiscSection = MiscTab:AddSection("Info")

        MiscSection:AddImage({
            Image = IMAGE_ID,
            Text = "ANIXLY HUB",
            Height = 150
        })
        })
    end
})