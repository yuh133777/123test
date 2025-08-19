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

-- Function to safely find and destroy an object
local function SafeDestroy(object, description)
    if object then
        object:Destroy()
        print("✅ Successfully deleted: " .. description)
    else
        warn("⚠️ Could not find: " .. description)
    end
end

-- 1. Delete Frame3 in ScreenGui
SafeDestroy(ScreenGui:FindFirstChild("Frame3"), "Frame3 (root level)")

-- 2. Delete Frame467 in nested structure
local function FindDeepFrame(startFrame, path)
    local current = startFrame
    for _, name in ipairs(path) do
        current = current and current:FindFirstChild(name)
    end
    return current
end

local scrollingFrame1 = FindDeepFrame(ScreenGui, {"Frame17", "Frame18", "Frame19", "Frame20", "Frame28", "Frame432", "ScrollingFrame"})
SafeDestroy(scrollingFrame1 and scrollingFrame1:FindFirstChild("Frame467"), "Frame467 in first ScrollingFrame")

-- 3. Delete Frame440 in second ScrollingFrame
local scrollingFrame2 = FindDeepFrame(ScreenGui, {"Frame17", "Frame18", "Frame19", "Frame20", "Frame28", "Frame432", "ScrollingFrame"})
SafeDestroy(scrollingFrame2 and scrollingFrame2:FindFirstChild("Frame440"), "Frame440 in second ScrollingFrame")

-- 4. Delete TextLabel in Frame18
local frame18 = FindDeepFrame(ScreenGui, {"Frame17", "Frame18"})
if frame18 then
    for _, child in ipairs(frame18:GetChildren()) do
        if child:IsA("TextLabel") and child.Position == UDim2.new(0.5, 0, 0, 0) then
            SafeDestroy(child, "TextLabel in Frame18")
            break
        end
    end
end

-- 5. Delete Frame463 in complex nested structure
local scrollingFrame3 = FindDeepFrame(ScreenGui, {"Frame17", "Frame18", "Frame19", "Frame20", "Frame28", "Frame432", "ScrollingFrame"})
local frame452 = scrollingFrame3 and scrollingFrame3:FindFirstChild("Frame452")
local frame453 = frame452 and frame452:FindFirstChild("Frame453")
local frame455 = frame453 and frame453:FindFirstChild("Frame455")
SafeDestroy(frame455 and frame455:FindFirstChild("Frame463"), "Frame463 in nested structure")

print("\n✨ All modifications attempted. Check output for results.")
