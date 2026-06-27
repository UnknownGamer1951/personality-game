-- GameServer.lua  (Script, runs on server)
local Players           = game:GetService("Players")
local RS                = game:GetService("ReplicatedStorage")

local Config  = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes = require(RS:WaitForChild("PersonalityGame"):WaitForChild("Remotes"))

-- Score the answers and return the winning personality key
local function calcResult(answers)
	local scores = {}
	for _, personality in pairs(Config.Personalities) do
		scores[_] = 0
	end
	for key in pairs(Config.Personalities) do
		scores[key] = 0
	end

	for qIndex, answerIndex in pairs(answers) do
		local question = Config.Questions[qIndex]
		if question then
			local answer = question.answers[answerIndex]
			if answer then
				for key, points in pairs(answer.scores) do
					scores[key] = (scores[key] or 0) + points
				end
			end
		end
	end

	local best, bestScore = "Explorer", -1
	for key, score in pairs(scores) do
		if score > bestScore then
			best      = key
			bestScore = score
		end
	end
	return best
end

Remotes.SubmitAnswers.OnServerEvent:Connect(function(player, answers)
	if type(answers) ~= "table" then return end
	local result = calcResult(answers)
	Remotes.ShowResult:FireClient(player, result)
	-- TimerServer picks up the result and starts the wait countdown
	-- via the player's attribute set here
	player:SetAttribute("PersonalityResult", result)
	player:SetAttribute("TimerStarted", true)
end)
