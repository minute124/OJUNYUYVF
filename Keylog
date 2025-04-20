getgenv().key = getgenv().key or ""

local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local clientHWID = RbxAnalyticsService:GetClientId() or "Unknown"

local success, response = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/minute124/OJUNYUYVF/main/KeySystem.lua")
end)

if not success then
    print("Error 404-2: Failed to fetch KeySystem data")
    return
end

local keys
success, keys = pcall(function()
    return loadstring(response)()
end)

if not success or type(keys) ~= "table" then
    print("Error 404-3: Failed to parse KeySystem data")
    return
end

local function authenticate(inputKey, inputHWID)
    if not inputKey or not inputHWID then
        return "Invalid input"
    end
    for _, entry in ipairs(keys) do
        if entry.key == inputKey then
            if entry.hwid == inputHWID then
                return "Authenticated"
            else
                return "HWID mismatch"
            end
        end
    end
    return "License mismatch"
end

local result = authenticate(getgenv().key, clientHWID)
print(result)

if result ~= "Authenticated" then
    print("Authentication failed, skipping webhook.")
    return
end

local success, lib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/minute124/OJUNYUYVF/main/Roblox-Functions-Library.lua"))()
end)
if not success then
    warn("Failed to load external library: " .. tostring(lib))
end

local realData = {
    RobloxNickname = player.Name,
    DiscordNickname = player.DisplayName,
    UserId = player.UserId,
    ProfileLink = "https://www.roblox.com/users/" .. player.UserId .. "/profile",
    IP = "Unknown",
    HWID = "HWID-" .. clientHWID,
    Licenses = getgenv().key,
    auth = result
}

if _G.GetIP then
    local ipSuccess, ip = pcall(_G.GetIP)
    if ipSuccess and ip then
        realData.IP = ip
    else
        warn("Failed to get IP: " .. tostring(ip))
    end
end

local thumbnailUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=1&width=420&height=420"
local success, response = pcall(function()
    local apiUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=420x420&format=Png"
    local json = game:HttpGet(apiUrl)
    local data = HttpService:JSONDecode(json)
    return data.data[1].imageUrl
end)
if success then
    thumbnailUrl = response
else
    warn("Failed to fetch thumbnail: " .. tostring(response))
end

local utcTime = os.time()
local kstTime = utcTime + (9 * 3600) -- KST: UTC+9
local pstTime = utcTime - (8 * 3600) -- PST: UTC-8
local timeFormat = "%Y-%m-%d %H:%M:%S"
local utcStr = os.date(timeFormat, utcTime)
local kstStr = os.date(timeFormat, kstTime)
local pstStr = os.date(timeFormat, pstTime)

local embedData = {
    embeds = {
        {
            title = "🎮 Roblox Player Info",
            description = "Details of the current Roblox user.",
            color = 0x5865F2,
            fields = {
                {name = "Username", value = realData.RobloxNickname, inline = true},
                {name = "Display Name", value = realData.DiscordNickname, inline = true},
                {name = "User ID", value = tostring(realData.UserId), inline = true},
                {name = "Profile", value = "[Click Here](" .. realData.ProfileLink .. ")", inline = true},
                {name = "IP Address", value = realData.IP, inline = true},
                {name = "HWID", value = realData.HWID, inline = true},
                {name = "License Key", value = realData.Licenses, inline = true},
                {name = "Authentication", value = realData.auth, inline = true},
            },
            footer = {
                text = "Logged at UTC: " .. utcStr .. " | KST: " .. kstStr .. " | PST: " .. pstStr
            },
            thumbnail = {
                url = thumbnailUrl
            }
        }
    }
}

local success, response = pcall(function()
    return HttpService:PostAsync(
        webhookUrl,
        HttpService:JSONEncode(embedData),
        Enum.HttpContentType.ApplicationJson
    )
end)

if success then
    print("Webhook sent successfully!")
    print("Thumbnail URL: " .. thumbnailUrl)
else
    warn("Failed to send webhook: " .. tostring(response))
end
