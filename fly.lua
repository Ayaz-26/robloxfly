-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local flying = false
local flySpeed = 10
local verticalSpeed = 5
local bodyGyro, bodyVelocity
local up = false
local down = false

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Hacker vs Roblox | Mods",
    LoadingTitle = "Loading Mods...",
    LoadingSubtitle = "By You",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "HackerVsRobloxUI"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("🏠 Main", nil)
MainTab:CreateSection("Fly Module")

-- Function: Start Flying
local function startFly()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = char.HumanoidRootPart.CFrame
    bodyGyro.Parent = char.HumanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.velocity = Vector3.zero
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = char.HumanoidRootPart

    task.spawn(function()
        while flying and char and char:FindFirstChild("HumanoidRootPart") do
            local hrp = char.HumanoidRootPart
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid then break end

            -- Mobile joystick movement
            local moveVec = humanoid.MoveDirection * flySpeed

            -- Vertical control
            if up then moveVec += Vector3.new(0, verticalSpeed, 0) end
            if down then moveVec -= Vector3.new(0, verticalSpeed, 0) end

            bodyVelocity.Velocity = moveVec

            if moveVec.Magnitude > 0 then
                bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + moveVec)
            end

            task.wait()
        end
    end)
end

-- Function: Stop Flying
local function stopFly()
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
end

-- Toggle Fly
MainTab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Callback = function(value)
        flying = value
        if flying then
            startFly()
            flyButtons.Visible = true
        else
            stopFly()
            flyButtons.Visible = false
        end
    end
})

-- Sliders
MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(v)
        flySpeed = v
    end
})

MainTab:CreateSlider({
    Name = "Vertical Speed",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(v)
        verticalSpeed = v
    end
})

-- No Cooldown (basic universal pattern)
MainTab:CreateToggle({
    Name = "No Cooldown",
    CurrentValue = false,
    Callback = function(toggle)
        if toggle then
            for _, v in pairs(getgc(true)) do
                if typeof(v) == "function" and islclosure(v) then
                    local constants = debug.getconstants(v)
                    for i, c in pairs(constants) do
                        if type(c) == "string" and c:lower():find("cooldown") then
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

-- Mobile UI for Fly Up/Down
local CoreGui = game:GetService("CoreGui")
local flyButtons = Instance.new("ScreenGui")
flyButtons.Name = "FlyButtonsGui"
flyButtons.Parent = CoreGui
flyButtons.ResetOnSpawn = false
flyButtons.IgnoreGuiInset = true
flyButtons.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
flyButtons.Enabled = true
flyButtons.DisplayOrder = 1000
flyButtons.Visible = false

local function createButton(name, position, onPress, onRelease)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Parent = flyButtons
    btn.AutoButtonColor = true

    btn.MouseButton1Down:Connect(function()
        onPress()
    end)
    btn.MouseButton1Up:Connect(function()
        onRelease()
    end)
end

createButton("Up", UDim2.new(1, -110, 1, -140),
    function() up = true end,
    function() up = false end
)

createButton("Down", UDim2.new(1, -110, 1, -90),
    function() down = true end,
    function() down = false end
)