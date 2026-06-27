local RS = game:GetService("ReplicatedStorage")
local folder = RS:WaitForChild("PersonalityGame")
local remotesFolder = folder:WaitForChild("Remotes")

return {
	-- Client → Server
	SubmitAnswers       = remotesFolder:WaitForChild("SubmitAnswers"),
	LikeGame            = remotesFolder:WaitForChild("LikeGame"),

	-- Server → Client
	ShowResult          = remotesFolder:WaitForChild("ShowResult"),
	UpdateTimer         = remotesFolder:WaitForChild("UpdateTimer"),
	UpdateSpeed         = remotesFolder:WaitForChild("UpdateSpeed"),
	TimerReset          = remotesFolder:WaitForChild("TimerReset"),
	AnnounceReset       = remotesFolder:WaitForChild("AnnounceReset"),
	UpdateLeaderboard   = remotesFolder:WaitForChild("UpdateLeaderboard"),
}
