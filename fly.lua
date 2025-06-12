--// Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Create Main Window
local Window = Rayfield:CreateWindow({
	Name = "Hacker vs Roblox | Mods",
	LoadingTitle = "Loading Mods...",
	LoadingSubtitle = "Touch UI Enabled",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = nil,
		FileName = "HackerVsRobloxUI"
	},
	Discord = {Enabled = false},
	KeySystem = false
})

--// Main Tab
local MainTab = Window:CreateTab("🏠 Main", nil)
MainTab:CreateSection("Fly Module")

--// Fly Variables
local flying = false
local flySpeed = 50
local verticalSpeed = 10
local bodyGyro, bodyVelocity
local upPressed, downPressed = false, false

--// Prevent fall animation
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid").StateChanged:Connect(function(_, state)
		if flying and state == Enum.HumanoidStateType.Freefall then
			char.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		end
	end)
end)

--// Fly Control Logic
local function startFly()
	local player = game.Players.LocalPlayer
	local char = player.Character
	local hrp = char:FindFirstChild("HumanoidRootPart")

	if not hrp then return end

	-- Body movers
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.velocity = Vector3.zero
	bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.Parent = hrp

	-- Movement Loop
	task.spawn(function()
		while flying and hrp and hrp.Parent do
			local moveDir = player.Character:FindFirstChildOfClass("Humanoid").MoveDirection * flySpeed
			local vertical = Vector3.new(0, (upPressed and 1 or 0 - (downPressed and 1 or 0)) * verticalSpeed, 0)

			bodyVelocity.Velocity = moveDir + vertical
			bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + moveDir + vertical)
			task.wait()
		end
	end)
end

local function stopFly()
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
end

--// Toggle UI Button
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
	Range = {1, 250},
	Increment = 1,
	CurrentValue = flySpeed,
	Callback = function(val) flySpeed = val end,
})

MainTab:CreateSlider({
	Name = "Vertical Speed",
	Range = {1, 250},
	Increment = 1,
	CurrentValue = verticalSpeed,
	Callback = function(val) verticalSpeed = val end,
})

--// Fly Shortcut GUI
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "FlyShortcutGui"
sg.ResetOnSpawn = false

local flyButton = Instance.new("TextButton", sg)
flyButton.Size = UDim2.new(0, 80, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 50)
flyButton.Text = "Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.BackgroundTransparency = 0.3
flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	FlyToggle:Set(flying)
end)

--// UP and DOWN Buttons
local function createButton(text, pos, onDown, onUp)
	local btn = Instance.new("TextButton", sg)
	btn.Size = UDim2.new(0, 80, 0, 40)
	btn.Position = pos
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundTransparency = 0.2
	btn.AutoButtonColor = true
	btn.MouseButton1Down:Connect(onDown)
	btn.MouseButton1Up:Connect(onUp)
end

createButton("UP", UDim2.new(1, -90, 1, -100),
	function() upPressed = true end,
	function() upPressed = false end
)

createButton("DOWN", UDim2.new(1, -90, 1, -50),
	function() downPressed = true end,
	function() downPressed = false end
)
