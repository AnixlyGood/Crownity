local games = {
    [136486728723265] = "https://raw.githubusercontent.com/AnixlyGood/Crownity/refs/heads/main/MountSalora.lua", -- Mount Salora
}

local currentPlaceID = game.PlaceId
local currentUniverseID = game.GameId

local scriptURL = games[currentUniverseID] or games[currentPlaceID]

if scriptURL then
    print("Anixly Hub: Loading script for ID " .. (games[currentUniverseID] and "Universe" or "Place"))
    loadstring(game:HttpGet(scriptURL))()
else
    local msg = "\nMap not supported yet!\nPlaceId: " .. tostring(currentPlaceID) .. "\nUniverseId: " .. tostring(currentUniverseID)
    game.Players.LocalPlayer:Kick(msg)
    print(msg)
end