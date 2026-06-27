-- TimerServer.lua  (Script, runs on server)
local Players           = game:GetService("Players")
local MarketplaceService= game:GetService("MarketplaceService")
local RS                = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")

local Config  = require(RS:WaitForChild("PersonalityGame"):WaitForChild("GameConfig"))
local Remotes = require(RS:WaitForChild("PersonalityGame"):WaitForChild("Remotes"))

-- userId → remaining seconds
local timers = {}

local TICK_RATE = 1  -- update clients every second

-- Start a fresh timer for a player
local function startTimer(player)
	timers[player.UserId] = Config.WaitTimeSeconds
	Remotes.UpdateTimer:FireClient(player, timers[player.UserId])
end

-- Watch for TimerStarted attribute set by GameServer
Players.PlayerAdded:Connect(function(player)
	player:GetAttributeChangedSignal("TimerStarted"):Connect(function()
		if player:GetAttribute("TimerStarted") then
			startTimer(player)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	timers[player.UserId] = nil
end)

-- Main tick loop
local elapsed = 0
RunService.Heartbeat:Connect(function(dt)
	elapsed = elapsed + dt
	if elapsed < TICK_RATE then return end
	elapsed = 0

	for userId, remaining in pairs(timers) do
		if remaining <= 0 then
			timers[userId] = nil
		else
			timers[userId] = remaining - TICK_RATE
			local player = Players:GetPlayerByUserId(userId)
			if player then
				Remotes.UpdateTimer:FireClient(player, timers[userId])
			end
		end
	end
end)

-- ============================================================
--  Robux purchase handling
-- ============================================================
local Products = Config.Products

local function skipTime(player, seconds)
	if not timers[player.UserId] then return end
	timers[player.UserId] = math.max(0, timers[player.UserId] - seconds)
	Remotes.UpdateTimer:FireClient(player, timers[player.UserId])
end

local function resetEveryone(instigator)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= instigator and timers[player.UserId] then
			timers[player.UserId] = Config.WaitTimeSeconds
			Remotes.UpdateTimer:FireClient(player, timers[player.UserId])
			Remotes.TimerReset:FireClient(player, instigator.DisplayName)
		end
	end
	-- Tell everyone in chat who did it
	Remotes.AnnounceReset:FireAllClients(instigator.DisplayName)
end

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end

	local id = receiptInfo.ProductId

	if Products.SkipOneMinute ~= 0 and id == Products.SkipOneMinute then
		skipTime(player, 60)
	elseif Products.SkipFiveMinutes ~= 0 and id == Products.SkipFiveMinutes then
		skipTime(player, 300)
	elseif Products.ResetEveryone ~= 0 and id == Products.ResetEveryone then
		resetEveryone(player)
	end

	return Enum.ProductPurchaseDecision.PurchaseGranted
end
