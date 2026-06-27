local Players          = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RS               = game:GetService("ReplicatedStorage")

local Remotes    = require(RS:WaitForChild("PersonalityGame"):WaitForChild("RemoteRefs"))
local quizStore  = DataStoreService:GetOrderedDataStore("AnimalQuiz_Completions_v1")

-- In-memory cache: userId → { name, count }
local cache = {}

local function getTopPlayers()
	local result = {}
	local ok, pages = pcall(function()
		return quizStore:GetSortedAsync(false, 10)
	end)
	if not ok or not pages then return result end
	local top = pages:GetCurrentPage()
	for rank, entry in ipairs(top) do
		local name = "[Unknown]"
		local nameOk, n = pcall(function()
			return Players:GetNameFromUserIdAsync(tonumber(entry.key))
		end)
		if nameOk then name = n end
		table.insert(result, { rank = rank, name = name, count = entry.value })
	end
	return result
end

local function broadcastLeaderboard()
	local top = getTopPlayers()
	Remotes.UpdateLeaderboard:FireAllClients(top)
end

local function incrementCount(player)
	local userId = tostring(player.UserId)
	local current = cache[player.UserId] or 0
	local new = current + 1
	cache[player.UserId] = new

	pcall(function()
		quizStore:UpdateAsync(userId, function(old)
			return math.max(old or 0, new)
		end)
	end)
	broadcastLeaderboard()
end

Players.PlayerAdded:Connect(function(player)
	-- Load existing count
	local ok, val = pcall(function()
		return quizStore:GetAsync(tostring(player.UserId))
	end)
	cache[player.UserId] = (ok and val) or 0

	-- Send current leaderboard to new player
	task.delay(2, function()
		local top = getTopPlayers()
		Remotes.UpdateLeaderboard:FireClient(player, top)
	end)

	-- Watch for quiz completions
	player:GetAttributeChangedSignal("QuizCompleted"):Connect(function()
		incrementCount(player)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	cache[player.UserId] = nil
end)
