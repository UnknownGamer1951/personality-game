local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService       = game:GetService("TweenService")
local GuiService         = game:GetService("GuiService")
local RS                 = game:GetService("ReplicatedStorage")

local Config    = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes   = require(RS:WaitForChild("PersonalityGame"):WaitForChild("RemoteRefs"))
local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local T         = Config.Theme
local TOTAL     = Config.WaitTimeSeconds

local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "TimerGui"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.Enabled        = false
screenGui.Parent         = playerGui

local bg = Instance.new("Frame")
bg.Size             = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = T.Background
bg.BorderSizePixel  = 0
bg.Parent           = screenGui

-- Header
local header = Instance.new("TextLabel")
header.Size               = UDim2.new(1, -40, 0, 56)
header.Position           = UDim2.new(0, 20, 0, 16)
header.BackgroundTransparency = 1
header.Text               = "Your animal is being calculated"
header.Font               = Enum.Font.GothamBold
header.TextSize           = 28
header.TextColor3         = T.TextDark
header.TextWrapped        = true
header.Parent             = bg

-- White card
local card = Instance.new("Frame")
card.Size             = UDim2.new(0.88, 0, 0, 210)
card.Position         = UDim2.new(0.06, 0, 0, 82)
card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
card.BorderSizePixel  = 0
card.Parent           = bg
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

local analyzingLabel = Instance.new("TextLabel")
analyzingLabel.Size               = UDim2.new(1, -20, 0, 32)
analyzingLabel.Position           = UDim2.new(0, 10, 0, 10)
analyzingLabel.BackgroundTransparency = 1
analyzingLabel.Text               = "Your result reveals when the timer ends!"
analyzingLabel.Font               = Enum.Font.Gotham
analyzingLabel.TextSize           = 20
analyzingLabel.TextColor3         = Color3.fromRGB(160, 145, 130)
analyzingLabel.Parent             = card

-- Green timer bar
local timerBarBg = Instance.new("Frame")
timerBarBg.Size             = UDim2.new(1, -20, 0, 52)
timerBarBg.Position         = UDim2.new(0, 10, 0, 48)
timerBarBg.BackgroundColor3 = Color3.fromRGB(80, 185, 80)
timerBarBg.BorderSizePixel  = 0
timerBarBg.Parent           = card
Instance.new("UICorner", timerBarBg).CornerRadius = UDim.new(0, 12)

local timerFill = Instance.new("Frame")
timerFill.Size             = UDim2.fromScale(1, 1)
timerFill.BackgroundColor3 = Color3.fromRGB(50, 160, 50)
timerFill.BorderSizePixel  = 0
timerFill.Parent           = timerBarBg
Instance.new("UICorner", timerFill).CornerRadius = UDim.new(0, 12)

local timerText = Instance.new("TextLabel")
timerText.Size               = UDim2.fromScale(1, 1)
timerText.BackgroundTransparency = 1
timerText.Text               = "10:00"
timerText.Font               = Enum.Font.GothamBold
timerText.TextSize           = 30
timerText.TextColor3         = Color3.fromRGB(255, 255, 255)
timerText.ZIndex             = 2
timerText.Parent             = timerBarBg

local fasterLabel = Instance.new("TextLabel")
fasterLabel.Size               = UDim2.new(1, -20, 0, 26)
fasterLabel.Position           = UDim2.new(0, 10, 0, 112)
fasterLabel.BackgroundTransparency = 1
fasterLabel.Text               = "FASTER RESULTS  ⏳"
fasterLabel.Font               = Enum.Font.GothamBold
fasterLabel.TextSize           = 15
fasterLabel.TextColor3         = T.TextDark
fasterLabel.Parent             = card

local skipBtn = Instance.new("TextButton")
skipBtn.Size             = UDim2.new(0, 160, 0, 42)
skipBtn.Position         = UDim2.new(0.5, -80, 0, 142)
skipBtn.BackgroundColor3 = Color3.fromRGB(80, 185, 80)
skipBtn.BorderSizePixel  = 0
skipBtn.Text             = "SKIP  🐾"
skipBtn.Font             = Enum.Font.GothamBold
skipBtn.TextSize         = 18
skipBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
skipBtn.AutoButtonColor  = true
skipBtn.Parent           = card
Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 10)
skipBtn.Activated:Connect(function()
	local P = Config.Products
	local id = P.SkipFiveMinutes ~= 0 and P.SkipFiveMinutes or P.SkipOneMinute
	if id ~= 0 then MarketplaceService:PromptProductPurchase(player, id) end
end)

-- Friends row
local friendsBg = Instance.new("Frame")
friendsBg.Size             = UDim2.new(0.88, 0, 0, 72)
friendsBg.Position         = UDim2.new(0.06, 0, 0, 308)
friendsBg.BackgroundTransparency = 1
friendsBg.Parent           = bg

local friendsLabel = Instance.new("TextLabel")
friendsLabel.Size               = UDim2.new(1, 0, 0, 24)
friendsLabel.BackgroundTransparency = 1
friendsLabel.Text               = "👥  FRIENDS IN SERVER SPEED UP YOUR TIMER"
friendsLabel.Font               = Enum.Font.GothamBold
friendsLabel.TextSize           = 14
friendsLabel.TextColor3         = Color3.fromRGB(100, 80, 200)
friendsLabel.Parent             = friendsBg

