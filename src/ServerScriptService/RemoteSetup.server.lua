-- Creates all RemoteEvents inside ReplicatedStorage.PersonalityGame.Remotes
-- before any other script requires RemoteRefs.
local RS = game:GetService("ReplicatedStorage")
local folder = RS:WaitForChild("PersonalityGame")

local remotesFolder = folder:FindFirstChild("Remotes")
if not remotesFolder then
	remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "Remotes"
	remotesFolder.Parent = folder
end

local names = {
	"SubmitAnswers",
	"LikeGame",
	"ShowResult",
	"UpdateTimer",
	"UpdateSpeed",
	"TimerReset",
	"AnnounceReset",
	"UpdateLeaderboard",
}

for _, name in ipairs(names) do
	if not remotesFolder:FindFirstChild(name) then
		local re = Instance.new("RemoteEvent")
		re.Name = name
		re.Parent = remotesFolder
	end
end
