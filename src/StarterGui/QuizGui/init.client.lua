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

-- Green animal emoji banner
local banner = Instance.new("TextLabel")
banner.Size             = UDim2.new(1, 0, 0, 40)
banner.Position         = UDim2.new(0, 0, 0, 0)
banner.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
banner.BorderSizePixel  = 0
banner.Text             = "🐺  🦅  🐬  🐻  🦁  🦊  🦋  🐉"
banner.Font             = Enum.Font.GothamBold
banner.TextSize         = 18
banner.TextColor3       = Color3.fromRGB(255, 255, 255)
banner.Parent           = bg

-- Game title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, 0, 0, 40)
titleLabel.Position           = UDim2.new(0, 0, 0, 48)
titleLabel.BackgroundTransparency = 1
titleLabel.Text               = Config.GameTitle
titleLabel.Font               = Enum.Font.GothamBold
titleLabel.TextSize           = 26
titleLabel.TextColor3         = T.TextDark
titleLabel.Parent             = bg

-- "Question X of Y" counter
local counterLabel = Instance.new("TextLabel")
counterLabel.Size               = UDim2.new(1, 0, 0, 24)
counterLabel.Position           = UDim2.new(0, 0, 0, 92)
counterLabel.BackgroundTransparency = 1
counterLabel.Text               = ""
counterLabel.Font               = Enum.Font.GothamItalic
counterLabel.TextSize           = 17
counterLabel.TextColor3         = Color3.fromRGB(130, 110, 90)
counterLabel.Parent             = bg

-- Progress bar
local barBg = Instance.new("Frame")
barBg.Size             = UDim2.new(0.7, 0, 0, 6)
barBg.Position         = UDim2.new(0.15, 0, 0, 120)
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

-- Question text (no card, just text on background)
local questionLabel = Instance.new("TextLabel")
questionLabel.Size               = UDim2.new(0.8, 0, 0, 80)
questionLabel.Position           = UDim2.new(0.1, 0, 0, 140)
questionLabel.BackgroundTransparency = 1
questionLabel.Text               = ""
questionLabel.Font               = Enum.Font.GothamBold
questionLabel.TextSize           = 32
questionLabel.TextColor3         = T.TextDark
questionLabel.TextWrapped        = true
questionLabel.Parent             = bg

-- Answer buttons (stacked vertically, centered)
local buttons = {}
local BUTTON_Y_START = 240
local BUTTON_HEIGHT  = 58
local BUTTON_GAP     = 12

local function clearButtons()
	for _, btn in ipairs(buttons) do btn:Destroy() end
	buttons = {}
end

local function makeAnswerButton(text, yPos, onClick)
	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(0.7, 0, 0, BUTTON_HEIGHT)
	btn.Position         = UDim2.new(0.15, 0, 0, yPos)
	btn.BackgroundColor3 = T.ButtonNormal
	btn.BorderSizePixel  = 0
	btn.Text             = text
	btn.Font             = Enum.Font.GothamBold
	btn.TextSize         = 20
	btn.TextColor3       = T.TextDark
	btn.TextWrapped      = true
	btn.AutoButtonColor  = false
	btn.Parent           = bg
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.ButtonHover }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.ButtonNormal }):Play()
	end)
	btn.Activated:Connect(onClick)
	return btn
end

-- Quiz state
local answers   = {}
local questions = Config.Questions
local TOTAL_Q   = #questions

local function showQuestion(index)
	clearButtons()

	local q = questions[index]
	questionLabel.Text = q.text
	counterLabel.Text  = "Question " .. index .. " of " .. TOTAL_Q

	TweenService:Create(barFill, TweenInfo.new(0.35), {
		Size = UDim2.new((index - 1) / TOTAL_Q, 0, 1, 0)
	}):Play()

	for i, answer in ipairs(q.answers) do
		local yPos = BUTTON_Y_START + (i - 1) * (BUTTON_HEIGHT + BUTTON_GAP)
		local btn = makeAnswerButton(answer.text, yPos, function()
			answers[index] = i
			if index < TOTAL_Q then
				showQuestion(index + 1)
			else
				TweenService:Create(barFill, TweenInfo.new(0.3), {
					Size = UDim2.new(1, 0, 1, 0)
				}):Play()
				task.delay(0.4, function()
					screenGui.Enabled = false
					Remotes.SubmitAnswers:FireServer(answers)
				end)
			end
		end)
		table.insert(buttons, btn)
	end
end

showQuestion(1)
