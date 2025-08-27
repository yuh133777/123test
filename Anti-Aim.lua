-- Anti-Aim
local antiAimEnabled = false
local spinDirection = 1
local spinSpeed = 50
local lastSwitch = tick()

createCheckbox("Anti-Aim", UDim2.new(0, 10, 0, 370), function(state)
    antiAimEnabled = state
    print("Anti-Aim toggled:", state)
end)
print("Anti-Aim toggle created")

RunService.Heartbeat:Connect(function()
    if antiAimEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        local head = LocalPlayer.Character:FindFirstChild("Head")
        local humanoid = LocalPlayer.Character.Humanoid

        humanoid.PlatformStand = false
        humanoid.Jump = false
        humanoid.AutoRotate = false

        if head then
            local neck = head:FindFirstChild("Neck", true)
            if neck and neck:IsA("Motor6D") then
                neck.C0 = CFrame.new(0, 1, 0) * CFrame.Angles(math.rad(-90), 0, 0)
            end
        end

        if tick() - lastSwitch > 2 then
            spinDirection = math.random() > 0.5 and 1 or -1
            lastSwitch = tick()
        end

        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * spinDirection), 0)
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        humanoid.AutoRotate = true
        local head = LocalPlayer.Character:FindFirstChild("Head")
        if head then
            local neck = head:FindFirstChild("Neck", true)
            if neck and neck:IsA("Motor6D") then
                neck.C0 = CFrame.new(0, 1, 0)
            end
        end
    end
end)
print("Anti-Aim loop set up")
