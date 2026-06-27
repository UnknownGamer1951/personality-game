local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService         = game:GetService("RunService")
local RS                 = game:GetService("ReplicatedStorage")

local Config  = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes = require(RS:WaitForChild("PersonalityGame"):WaitForChild("RemoteRefs"))

local TOTAL        = Config.WaitTimeSeconds
local GROUP_ID     = Config.GroupId or 0
local FRIEND_BONUS = Config.FriendSpeedBonus or 0.15

-- userId → { remaining, speed, likedGame }
local playerData = {}

local function getGroupMultiplier(player)
	if GROUP_ID == 0 then return 1 end
	local ok, inGroup = pcall(function() return player:IsInGroup(GROUP_ID) end)
	return (ok and inGroup) and 1.5 or 1
end

local function recalcSpeeds()
	local count = #Players:GetPlayers()
	local friendBonus = math.max(0, count - 1) * FRIEND_BONUS
	for userId, data in pairs(playerData) do
		local player = Players:GetPlayerByUserId(userId)
		if player then
			local groupMult = getGroupMultiplier(player)
			data.speed = (1 + friendBonus) * groupMult
			Remotes.UpdateSpeed:FireClient(player, data.speed, count)
		end
	end
end

local function startTimer(player)
	playerData[player.UserId] = { remaining = TOTAL, speed = 1, likedGame = false }
	recalcSpeeds()
	Remotes.UpdateTimer:FireClient(player, TOTAL)
end

Players.PlayerAdded:Connect(function(player)
	player:GetAttributeChangedSignal("TimerStarted"):Connect(function()
		if player:GetAttribute("TimerStarted") then startTimer(player) end
	end)
	task.delay(1, recalcSpeeds)
end)

Players.PlayerRemoving:Connect(function(player)
	playerData[player.UserId] = nil
	task.delay(1, recalcSpeeds)
end)

-- Tick loop
local elapsed = 0
RunService.Heartbeat:Connect(function(dt)
	elapsed = elapsed + dt
	if elapsed < 1 then return end
	local tick = elapsed
	elapsed = 0
	for userId, data in pairs(playerData) do
		if data.remaining <= 0 then
			playerData[userId] = nil
		else
			data.remaining = math.max(0, data.remaining - (tick * data.speed))
			local player = Players:GetPlayerByUserId(userId)
			if player then
				Remotes.UpdateTimer:FireClient(player, data.remaining)
				if data.remaining <= 0 then
					player:SetAttribute("QuizCompleted", (player:GetAttribute("QuizCompleted") or 0) + 1)
				end
			end
		end
	end
end)

-- Like game: one-time -1 minute
Remotes.LikeGame.OnServerEvent:Connect(function(player)
	local data = playerData[player.UserId]
	if not data or data.likedGame then return end
	data.likedGame = true
	data.remaining = math.max(0, data.remaining - 60)
	Remotes.UpdateTimer:FireClient(player, data.remaining)
end)

-- Robux purchases
local function skipTime(player, seconds)
	local data = playerData[player.UserId]
	if not data then return end
	data.remaining = math.max(0, data.remaining - seconds)
	Remotes.UpdateTimer:FireClient(player, data.remaining)
end

local function resetEveryone(instigator)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= instigator then
			local data = playerData[player.UserId]
			if data then
				data.remaining = TOTAL
				Remotes.UpdateTimer:FireClient(player, TOTAL)
				Remotes.TimerReset:FireClient(player, instigator.DisplayName)
			end
		end
	end
	Remotes.AnnounceReset:FireAllClients(instigator.DisplayName)
end

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end
	local id = receiptInfo.ProductId
	local P  = Config.Products
	if P.SkipOneMinute ~= 0 and id == P.SkipOneMinute then skipTime(player, 60)
	elseif P.SkipFiveMinutes ~= 0 and id == P.SkipFiveMinutes then skipTime(player, 300)
	elseif P.ResetEveryone ~= 0 and id == P.ResetEveryone then resetEveryone(player)
	end
	return Enum.ProductPurchaseDecision.PurchaseGranted
end
