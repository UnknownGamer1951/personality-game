-- QuizGui — handles the entire quiz flow in a ScreenGui
local Players    = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RS         = game:GetService("ReplicatedStorage")

local Config     = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes    = require(RS:WaitForChild("PersonalityGame"):WaitForChild("Remotes"))
local player     = Players.LocalPlayer
local playerGui  = player:WaitForChild("PlayerGui")

local T = Config.Theme

-- ── Build ScreenGui ──────────────────────────────────────────
local screenGui = Instance.new("ScreenGui")
screenGui.Name             = "QuizGui"
screenGui.ResetOnSpawn     = false
screenGui.IgnoreGuiInset   = true
screenGui.Parent           = playerGui

local bg = Instance.new("Frame")
bg.Size            = UDim2.fromScale(1, 1)
bg.BackgroundColor3= T.Background
bg.BorderSizePixel = 0
bg.Parent          = screenGui

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size              = UDim2.new(1, 0, 0, 60)
titleLabel.Position          = UDim2.new(0, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text              = ""
titleLabel.Font              = Enum.Font.GothamBold
titleLabel.TextSize          = 28
titleLabel.TextColor3        = T.TextDark
titleLabel.Parent            = bg

-- Question label
local questionLabel = Instance.new("TextLabel")
questionLabel.Size           = UDim2.new(0.7, 0, 0, 80)
questionLabel.Position       = UDim2.new(0.15, 0, 0.18, 0)
questionLabel.BackgroundTransparency = 1
questionLabel.Text           = ""
questionLabel.Font           = Enum.Font.GothamBold
questionLabel.TextSize       = 36
questionLabel.TextColor3     = T.TextDark
questionLabel.TextWrapped    = true
questionLabel.Parent         = bg

-- Answer buttons container
local buttonContainer = Instance.new("Frame")
buttonContainer.Size             = UDim2.new(0.6, 0, 0.55, 0)
buttonContainer.Position         = UDim2.new(0.2, 0, 0.35, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent           = bg

local listLayout = Instance.new("UIListLayout")
listLayout.Padding          = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent           = buttonContainer

-- Progress bar
local progressBg = Instance.new("Frame")
progressBg.Size            = UDim2.new(0.6, 0, 0, 8)
progressBg.Position        = UDim2.new(0.2, 0, 0.94, 0)
progressBg.BackgroundColor3= Color3.fromRGB(200, 190, 175)
progressBg.BorderSizePixel = 0
progressBg.Parent          = bg
Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)

local progressFill = Instance.new("Frame")
progressFill.Size            = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3= T.ButtonNormal
progressFill.BorderSizePixel = 0
progressFill.Parent          = progressBg
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

-- ── Quiz state ───────────────────────────────────────────────
local answers     = {}
local currentQ    = 1
local questions   = Config.Questions

local function createButton(text, onClick)
	local btn = Instance.new("TextButton")
	btn.Size            = UDim2.new(1, 0, 0, 58)
	btn.BackgroundColor3= T.ButtonNormal
	btn.BorderSizePixel = 0
	btn.Text            = text
	btn.Font            = Enum.Font.GothamBold
	btn.TextSize        = 22
	btn.TextColor3      = T.TextDark
	btn.AutoButtonColor = false

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.ButtonHover }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.ButtonNormal }):Play()
	end)
	btn.Activated:Connect(onClick)
	return btn
end

local function showQuestion(index)
	-- Clear old buttons
	for _, child in ipairs(buttonContainer:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	local q = questions[index]
	titleLabel.Text    = Config.GameTitle
	questionLabel.Text = q.text

	-- Update progress bar
	local progress = (index - 1) / #questions
	TweenService:Create(progressFill, TweenInfo.new(0.3), {
		Size = UDim2.new(progress, 0, 1, 0)
	}):Play()

	for i, answer in ipairs(q.answers) do
		local btn = createButton(answer.text, function()
			answers[index] = i
			if index < #questions then
				showQuestion(index + 1)
			else
				-- All done — send to server
				screenGui.Enabled = false
				Remotes.SubmitAnswers:FireServer(answers)
			end
		end)
		btn.Parent = buttonContainer
	end
end

showQuestion(1)
