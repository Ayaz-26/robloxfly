-- Load Rayfield UI 
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window 
local Window = Rayfield:CreateWindow({ Name = "ScriptForgeHub", LoadingTitle = "Loading Mods...", LoadingSubtitle = "by You", ConfigurationSaving = { Enabled = false }, Discord = { Enabled = false }, KeySystem = false }) local MainTab = Window:CreateTab("\ud83c\udfe0 Home", nil)

-- Fly Module 
local flying = false local bodyGyro, bodyVelocity local flySpeed, verticalSpeed = 10, 5 local upPressed, downPressed = false, false local player = game.Players.LocalPlayer

-- Fly Start/Stop 
local function startFly() local char = player.Character local hrp = char and char:FindFirstChild("HumanoidRootPart") local hum = char and char:FindFirstChildOfClass("Humanoid") if not hrp or not hum then return end

bodyGyro = Instance.new("BodyGyro", hrp)
bodyGyro.P = 9e4
bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
bodyGyro.CFrame = hrp.CFrame

bodyVelocity = Instance.new("BodyVelocity", hrp)
bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)

hum:ChangeState(Enum.HumanoidStateType.Physics)

task.spawn(function()
    while flying and hrp and hum do
        local mdir = hum.MoveDirection * flySpeed
        local vert = Vector3.new(0, (upPressed and 1 or 0 - (downPressed and 1 or 0)) * verticalSpeed, 0)
        bodyVelocity.Velocity = mdir + vert
        bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + mdir + vert)
        task.wait()
    end
end)

end

local function stopFly() if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end end

-- Fly Toggle 
MainTab:CreateToggle({ Name = "Enable Fly", CurrentValue = false, Callback = function(b) flying = b if flying then startFly() else stopFly() end end })

-- Speed Sliders (in Mod Menu only) 
MainTab:CreateSlider({ Name = "Fly Speed", Range={1,30}, Increment=1, CurrentValue=flySpeed, Callback = function(v) flySpeed = v end }) MainTab:CreateSlider({ Name = "Vertical Speed", Range={1,30}, Increment=1, CurrentValue=verticalSpeed, Callback = function(v) verticalSpeed = v end })

-- Mobile Shortcut UI 
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")) gui.Name = "FlyShortcutGUI"

-- Fly Toggle Button 
local shortcutBtn = Instance.new("TextButton", gui) shortcutBtn.Size = UDim2.new(0,80,0,40) shortcutBtn.Position = UDim2.new(0,0.02,1,-100) shortcutBtn.Text = "Fly" shortcutBtn.BackgroundColor3 = Color3.fromRGB(40,40,40) shortcutBtn.TextColor3 = Color3.new(1,1,1) shortcutBtn.TextScaled = true shortcutBtn.MouseButton1Click:Connect(function() flying = not flying if flying then startFly() else stopFly() end end)

-- Up Button 
local upBtn = Instance.new("TextButton", gui) upBtn.Size = UDim2.new(0,60,0,40) upBtn.Position = UDim2.new(0.12, 0, 1, -200) upBtn.Text = "\u25b2" upBtn.BackgroundColor3 = Color3.fromRGB(60,60,60) upBtn.TextColor3 = Color3.new(1,1,1) upBtn.TextScaled = true upBtn.MouseButton1Down:Connect(function() upPressed = true end) upBtn.MouseButton1Up:Connect(function() upPressed = false end)

-- Down Button 
local downBtn = Instance.new("TextButton", gui) downBtn.Size = UDim2.new(0,60,0,40) downBtn.Position = UDim2.new(0.12, 0, 1, -150) downBtn.Text = "\u25bc" downBtn.BackgroundColor3 = Color3.fromRGB(60,60,60) downBtn.TextColor3 = Color3.new(1,1,1) downBtn.TextScaled = true downBtn.MouseButton1Down:Connect(function() downPressed = true end) downBtn.MouseButton1Up:Connect(function() downPressed = false end)

