local maxAttempts = 10
local attempt = 0
local ScreenGui = nil

repeat
    attempt += 1
    ScreenGui = game:GetService("CoreGui"):FindFirstChild("ScreenGui")
    task.wait(0.3)
until ScreenGui or attempt >= maxAttempts

if not ScreenGui then
    warn("ERROR: ScreenGui not found after 3 seconds!")
    return
end

-- Function to recursively rename ALL frames
local frameCount = 0
local function RenameFrames(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Frame") then
            frameCount += 1
            local oldName = child.Name
            child.Name = "Frame" .. frameCount
            print(`Renamed [{oldName}] → [Frame{frameCount}]`)
        end
        RenameFrames(child) -- Recursively check children
    end
end

-- Execute renaming
RenameFrames(ScreenGui)
print(`\nSUCCESS! Renamed {frameCount} frames.`)

-- Optional: Highlight renamed frames (for visual confirmation)
for i = 1, frameCount do
    local frame = ScreenGui:FindFirstChild("Frame" .. i)
    if frame then
        frame.BackgroundColor3 = Color3.fromRGB(math.random(50, 200), 0, 0) -- Red tint for visibility
    end
end
