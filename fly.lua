--// Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Hacker vs Roblox | Mods",
    LoadingTitle = "Loading Mods...",
    LoadingSubtitle = "Made by You",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "HackerVsRobloxUI"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("🏠 Main", nil)
local FlySection = MainTab:CreateSection("Fly Module")

local flying = false
local flySpeed = 10
local verticalSpeed = 5
local bodyGyro, bodyVelocity
local UIS = game:GetService("UserInputService")

--// Stop Fly
local function stopFly()
    local char = game.Players.LocalPlayer.Character
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    end
end

--// Start Fly
local function startFly()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame

    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    -- Disable falling animation
    hum:ChangeState(Enum.HumanoidStateType.Physics)

    local up = false
    local down = false
    local moveVec = Vector3.zero

    -- Mobile button compatibility
    local inputVec = Vector3.zero

    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.E then up = true end
        if input.KeyCode == Enum.KeyCode.Q then down = true end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.E then up = false end
        if input.KeyCode == Enum.KeyCode.Q then down = false end
    end)

    task.spawn(function()
        while flying and char and hrp and hum do
            local horizontal = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then horizontal = horizontal + Vector3.new(0, 0, -1) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then horizontal = horizontal + Vector3.new(0, 0, 1) end
            if UIS:IsKeyDown(Enum.KeyCode.A) then horizontal = horizontal + Vector3.new(-1, 0, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.D) then horizontal = horizontal + Vector3.new(1, 0, 0) end

            if horizontal.Magnitude > 0 then
                horizontal = horizontal.Unit * flySpeed
            end

            moveVec = Vector3.zero
            if up then moveVec = moveVec + Vector3.new(0, verticalSpeed, 0) end
            if down then moveVec = moveVec - Vector3.new(0, verticalSpeed, 0) end

            bodyVelocity.Velocity = horizontal + moveVec
            bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(0, 0, -1))
            task.wait()
        end
    end)
end

--// Toggle Fly
local FlyToggle = MainTab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Callback = function(Value)
        flying = Value
        if flying then startFly() else stopFly() end
    end,
})

--// Speed Sliders
MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(Value) flySpeed = Value end
})
MainTab:CreateSlider({
    Name = "Vertical Speed",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(Value) verticalSpeed = Value end
})

--// No Cooldown Bypass
MainTab:CreateToggle({
    Name = "No Cooldown",
    CurrentValue = false,
    Callback = function(Value)
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and getfenv(v).script and not is_synapse_function(v) then
                for i, const in pairs(debug.getconstants(v)) do
                    if tostring(const):lower():find("cooldown") then
                        debug.setconstant(v, i, 0)
                    end
                end
            end
        end
    end
})

--// Mobile UI Buttons
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local flyGui = Instance.new("ScreenGui", playerGui)
flyGui.Name = "FlyControlGui"
flyGui.ResetOnSpawn = false

-- Fly Shortcut
local shortcut = Instance.new("TextButton")
shortcut.Size = UDim2.new(0, 100, 0, 40)
shortcut.Position = UDim2.new(0, 10, 0, 50)
shortcut.Text = "Fly"
shortcut.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
shortcut.TextColor3 = Color3.fromRGB(255, 255, 255)
shortcut.Parent = flyGui
shortcut.MouseButton1Click:Connect(function()
    FlyToggle:Set(true)
end)

-- Up Button
local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0, 60, 0, 40)
upBtn.Position = UDim2.new(1, -70, 1, -140)
upBtn.AnchorPoint = Vector2.new(0, 0)
upBtn.Text = "Up"
upBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 180)
upBtn.TextColor3 = Color3.new(1,1,1)
upBtn.Parent = flyGui
upBtn.MouseButton1Down:Connect(function() _G.up = true end)
upBtn.MouseButton1Up:Connect(function() _G.up = false end)

-- Down Button
local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, 60, 0, 40)
downBtn.Position = UDim2.new(1, -70, 1, -90)
downBtn.AnchorPoint = Vector2.new(0, 0)
downBtn.Text = "Down"
downBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
downBtn.TextColor3 = Color3.new(1,1,1)
downBtn.Parent = flyGui
downBtn.MouseButton1Down:Connect(function() _G.down = true end)
downBtn.MouseButton1Up:Connect(function() _G.down = false end)

-- Link to fly logic
task.spawn(function()
    while true do
        if flying then
            _G.up = _G.up or false
            _G.down = _G.down or false
        end
        wait()
    end
end)
