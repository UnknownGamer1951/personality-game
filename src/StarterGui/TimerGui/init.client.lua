-- TimerGui — the 10-minute wait screen with Robux skip/sabotage buttons
local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService       = game:GetService("TweenService")
local RS                 = game:GetService("ReplicatedStorage")

local Config   = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes  = require(RS:WaitForChild("PersonalityGame"):WaitForChild("Remotes"))
local player   = Players.LocalPlayer
local playerGui= player:WaitForChild("PlayerGui")
local T        = Config.Theme

local TOTAL    = Config.WaitTimeSeconds

local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "TimerGui"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.Enabled        = false
screenGui.Parent         = playerGui

local bg = Instance.new("Frame")
bg.Size               = UDim2.fromScale(1, 1)
bg.BackgroundColor3   = T.Background
bg.BorderSizePixel    = 0
bg.Parent             = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size                 = UDim2.new(1, 0, 0, 60)
title.Position             = UDim2.new(0, 0, 0.08, 0)
title.BackgroundTransparency = 1
title.Text                 = "Please wait for your result..."
title.Font                 = Enum.Font.GothamBold
title.TextSize             = 30
title.TextColor3           = T.TextDark
title.Parent               = bg

-- Timer text
local timerLabel = Instance.new("TextLabel")
timerLabel.Size                = UDim2.new(0.5, 0, 0, 80)
timerLabel.Position            = UDim2.new(0.25, 0, 0.2, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text                = "10:00"
timerLabel.Font                = Enum.Font.GothamBold
timerLabel.TextSize            = 64
timerLabel.TextColor3          = T.TextDark
timerLabel.Parent              = bg

-- Progress bar background
local barBg = Instance.new("Frame")
barBg.Size             = UDim2.new(0.7, 0, 0, 24)
barBg.Position         = UDim2.new(0.15, 0, 0.42, 0)
barBg.BackgroundColor3 = Color3.fromRGB(200, 190, 175)
barBg.BorderSizePixel  = 0
barBg.Parent           = bg
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size             = UDim2.new(1, 0, 1, 0)
barFill.BackgroundColor3 = T.ButtonNormal
barFill.BorderSizePixel  = 0
barFill.Parent           = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

-- Robux buttons
local function makeRobuxButton(text, color, yPos, productId)
	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(0.5, 0, 0, 54)
	btn.Position         = UDim2.new(0.25, 0, yPos, 0)
	btn.BackgroundColor3 = color
	btn.BorderSizePixel  = 0
	btn.Text             = text
	btn.Font             = Enum.Font.GothamBold
	btn.TextSize         = 20
	btn.TextColor3       = Color3.fromRGB(255, 255, 255)
	btn.AutoButtonColor  = true
	btn.Parent           = bg
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

	btn.Activated:Connect(function()
		if productId ~= 0 then
			MarketplaceService:PromptProductPurchase(player, productId)
		else
			-- In Studio (no real product), just simulate for testing
			print("[TimerGui] Would purchase product:", text)
		end
	end)
	return btn
end

makeRobuxButton("⏩  Skip 1 Minute  (R$)", T.ButtonNormal,          0.54, Config.Products.SkipOneMinute)
makeRobuxButton("⏭  Skip 5 Minutes  (R$)", Color3.fromRGB(60,160,60), 0.64, Config.Products.SkipFiveMinutes)
makeRobuxButton("💣  Reset Everyone's Timer  (R$)", Color3.fromRGB(200,60,60), 0.76, Config.Products.ResetEveryone)

-- "Reset" notification toast
local toast = Instance.new("TextLabel")
toast.Size                 = UDim2.new(0.8, 0, 0, 50)
toast.Position             = UDim2.new(0.1, 0, 0.9, 0)
toast.BackgroundColor3     = Color3.fromRGB(50, 50, 50)
toast.BackgroundTransparency = 0.3
toast.Text                 = ""
toast.Font                 = Enum.Font.GothamBold
toast.TextSize             = 18
toast.TextColor3           = Color3.fromRGB(255, 255, 255)
toast.TextWrapped          = true
toast.Visible              = false
toast.Parent               = bg
Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)

local function showToast(msg)
	toast.Text    = msg
	toast.Visible = true
	task.delay(4, function() toast.Visible = false end)
end

-- ── Server events ─────────────────────────────────────────────
local function formatTime(seconds)
	seconds = math.max(0, math.floor(seconds))
	local m = math.floor(seconds / 60)
	local s = seconds % 60
	return string.format("%d:%02d", m, s)
end

Remotes.UpdateTimer.OnClientEvent:Connect(function(remaining)
	timerLabel.Text = formatTime(remaining)
	local ratio = remaining / TOTAL
	TweenService:Create(barFill, TweenInfo.new(0.5), {
		Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0)
	}):Play()

	if remaining <= 0 then
		-- Timer done — show full result reveal (placeholder)
		timerLabel.Text = "DONE!"
		title.Text = "Your result is ready! 🎉"
	end
end)

Remotes.TimerReset.OnClientEvent:Connect(function(instigatorName)
	showToast("😈 " .. instigatorName .. " reset your timer back to " .. math.floor(TOTAL/60) .. " minutes!")
end)

Remotes.AnnounceReset.OnClientEvent:Connect(function(instigatorName)
	showToast("💣 " .. instigatorName .. " just reset everyone's timers!")
end)
