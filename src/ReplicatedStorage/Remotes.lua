-- Creates all RemoteEvents/Functions under ReplicatedStorage.PersonalityGame.Remotes
-- Required by both server and client; safe to require multiple times.

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
	SubmitAnswers    = getOrCreate("RemoteEvent",    "SubmitAnswers",    remotesFolder),
	PurchaseProduct  = getOrCreate("RemoteEvent",    "PurchaseProduct",  remotesFolder),

	-- Server → Client
	ShowResult       = getOrCreate("RemoteEvent",    "ShowResult",       remotesFolder),
	UpdateTimer      = getOrCreate("RemoteEvent",    "UpdateTimer",      remotesFolder),
	TimerReset       = getOrCreate("RemoteEvent",    "TimerReset",       remotesFolder),

	-- Server → Client (broadcast)
	AnnounceReset    = getOrCreate("RemoteEvent",    "AnnounceReset",    remotesFolder),
}

return Remotes
