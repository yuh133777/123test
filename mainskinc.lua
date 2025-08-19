-- Function to safely execute a loadstring with HttpGet and timeout
local function SafeLoadScript(url, timeout)
    local co = coroutine.create(function()
        pcall(function()
            local response = game:HttpGet(url)
            if response then
                local func = loadstring(response)
                if func then
                    func()
                end
            end
        end)
    end)

    coroutine.resume(co)
    local startTime = tick()
    while coroutine.status(co) ~= "dead" and (tick() - startTime) < timeout do
        task.wait()
    end

    if coroutine.status(co) ~= "dead" then
        coroutine.close(co)
    end
end

-- First script: Load the Changer with 10-second timeout
SafeLoadScript("https://raw.githubusercontent.com/MMoonDzn/AuroraChanger/refs/heads/main/loader.lua", 10)

-- Wait 4 seconds after first script
task.wait(4)

-- Second script: Load giveframesname.lua
SafeLoadScript("https://github.com/yuh133777/123test/raw/refs/heads/main/giveframesname.lua", 10)

-- Wait 3 seconds after second script
task.wait(3)

-- Third script: Load deletecomponents.lua
SafeLoadScript("https://github.com/yuh133777/123test/raw/refs/heads/main/deletecomponents.lua", 10)