local addFriendsBtn = Instance.new("TextButton")
addFriendsBtn.Size             = UDim2.new(0, 200, 0, 42)
addFriendsBtn.Position         = UDim2.new(0, 0, 0, 26)
addFriendsBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 220)
addFriendsBtn.BorderSizePixel  = 0
addFriendsBtn.Text             = "ADD FRIENDS"
addFriendsBtn.Font             = Enum.Font.GothamBold
addFriendsBtn.TextSize         = 16
addFriendsBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
addFriendsBtn.AutoButtonColor  = true
addFriendsBtn.Parent           = friendsBg
Instance.new("UICorner", addFriendsBtn).CornerRadius = UDim.new(0, 10)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size               = UDim2.new(0, 140, 0, 42)
speedLabel.Position           = UDim2.new(0, 210, 0, 26)
speedLabel.BackgroundTransparency = 1
speedLabel.Text               = "⚡ Speed: 1x"
speedLabel.Font               = Enum.Font.GothamBold
speedLabel.TextSize           = 16
speedLabel.TextColor3         = T.TextDark
speedLabel.Parent             = friendsBg

-- Like button
local likeBtn = Instance.new("TextButton")
likeBtn.Size               = UDim2.new(0.88, 0, 0, 36)
likeBtn.Position           = UDim2.new(0.06, 0, 0, 394)
likeBtn.BackgroundTransparency = 1
likeBtn.BorderSizePixel    = 0
likeBtn.Text               = "👍  LIKE THE GAME FOR -1 MINUTE"
likeBtn.Font               = Enum.Font.GothamBold
likeBtn.TextSize           = 17
likeBtn.TextColor3         = Color3.fromRGB(100, 80, 200)
likeBtn.AutoButtonColor    = false
likeBtn.Parent             = bg

local likeUsed = false
likeBtn.Activated:Connect(function()
	if likeUsed then return end
	likeUsed       = true
	likeBtn.Text   = "✅  Thanks! -1 minute applied"
	likeBtn.TextColor3 = Color3.fromRGB(60, 160, 60)
	Remotes.LikeGame:FireServer()
end)

-- Group button
local groupBtn = Instance.new("TextButton")
groupBtn.Size             = UDim2.new(0.88, 0, 0, 58)
groupBtn.Position         = UDim2.new(0.06, 0, 0, 442)
groupBtn.BackgroundColor3 = Color3.fromRGB(235, 170, 40)
groupBtn.BorderSizePixel  = 0
groupBtn.Text             = "JOIN GROUP FOR 1.5x SPEED  🐾"
groupBtn.Font             = Enum.Font.GothamBold
groupBtn.TextSize         = 20
groupBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
groupBtn.AutoButtonColor  = true
groupBtn.Parent           = bg
Instance.new("UICorner", groupBtn).CornerRadius = UDim.new(0, 12)
groupBtn.Activated:Connect(function()
	if Config.GroupId ~= 0 then
		GuiService:OpenBrowserWindow("https://www.roblox.com/groups/" .. Config.GroupId)
	end
end)

-- Toast
local toast = Instance.new("TextLabel")
toast.Size               = UDim2.new(0.88, 0, 0, 48)
toast.Position           = UDim2.new(0.06, 0, 1, -60)
toast.BackgroundColor3   = Color3.fromRGB(40, 40, 40)
toast.BackgroundTransparency = 0.15
toast.Text               = ""
toast.Font               = Enum.Font.GothamBold
toast.TextSize           = 15
toast.TextColor3         = Color3.fromRGB(255, 255, 255)
toast.TextWrapped        = true
toast.Visible            = false
toast.ZIndex             = 10
toast.Parent             = bg
Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 10)

local function showToast(msg)
	toast.Text    = msg
	toast.Visible = true
	task.delay(4, function() toast.Visible = false end)
end

-- Events
local function fmtTime(s)
	s = math.max(0, math.floor(s))
	return string.format("%d:%02d", math.floor(s / 60), s % 60)
end

Remotes.UpdateTimer.OnClientEvent:Connect(function(remaining)
	if not screenGui.Enabled then screenGui.Enabled = true end
	timerText.Text = fmtTime(remaining)
	local ratio = math.clamp(remaining / TOTAL, 0, 1)
	TweenService:Create(timerFill, TweenInfo.new(0.8), { Size = UDim2.fromScale(ratio, 1) }):Play()
	local r = math.floor(60 + (1 - ratio) * 180)
	local g = math.floor(185 * ratio + 30)
	TweenService:Create(timerBarBg, TweenInfo.new(0.8), {
		BackgroundColor3 = Color3.fromRGB(r, g, 40)
	}):Play()
	if remaining <= 0 then
		timerText.Text = "DONE!"
		task.delay(0.5, function()
			TweenService:Create(bg, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
			task.delay(0.5, function()
				screenGui.Enabled = false
			end)
		end)
	end
end)

Remotes.UpdateSpeed.OnClientEvent:Connect(function(speed, count)
	local rounded = math.floor(speed * 10 + 0.5) / 10
	speedLabel.Text = "⚡ Speed: " .. rounded .. "x"
	friendsLabel.Text = count > 1
		and ("👥  " .. (count - 1) .. " PLAYER(S) SPEEDING UP YOUR TIMER!")
		or "👥  FRIENDS IN SERVER SPEED UP YOUR TIMER"
end)

Remotes.TimerReset.OnClientEvent:Connect(function(name)
	showToast("😈 " .. name .. " reset your timer to " .. math.floor(TOTAL/60) .. " min!")
end)

Remotes.AnnounceReset.OnClientEvent:Connect(function(name)
	showToast("💣 " .. name .. " just reset EVERYONE's timer!")
end)
