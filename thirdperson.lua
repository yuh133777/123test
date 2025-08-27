-- Rotrox Third Person Camera Toggle Script
-- Educational purposes only, assuming user owns the game source code

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RotroxThirdPersonGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false -- Persist GUI across respawns

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui

local checkboxButton = Instance.new("TextButton")
checkboxButton.Size = UDim2.new(0, 120, 0, 30)
checkboxButton.Position = UDim2.new(0, 15, 0, 10)
checkboxButton.Text = "Third Person"
checkboxButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
checkboxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
checkboxButton.Parent = frame

-- Camera Variables
local isThirdPerson = false
local character, humanoid, rootPart
local cameraOffset = Vector3.new(2, 2, 8) -- Over the right shoulder
local mouseSensitivity = 0.2
local yaw = 0
local pitch = 0
local maxPitch = 80
local originalCameraType = camera.CameraType
local originalCameraSubject = camera.CameraSubject
local originalMouseBehavior = Enum.MouseBehavior.LockCenter

-- Function to update character references
local function updateReferences(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    
    -- Apply third-person settings if enabled
    if isThirdPerson and humanoid then
        camera.CameraType = Enum.CameraType.Scriptable
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        humanoid.AutoRotate = false
        local _, yRot, _ = rootPart.CFrame:ToEulerAnglesXYZ()
        yaw = math.deg(yRot)
        pitch = 0
    end
end

-- Toggle Function
local function toggleThirdPerson()
    isThirdPerson = not isThirdPerson
    if isThirdPerson then
        checkboxButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green when active
        if character and humanoid and rootPart then
            camera.CameraType = Enum.CameraType.Scriptable
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            humanoid.AutoRotate = false
            local _, yRot, _ = rootPart.CFrame:ToEulerAnglesXYZ()
            yaw = math.deg(yRot)
            pitch = 0
        end
    else
        checkboxButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gray when inactive
        camera.CameraType = originalCameraType
        camera.CameraSubject = humanoid or originalCameraSubject
        UserInputService.MouseBehavior = originalMouseBehavior
        if humanoid then
            humanoid.AutoRotate = true
        end
    end
end

-- Refresh Third Person on Death
local function refreshOnDeath()
    if isThirdPerson and humanoid then
        -- Disable third-person
        camera.CameraType = originalCameraType
        camera.CameraSubject = humanoid or originalCameraSubject
        UserInputService.MouseBehavior = originalMouseBehavior
        humanoid.AutoRotate = true
        checkboxButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        -- Wait for respawn and re-enable with delay
        local newChar = player.CharacterAdded:Wait()
        task.wait(2.0) -- Increased delay to ensure character fully loads
        updateReferences(newChar)
        if isThirdPerson and newChar then
            humanoid = newChar:WaitForChild("Humanoid")
            rootPart = newChar:WaitForChild("HumanoidRootPart")
            camera.CameraType = Enum.CameraType.Scriptable
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            humanoid.AutoRotate = false
            local _, yRot, _ = rootPart.CFrame:ToEulerAnglesXYZ()
            yaw = math.deg(yRot)
            pitch = 0
            checkboxButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
end

-- Mouse Movement Handling
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isThirdPerson then
        local delta = input.Delta
        yaw = yaw - delta.X * mouseSensitivity
        pitch = math.clamp(pitch - delta.Y * mouseSensitivity, -maxPitch, maxPitch)
    end
end)

-- Camera Update Function
RunService.RenderStepped:Connect(function()
    if isThirdPerson and character and rootPart and humanoid then
        local rotationCFrame = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
        local focusPos = rootPart.Position + Vector3.new(0, 2, 0)
        local camPos = focusPos - rotationCFrame.LookVector * cameraOffset.Z + rotationCFrame.RightVector * cameraOffset.X + rotationCFrame.UpVector * cameraOffset.Y
        camera.CFrame = CFrame.lookAt(camPos, focusPos)
    elseif not isThirdPerson and character and humanoid then
        camera.CameraSubject = humanoid -- Ensure camera follows character in first-person
    end
end)

-- Connect to CharacterAdded for respawn handling
player.CharacterAdded:Connect(function(char)
    updateReferences(char)
end)

-- Initial character setup
if player.Character then
    updateReferences(player.Character)
end

-- Button Click Event
checkboxButton.MouseButton1Click:Connect(toggleThirdPerson)

-- Detect death and refresh
if character and humanoid then
    humanoid.Died:Connect(refreshOnDeath)
end
player.CharacterAdded:Connect(function(char)
    updateReferences(char)
    if char and char:WaitForChild("Humanoid") then
        char:WaitForChild("Humanoid").Died:Connect(refreshOnDeath)
    end
end)

-- Ensure GUI is visible and initial mouse behavior
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
UserInputService.MouseBehavior = originalMouseBehavior

-- Cleanup on player removal
player.CharacterRemoving:Connect(function()
    -- Do not disable third-person on death unless triggered by refresh
end)
