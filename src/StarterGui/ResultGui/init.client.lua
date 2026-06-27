-- ResultGui — shown after quiz, fades in with animal + rarity reveal
local Players      = game:GetService("Players")
local RS           = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config    = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes   = require(RS:WaitForChild("PersonalityGame"):WaitForChild("RemoteRefs"))
local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local T         = Config.Theme

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

-- Animal icon
local iconLabel = Instance.new("TextLabel")
iconLabel.Size                 = UDim2.new(1, 0, 0, 110)
iconLabel.Position             = UDim2.new(0, 0, 0.06, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.TextSize             = 80
iconLabel.Font                 = Enum.Font.GothamBold
iconLabel.Text                 = ""
iconLabel.Parent               = bg

-- "You are..." label
local youAreLabel = Instance.new("TextLabel")
youAreLabel.Size               = UDim2.new(1, 0, 0, 30)
youAreLabel.Position           = UDim2.new(0, 0, 0.30, 0)
youAreLabel.BackgroundTransparency = 1
youAreLabel.Text               = "You are..."
youAreLabel.Font               = Enum.Font.Gotham
youAreLabel.TextSize           = 20
youAreLabel.TextColor3         = Color3.fromRGB(150, 130, 110)
youAreLabel.Parent             = bg

-- Animal name
local nameLabel = Instance.new("TextLabel")
nameLabel.Size                 = UDim2.new(1, 0, 0, 60)
nameLabel.Position             = UDim2.new(0, 0, 0.36, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text                 = ""
nameLabel.Font                 = Enum.Font.GothamBold
nameLabel.TextSize             = 44
nameLabel.TextColor3           = T.TextDark
nameLabel.Parent               = bg

-- ── Rarity badge ────────────────────────────────────────────
local rarityBadge = Instance.new("Frame")
rarityBadge.Size             = UDim2.new(0, 220, 0, 40)
rarityBadge.Position         = UDim2.new(0.5, -110, 0.50, 0)
rarityBadge.BorderSizePixel  = 0
rarityBadge.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
rarityBadge.Parent           = bg
Instance.new("UICorner", rarityBadge).CornerRadius = UDim.new(1, 0)

local rarityLabel = Instance.new("TextLabel")
rarityLabel.Size               = UDim2.fromScale(1, 1)
rarityLabel.BackgroundTransparency = 1
rarityLabel.Text               = ""
rarityLabel.Font               = Enum.Font.GothamBold
rarityLabel.TextSize           = 18
rarityLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
rarityLabel.Parent             = rarityBadge

-- Stars
local starsLabel = Instance.new("TextLabel")
starsLabel.Size                = UDim2.new(1, 0, 0, 28)
starsLabel.Position            = UDim2.new(0, 0, 0.56, 0)
starsLabel.BackgroundTransparency = 1
starsLabel.Text                = ""
starsLabel.Font                = Enum.Font.GothamBold
starsLabel.TextSize            = 22
starsLabel.TextColor3          = Color3.fromRGB(255, 210, 50)
starsLabel.Parent              = bg

-- "Only X% of players get this"
local pctLabel = Instance.new("TextLabel")
pctLabel.Size                  = UDim2.new(1, 0, 0, 28)
pctLabel.Position              = UDim2.new(0, 0, 0.63, 0)
pctLabel.BackgroundTransparency = 1
pctLabel.Text                  = ""
pctLabel.Font                  = Enum.Font.Gotham
pctLabel.TextSize              = 17
pctLabel.TextColor3            = Color3.fromRGB(130, 110, 90)
pctLabel.Parent                = bg

-- Description
local descLabel = Instance.new("TextLabel")
descLabel.Size                 = UDim2.new(0.72, 0, 0, 110)
descLabel.Position             = UDim2.new(0.14, 0, 0.69, 0)
descLabel.BackgroundTransparency = 1
descLabel.Text                 = ""
descLabel.Font                 = Enum.Font.Gotham
descLabel.TextSize             = 18
descLabel.TextColor3           = T.TextDark
descLabel.TextWrapped          = true
descLabel.Parent               = bg

-- Bottom hint
local waitHint = Instance.new("TextLabel")
waitHint.Size                  = UDim2.new(1, 0, 0, 30)
waitHint.Position              = UDim2.new(0, 0, 0.92, 0)
waitHint.BackgroundTransparency= 1
waitHint.Text                  = "Share your result with friends! 🐾"
waitHint.Font                  = Enum.Font.Gotham
waitHint.TextSize              = 15
waitHint.TextColor3            = Color3.fromRGB(160, 140, 120)
waitHint.Parent                = bg

-- ── Reveal logic ─────────────────────────────────────────────
local function animateIn(obj, delay, props)
	obj.BackgroundTransparency = 1
	task.delay(delay, function()
		TweenService:Create(obj, TweenInfo.new(0.4), props):Play()
	end)
end

Remotes.ShowResult.OnClientEvent:Connect(function(personalityKey)
	local data   = Config.Personalities[personalityKey]
	if not data then return end
	local rarity = Config.Rarities[data.rarity]

	screenGui.Enabled = true

	-- Fill content
	iconLabel.Text         = data.icon
	nameLabel.Text         = data.name
	nameLabel.TextColor3   = data.color
	descLabel.Text         = data.description
	rarityBadge.BackgroundColor3 = rarity.color
	rarityLabel.Text       = rarity.label
	starsLabel.Text        = rarity.stars
	pctLabel.Text          = "Only " .. data.rarityPct .. "% of players get this result"

	-- Staggered fade-in for each element
	bg.BackgroundTransparency = 1
	TweenService:Create(bg, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()

	-- Reset transparencies for animation
	for _, lbl in ipairs({ iconLabel, youAreLabel, nameLabel, rarityBadge, starsLabel, pctLabel, descLabel, waitHint }) do
		if lbl:IsA("TextLabel") then lbl.TextTransparency = 1 end
		if lbl:IsA("Frame") then lbl.BackgroundTransparency = 1 end
	end

	local function fadeText(lbl, delay)
		task.delay(delay, function()
			TweenService:Create(lbl, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
		end)
	end
	local function fadeFrame(frm, delay)
		task.delay(delay, function()
			TweenService:Create(frm, TweenInfo.new(0.5), { BackgroundTransparency = 0 }):Play()
			for _, child in ipairs(frm:GetChildren()) do
				if child:IsA("TextLabel") then
					child.TextTransparency = 1
					TweenService:Create(child, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
				end
			end
		end)
	end

	fadeText(iconLabel,   0.2)
	fadeText(youAreLabel, 0.5)
	fadeText(nameLabel,   0.8)
	fadeFrame(rarityBadge, 1.1)
	fadeText(starsLabel,  1.3)
	fadeText(pctLabel,    1.5)
	fadeText(descLabel,   1.9)
	fadeText(waitHint,    2.5)

	-- Result screen stays — no auto-dismiss
end)
