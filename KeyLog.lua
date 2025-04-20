local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local clientHWID = RbxAnalyticsService:GetClientId()

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

-- 인증 실행
local result = authenticate(getgenv().key, clientHWID)
print(result)
