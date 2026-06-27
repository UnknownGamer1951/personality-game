local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RS           = game:GetService("ReplicatedStorage")

local Config    = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes   = require(RS:WaitForChild("PersonalityGame"):WaitForChild("Remotes"))
local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local T         = Config.Theme

local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "QuizGui"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.Parent         = playerGui

local bg = Instance.new("Frame")
bg.Size             = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = T.Background
bg.BorderSizePixel  = 0
bg.Parent           = screenGui

-- Green emoji banner across top
local banner = Instance.new("TextLabel")
banner.Size             = UDim2.new(1, 0, 0, 40)
banner.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
banner.BorderSizePixel  = 0
banner.Text             = "🐺  🦅  🐬  🐻  🦁  🦊  🦋  🐉  🐺  🦅  🐬  🐻  🦁  🦊  🦋  🐉"
banner.Font             = Enum.Font.GothamBold
banner.TextSize         = 18
banner.TextColor3       = Color3.fromRGB(255, 255, 255)
banner.Parent           = bg

-- Game title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, 0, 0, 44)
titleLabel.Position           = UDim2.new(0, 0, 0, 48)
titleLabel.BackgroundTransparency = 1
titleLabel.Text               = Config.GameTitle
titleLabel.Font               = Enum.Font.GothamBold
titleLabel.TextSize           = 26
titleLabel.TextColor3         = T.TextDark
titleLabel.Parent             = bg

-- "Question X of Y"
local counterLabel = Instance.new("TextLabel")
counterLabel.Size               = UDim2.new(1, 0, 0, 26)
counterLabel.Position           = UDim2.new(0, 0, 0, 96)
counterLabel.BackgroundTransparency = 1
counterLabel.Text               = ""
counterLabel.Font               = Enum.Font.GothamItalic
counterLabel.TextSize           = 17
counterLabel.TextColor3         = Color3.fromRGB(130, 110, 90)
counterLabel.Parent             = bg

-- Thin progress bar
local barBg = Instance.new("Frame")
barBg.Size             = UDim2.new(0.7, 0, 0, 6)
barBg.Position         = UDim2.new(0.15, 0, 0, 126)
barBg.BackgroundColor3 = Color3.fromRGB(210, 200, 185)
barBg.BorderSizePixel  = 0
barBg.Parent           = bg
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size             = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
barFill.BorderSizePixel  = 0
barFill.Parent           = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

-- White card
local card = Instance.new("Frame")
card.Size             = UDim2.new(0.72, 0, 0, 370)
card.Position         = UDim2.new(0.14, 0, 0, 146)
card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
card.BorderSizePixel  = 0
card.Parent           = bg
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

local questionLabel = Instance.new("TextLabel")
questionLabel.Size               = UDim2.new(1, -40, 0, 80)
questionLabel.Position           = UDim2.new(0, 20, 0, 20)
questionLabel.BackgroundTransparency = 1
questionLabel.Text               = ""
questionLabel.Font               = Enum.Font.GothamBold
questionLabel.TextSize           = 26
questionLabel.TextColor3         = T.TextDark
questionLabel.TextWrapped        = true
questionLabel.TextXAlignment     = Enum.TextXAlignment.Left
questionLabel.Parent             = card

local btnContainer = Instance.new("Frame")
btnContainer.Size               = UDim2.new(1, -40, 0, 260)
btnContainer.Position           = UDim2.new(0, 20, 0, 108)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent             = card
Instance.new("UIListLayout", btnContainer).Padding = UDim.new(0, 10)

-- ── State ─────────────────────────────────────────────────────
local answers   = {}
local questions = Config.Questions
local TOTAL_Q   = #questions

local function makeBtn(text, onClick)
	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(1, 0, 0, 52)
	btn.BackgroundColor3 = Color3.fromRGB(240, 248, 240)
	btn.BorderSizePixel  = 0
	btn.Text             = ""
	btn.AutoButtonColor  = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

	local accent = Instance.new("Frame", btn)
	accent.Size             = UDim2.new(0, 5, 0.7, 0)
	accent.Position         = UDim2.new(0, 0, 0.15, 0)
	accent.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
	accent.BorderSizePixel  = 0
	Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 4)

	local lbl = Instance.new("TextLabel", btn)
	lbl.Size               = UDim2.new(1, -20, 1, 0)
	lbl.Position           = UDim2.new(0, 16, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text               = text
	lbl.Font               = Enum.Font.GothamBold
	lbl.TextSize           = 18
	lbl.TextColor3         = T.TextDark
	lbl.TextXAlignment     = Enum.TextXAlignment.Left
	lbl.TextWrapped        = true

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(210, 238, 210) }):Play()
		TweenService:Create(accent, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(60, 140, 60) }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(240, 248, 240) }):Play()
		TweenService:Create(accent, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(80, 160, 80) }):Play()
	end)
	btn.Activated:Connect(onClick)
	return btn
end

local function showQuestion(index)
	for _, c in ipairs(btnContainer:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end

	local q = questions[index]
	questionLabel.Text = q.text
	counterLabel.Text  = "Question " .. index .. " of " .. TOTAL_Q

	TweenService:Create(barFill, TweenInfo.new(0.35), {
		Size = UDim2.new((index - 1) / TOTAL_Q, 0, 1, 0)
	}):Play()

	-- Slide card in from right
	card.Position = UDim2.new(1.2, 0, 0, 146)
	TweenService:Create(card, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.14, 0, 0, 146)
	}):Play()

	for i, answer in ipairs(q.answers) do
		local btn = makeBtn(answer.text, function()
			answers[index] = i
			if index < TOTAL_Q then
				showQuestion(index + 1)
			else
				TweenService:Create(barFill, TweenInfo.new(0.3), { Size = UDim2.new(1, 0, 1, 0) }):Play()
				task.delay(0.4, function()
					screenGui.Enabled = false
					Remotes.SubmitAnswers:FireServer(answers)
				end)
			end
		end)
		btn.Parent = btnContainer
	end
end

showQuestion(1)
