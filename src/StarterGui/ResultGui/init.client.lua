-- ResultGui — shown immediately after quiz, before timer finishes
local Players    = game:GetService("Players")
local RS         = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config     = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes    = require(RS:WaitForChild("PersonalityGame"):WaitForChild("Remotes"))
local player     = Players.LocalPlayer
local playerGui  = player:WaitForChild("PlayerGui")
local T          = Config.Theme

local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "ResultGui"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.Enabled        = false
screenGui.Parent         = playerGui

local bg = Instance.new("Frame")
bg.Size               = UDim2.fromScale(1, 1)
bg.BackgroundColor3   = T.Background
bg.BorderSizePixel    = 0
bg.Parent             = screenGui

-- Icon
local iconLabel = Instance.new("TextLabel")
iconLabel.Size                 = UDim2.new(1, 0, 0, 100)
iconLabel.Position             = UDim2.new(0, 0, 0.1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text                 = ""
iconLabel.TextSize             = 72
iconLabel.Font                 = Enum.Font.GothamBold
iconLabel.Parent               = bg

-- Name
local nameLabel = Instance.new("TextLabel")
nameLabel.Size                 = UDim2.new(1, 0, 0, 60)
nameLabel.Position             = UDim2.new(0, 0, 0.32, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text                 = ""
nameLabel.Font                 = Enum.Font.GothamBold
nameLabel.TextSize             = 40
nameLabel.TextColor3           = T.TextDark
nameLabel.Parent               = bg

-- Description
local descLabel = Instance.new("TextLabel")
descLabel.Size                 = UDim2.new(0.7, 0, 0, 120)
descLabel.Position             = UDim2.new(0.15, 0, 0.46, 0)
descLabel.BackgroundTransparency = 1
descLabel.Text                 = ""
descLabel.Font                 = Enum.Font.Gotham
descLabel.TextSize             = 20
descLabel.TextColor3           = T.TextDark
descLabel.TextWrapped          = true
descLabel.Parent               = bg

-- "Calculating..." sub-label
local waitHint = Instance.new("TextLabel")
waitHint.Size                  = UDim2.new(1, 0, 0, 40)
waitHint.Position              = UDim2.new(0, 0, 0.74, 0)
waitHint.BackgroundTransparency= 1
waitHint.Text                  = "Calculating your full result..."
waitHint.Font                  = Enum.Font.GothamItalic
waitHint.TextSize              = 18
waitHint.TextColor3            = Color3.fromRGB(150, 130, 110)
waitHint.Parent                = bg

Remotes.ShowResult.OnClientEvent:Connect(function(personalityKey)
	local data = Config.Personalities[personalityKey]
	if not data then return end

	iconLabel.Text      = data.icon
	nameLabel.Text      = data.name
	nameLabel.TextColor3= data.color
	descLabel.Text      = data.description

	screenGui.Enabled = true
	bg.BackgroundTransparency = 1
	TweenService:Create(bg, TweenInfo.new(0.5), { BackgroundTransparency = 0 }):Play()

	-- Hand off to TimerGui after a short pause
	task.delay(3, function()
		screenGui.Enabled = false
		local timerGui = playerGui:FindFirstChild("TimerGui")
		if timerGui then timerGui.Enabled = true end
	end)
end)
