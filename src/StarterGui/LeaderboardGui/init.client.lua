-- Leaderboard panel — always visible in top-right corner after quiz starts
local Players  = game:GetService("Players")
local RS       = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config   = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes  = require(RS:WaitForChild("PersonalityGame"):WaitForChild("RemoteRefs"))
local player   = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local T        = Config.Theme

local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "LeaderboardGui"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.Enabled        = false
screenGui.Parent         = playerGui

-- Panel
local panel = Instance.new("Frame")
panel.Size             = UDim2.new(0, 210, 0, 300)
panel.Position         = UDim2.new(1, -220, 0, 16)
panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
panel.BorderSizePixel  = 0
panel.Parent           = screenGui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

-- Shadow
local shadow = Instance.new("Frame")
shadow.Size             = UDim2.new(1, 6, 1, 6)
shadow.Position         = UDim2.new(0, -3, 0, 3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.85
shadow.BorderSizePixel  = 0
shadow.ZIndex           = 0
shadow.Parent           = panel
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

-- Header
local headerBg = Instance.new("Frame")
headerBg.Size             = UDim2.new(1, 0, 0, 42)
headerBg.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
headerBg.BorderSizePixel  = 0
headerBg.ZIndex           = 2
headerBg.Parent           = panel
Instance.new("UICorner", headerBg).CornerRadius = UDim.new(0, 14)

-- Cover bottom corners of header
local headerFix = Instance.new("Frame")
headerFix.Size             = UDim2.new(1, 0, 0, 14)
headerFix.Position         = UDim2.new(0, 0, 1, -14)
headerFix.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
headerFix.BorderSizePixel  = 0
headerFix.ZIndex           = 2
headerFix.Parent           = headerBg

local headerLabel = Instance.new("TextLabel")
headerLabel.Size               = UDim2.fromScale(1, 1)
headerLabel.BackgroundTransparency = 1
headerLabel.Text               = "🏆  Most Quizzes Taken"
headerLabel.Font               = Enum.Font.GothamBold
headerLabel.TextSize           = 14
headerLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
headerLabel.ZIndex             = 3
headerLabel.Parent             = headerBg

-- Rows container
local rowsFrame = Instance.new("Frame")
rowsFrame.Size             = UDim2.new(1, -16, 1, -52)
rowsFrame.Position         = UDim2.new(0, 8, 0, 50)
rowsFrame.BackgroundTransparency = 1
rowsFrame.ClipsDescendants = true
rowsFrame.Parent           = panel

local listLayout = Instance.new("UIListLayout", rowsFrame)
listLayout.Padding = UDim.new(0, 6)

local rankColors = {
	Color3.fromRGB(255, 185, 0),   -- 1st gold
	Color3.fromRGB(180, 180, 180), -- 2nd silver
	Color3.fromRGB(180, 110, 60),  -- 3rd bronze
}

local function rebuildRows(data)
	for _, c in ipairs(rowsFrame:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	for i, entry in ipairs(data) do
		local row = Instance.new("Frame")
		row.Size             = UDim2.new(1, 0, 0, 32)
		row.BackgroundColor3 = i % 2 == 0
			and Color3.fromRGB(245, 248, 245)
			or  Color3.fromRGB(255, 255, 255)
		row.BorderSizePixel  = 0
		row.Parent           = rowsFrame
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

		-- Rank badge
		local rankLabel = Instance.new("TextLabel")
		rankLabel.Size               = UDim2.new(0, 28, 1, 0)
		rankLabel.BackgroundTransparency = 1
		rankLabel.Text               = "#" .. entry.rank
		rankLabel.Font               = Enum.Font.GothamBold
		rankLabel.TextSize           = 13
		rankLabel.TextColor3         = rankColors[i] or T.TextDark
		rankLabel.Parent             = row

		-- Highlight current player's row
		if entry.name == player.Name then
			row.BackgroundColor3 = Color3.fromRGB(220, 240, 220)
		end

		-- Name
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size               = UDim2.new(0, 120, 1, 0)
		nameLabel.Position           = UDim2.new(0, 28, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text               = entry.name
		nameLabel.Font               = Enum.Font.Gotham
		nameLabel.TextSize           = 13
		nameLabel.TextColor3         = T.TextDark
		nameLabel.TextTruncate       = Enum.TextTruncate.AtEnd
		nameLabel.TextXAlignment     = Enum.TextXAlignment.Left
		nameLabel.Parent             = row

		-- Count
		local countLabel = Instance.new("TextLabel")
		countLabel.Size               = UDim2.new(0, 40, 1, 0)
		countLabel.Position           = UDim2.new(1, -44, 0, 0)
		countLabel.BackgroundTransparency = 1
		countLabel.Text               = tostring(entry.count) .. "x"
		countLabel.Font               = Enum.Font.GothamBold
		countLabel.TextSize           = 13
		countLabel.TextColor3         = Color3.fromRGB(80, 160, 80)
		countLabel.Parent             = row
	end

	if #data == 0 then
		local empty = Instance.new("TextLabel")
		empty.Size               = UDim2.new(1, 0, 0, 40)
		empty.BackgroundTransparency = 1
		empty.Text               = "No entries yet!"
		empty.Font               = Enum.Font.Gotham
		empty.TextSize           = 14
		empty.TextColor3         = Color3.fromRGB(160, 150, 140)
		empty.Parent             = rowsFrame
	end
end

-- Show leaderboard when timer starts (after quiz)
local connection
connection = Remotes.ShowResult.OnClientEvent:Connect(function()
	screenGui.Enabled = true
	connection:Disconnect()
end)

Remotes.UpdateLeaderboard.OnClientEvent:Connect(function(data)
	rebuildRows(data)
end)

-- Seed with empty state
rebuildRows({})
