-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Hacker vs Roblox | Mods",
    LoadingTitle = "Loading Mods...",
    LoadingSubtitle = "Made by H",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "HackerVsRobloxUI"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("🏠 Main", nil)

-- Fly Section
local FlySection = MainTab:CreateSection("Fly Module")

-- Variables
local flying = false
local flySpeed = 10
local verticalSpeed = 5
local bodyGyro, bodyVelocity

-- Fly Function
local function startFly()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = char.HumanoidRootPart.CFrame
    bodyGyro.Parent = char.HumanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.velocity = Vector3.zero
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = char.HumanoidRootPart

    local UIS = game:GetService("UserInputService")
    local up = false
    local down = false

    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.E then
            up = true
        elseif input.KeyCode == Enum.KeyCode.Q then
            down = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.E then
            up = false
        elseif input.KeyCode == Enum.KeyCode.Q then
            down = false
        end
    end)

    -- Motion logic
    task.spawn(function()
        while flying and char and char:FindFirstChild("HumanoidRootPart") do
            bodyGyro.CFrame = CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + Vector3.new(0, 0, -1))

            local move = Vector3.zero
            if up then move = move + Vector3.new(0, verticalSpeed, 0) end
            if down then move = move - Vector3.new(0, verticalSpeed, 0) end

            local inputVec = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then inputVec += Vector3.new(0, 0, -1) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then inputVec += Vector3.new(0, 0, 1) end
            if UIS:IsKeyDown(Enum.KeyCode.A) then inputVec += Vector3.new(-1, 0, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.D) then inputVec += Vector3.new(1, 0, 0) end

            if inputVec.Magnitude > 0 then
                inputVec = inputVec.Unit * flySpeed
            end

            bodyVelocity.Velocity = move + inputVec
            task.wait()
        end
    end)
end

local function stopFly()
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
end

-- Fly Toggle
local FlyToggle = MainTab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Callback = function(Value)
        flying = Value
        if flying then
            startFly()
        else
            stopFly()
        end
    end
})

-- Speed Sliders
MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(Value)
        flySpeed = Value
    end
})

MainTab:CreateSlider({
    Name = "Vertical Speed",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(Value)
        verticalSpeed = Value
    end
})

-- No Cooldown Toggle
MainTab:CreateToggle({
    Name = "No Cooldown",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, v in pairs(getgc(true)) do
                if type(v) == "function" and not is_synapse_function(v) then
                    local consts = debug.getconstants(v)
                    for i, const in ipairs(consts) do
                        if tostring(const):lower():find("cooldown") then
                            pcall(function()
                                debug.setconstant(v, i, 0)
                            end)
                        end
                    end
                end
            end
        end
    end
})

-- Fly Shortcut GUI Button
local CoreGui = game:GetService("CoreGui")
local shortcutGui = Instance.new("ScreenGui", CoreGui)
shortcutGui.Name = "FlyShortcutGui"
shortcutGui.ResetOnSpawn = false

local flyShortcutButton = Instance.new("TextButton")
flyShortcutButton.Size = UDim2.new(0, 80, 0, 40)
flyShortcutButton.Position = UDim2.new(0, 10, 0, 50)
flyShortcutButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyShortcutButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyShortcutButton.Text = "Fly"
flyShortcutButton.BackgroundTransparency = 0.3
flyShortcutButton.BorderSizePixel = 1
flyShortcutButton.AutoButtonColor = true
flyShortcutButton.Parent = shortcutGui

flyShortcutButton.MouseButton1Click:Connect(function()
    FlyToggle:Set(true) -- This won't work unless Rayfield exposes :Set() — you should simulate the toggle manually:
    if not flying then
        FlyToggle.CurrentValue = true
        FlyToggle.Callback(true)
    end
end)