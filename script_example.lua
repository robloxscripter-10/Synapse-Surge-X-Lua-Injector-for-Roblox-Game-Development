-- Synapse Surge X Example Script
-- Demonstrates auto-farming, speed boost, and UI toggle

-- Configuration
local config = {
    autoFarm = false,
    speedBoost = false,
    walkSpeed = 50,       -- desired walk speed
    farmInterval = 1      -- seconds between farm actions
}

-- Services
local Players       = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService    = game:GetService("RunService")
local LocalPlayer   = Players.LocalPlayer

-- Auto-Farm Function
local function farm()
    while config.autoFarm do
        local collectEvent = ReplicatedStorage:WaitForChild("Events"):FindFirstChild("Collect")
        if collectEvent then
            collectEvent:FireServer()
        end
        task.wait(config.farmInterval)
    end
end

-- Speed Boost Function
local function applySpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = config.speedBoost and config.walkSpeed or 16
    end
end

-- UI Setup
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "SurgeXUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 10, 0.5, -60)
frame.BackgroundTransparency = 0.3

local function makeButton(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Buttons
makeButton("Toggle Auto-Farm", 10, function()
    config.autoFarm = not config.autoFarm
    if config.autoFarm then
        task.spawn(farm)
    end
end)

makeButton("Toggle Speed Boost", 50, function()
    config.speedBoost = not config.speedBoost
    applySpeed()
end)

-- Keep speed applied on respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    applySpeed()
end)

-- Keybind: Press "H" to hide/show UI
local uiVisible = true
RunService.RenderStepped:Connect(function()
    if UserInputService:IsKeyDown(Enum.KeyCode.H) then
        if uiVisible then
            frame.Visible = false
        else
            frame.Visible = true
        end
        uiVisible = not uiVisible
        task.wait(0.3)  -- debounce
    end
end)

print("Synapse Surge X script loaded! Press buttons to control features.") 
