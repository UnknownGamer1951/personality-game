local RS = game:GetService("ReplicatedStorage")
local folder = RS:WaitForChild("PersonalityGame")

local function getOrCreate(className, name, parent)
	local obj = parent:FindFirstChild(name)
	if not obj then
		obj = Instance.new(className)
		obj.Name = name
		obj.Parent = parent
	end
	return obj
end

local remotesFolder = getOrCreate("Folder", "Remotes", folder)

local Remotes = {
	-- Client → Server
	SubmitAnswers       = getOrCreate("RemoteEvent", "SubmitAnswers",       remotesFolder),
	LikeGame            = getOrCreate("RemoteEvent", "LikeGame",            remotesFolder),

	-- Server → Client
	ShowResult          = getOrCreate("RemoteEvent", "ShowResult",          remotesFolder),
	UpdateTimer         = getOrCreate("RemoteEvent", "UpdateTimer",         remotesFolder),
	UpdateSpeed         = getOrCreate("RemoteEvent", "UpdateSpeed",         remotesFolder),
	TimerReset          = getOrCreate("RemoteEvent", "TimerReset",          remotesFolder),
	AnnounceReset       = getOrCreate("RemoteEvent", "AnnounceReset",       remotesFolder),
	UpdateLeaderboard   = getOrCreate("RemoteEvent", "UpdateLeaderboard",   remotesFolder),
}

return Remotes
