local placeId = game.PlaceId

local games = {
    [77393318863643] = "https://raw.githubusercontent.com/spectrumxx/mainloader/refs/heads/main/AuraAscension.lua",
    [4520749081]     = "https://raw.githubusercontent.com/spectrumxx/mainfarm/refs/heads/main/loader.lua",
    [77747658251236] = "https://raw.githubusercontent.com/spectrumxx/SailorPiece/refs/heads/main/mainloader.lua",
}

local url = games[placeId]

if url then
    loadstring(game:HttpGet(url))()
else
    warn("[SPECTRUM X] Jogo não suportado. PlaceId: " .. tostring(placeId))
end
