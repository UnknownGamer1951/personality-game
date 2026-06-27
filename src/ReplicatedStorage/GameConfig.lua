-- ============================================================
--  GameConfig.lua  ← ONLY FILE YOU NEED TO EDIT PER GAME
-- ============================================================

local GameConfig = {}

GameConfig.GameTitle       = "What Animal Are You?"
GameConfig.WaitTimeSeconds = 600  -- 10 minutes

-- Group ID for "Join Group for 1.5x speed" (set to your group ID after creating one, 0 = disabled)
GameConfig.GroupId = 0

-- Set this to your published game URL
GameConfig.GameUrl = "https://www.roblox.com/games/0"

-- How much each extra player speeds up the timer (0.1 = +10% per player)
GameConfig.FriendSpeedBonus = 0.15

GameConfig.Products = {
	SkipOneMinute   = 0,
	SkipFiveMinutes = 0,
	ResetEveryone   = 0,
}

GameConfig.Theme = {
	Background   = Color3.fromRGB(245, 239, 228),
	ButtonNormal = Color3.fromRGB(100, 204, 197),
	ButtonHover  = Color3.fromRGB(75, 175, 168),
	TextDark     = Color3.fromRGB(74, 60, 48),
	TextLight    = Color3.fromRGB(255, 255, 255),
}

-- ============================================================
--  RARITY TIERS  (used by personalities below)
-- ============================================================
GameConfig.Rarities = {
	Common = {
		label = "Common",
		color = Color3.fromRGB(160, 160, 160),
		stars = "★☆☆☆☆",
	},
	Uncommon = {
		label = "Uncommon",
		color = Color3.fromRGB(80, 180, 80),
		stars = "★★☆☆☆",
	},
	Rare = {
		label = "Rare",
		color = Color3.fromRGB(60, 120, 220),
		stars = "★★★☆☆",
	},
	Epic = {
		label = "Epic",
		color = Color3.fromRGB(160, 60, 220),
		stars = "★★★★☆",
	},
	Legendary = {
		label = "Legendary",
		color = Color3.fromRGB(255, 185, 0),
		stars = "★★★★★",
	},
}

-- ============================================================
--  QUESTIONS
--  Each answer's scores table maps animal key → points.
-- ============================================================
GameConfig.Questions = {
	{
		text = "Pick a place to spend your day",
		answers = {
			{ text = "The open ocean",         scores = { Dolphin = 2 } },
			{ text = "A dense forest",         scores = { Wolf = 2 } },
			{ text = "A mountain peak",        scores = { Eagle = 2 } },
			{ text = "A hidden cave",          scores = { Bear = 2, Dragon = 1 } },
		},
	},
	{
		text = "How do you handle a problem?",
		answers = {
			{ text = "Talk it out",            scores = { Dolphin = 2 } },
			{ text = "Attack it head on",      scores = { Lion = 2, Wolf = 1 } },
			{ text = "Outsmart it",            scores = { Fox = 2 } },
			{ text = "Wait for the right moment", scores = { Bear = 2, Dragon = 1 } },
		},
	},
	{
		text = "Pick a superpower",
		answers = {
			{ text = "Breathe underwater",     scores = { Dolphin = 2 } },
			{ text = "Flight",                 scores = { Eagle = 2, Butterfly = 1 } },
			{ text = "Breathe fire",           scores = { Dragon = 2 } },
			{ text = "Super strength",         scores = { Bear = 2, Lion = 1 } },
		},
	},
	{
		text = "Your friend group is...",
		answers = {
			{ text = "Big, loud, always together", scores = { Dolphin = 2, Wolf = 1 } },
			{ text = "A tight loyal pack",     scores = { Wolf = 2 } },
			{ text = "I'm the leader, they follow", scores = { Lion = 2 } },
			{ text = "Just one or two close ones", scores = { Fox = 1, Bear = 1, Eagle = 1 } },
		},
	},
	{
		text = "Pick an element",
		answers = {
			{ text = "Water",                  scores = { Dolphin = 2 } },
			{ text = "Earth",                  scores = { Bear = 2, Wolf = 1 } },
			{ text = "Fire",                   scores = { Dragon = 2, Lion = 1 } },
			{ text = "Wind",                   scores = { Eagle = 2, Butterfly = 1 } },
		},
	},
	{
		text = "What do you do on a lazy Sunday?",
		answers = {
			{ text = "Play games with friends", scores = { Dolphin = 2 } },
			{ text = "Sleep as long as possible", scores = { Bear = 3 } },
			{ text = "Go on a long hike",      scores = { Wolf = 2, Eagle = 1 } },
			{ text = "Sit in the sun and just vibe", scores = { Butterfly = 2, Lion = 1 } },
		},
	},
	{
		text = "Someone disrespects you. You...",
		answers = {
			{ text = "Laugh it off",           scores = { Dolphin = 2 } },
			{ text = "Roar back immediately",  scores = { Lion = 3 } },
			{ text = "Plan your revenge slowly", scores = { Fox = 2, Dragon = 1 } },
			{ text = "Give one warning, then strike", scores = { Wolf = 2, Bear = 1 } },
		},
	},
	{
		text = "Pick a vibe",
		answers = {
			{ text = "Playful and social",     scores = { Dolphin = 2 } },
			{ text = "Calm but dangerous",     scores = { Bear = 2, Dragon = 1 } },
			{ text = "Free and independent",   scores = { Eagle = 2, Butterfly = 1 } },
			{ text = "Cunning and quick",      scores = { Fox = 3 } },
		},
	},
	{
		text = "Your dream ability in a fight?",
		answers = {
			{ text = "Outsmart and dodge everything", scores = { Fox = 2, Dolphin = 1 } },
			{ text = "Summon fire and wings",  scores = { Dragon = 3 } },
			{ text = "Overwhelm with pure power", scores = { Bear = 2, Lion = 1 } },
			{ text = "Strike from above, unseen", scores = { Eagle = 2 } },
		},
	},
	{
		text = "What rare quality do people secretly notice about you?",
		answers = {
			{ text = "You make everyone feel included", scores = { Dolphin = 2 } },
			{ text = "You're impossible to read", scores = { Dragon = 2, Fox = 1 } },
			{ text = "You notice every tiny detail", scores = { Eagle = 2, Butterfly = 1 } },
			{ text = "You're quiet until it matters", scores = { Wolf = 2, Bear = 1 } },
		},
	},
}

-- ============================================================
--  PERSONALITIES
--  rarity     - key into GameConfig.Rarities
--  rarityPct  - displayed as "Only X% of players get this"
-- ============================================================
GameConfig.Personalities = {
	Dolphin = {
		name       = "The Dolphin",
		icon       = "🐬",
		rarity     = "Common",
		rarityPct  = 22,
		description = "Social, clever, and always having fun. You light up every room and make friends wherever you go. Life's a game and you're winning it.",
		color      = Color3.fromRGB(60, 160, 210),
	},
	Bear = {
		name       = "The Bear",
		icon       = "🐻",
		rarity     = "Common",
		rarityPct  = 20,
		description = "Calm, powerful, and deeply chill — until someone pushes you too far. You conserve your energy for what matters and crush it when it counts.",
		color      = Color3.fromRGB(160, 100, 60),
	},
	Wolf = {
		name       = "The Wolf",
		icon       = "🐺",
		rarity     = "Uncommon",
		rarityPct  = 18,
		description = "Fierce, loyal, and built for the pack. You lead from the front and would do anything for the people you trust.",
		color      = Color3.fromRGB(100, 100, 180),
	},
	Lion = {
		name       = "The Lion",
		icon       = "🦁",
		rarity     = "Uncommon",
		rarityPct  = 15,
		description = "Born to lead. You command respect without trying and you don't flinch when things get hard. Everyone knows who's in charge.",
		color      = Color3.fromRGB(220, 160, 40),
	},
	Fox = {
		name       = "The Fox",
		icon       = "🦊",
		rarity     = "Rare",
		rarityPct  = 12,
		description = "Clever, quick, and always three steps ahead. You use your brain as your greatest weapon and you almost never lose.",
		color      = Color3.fromRGB(220, 100, 40),
	},
	Eagle = {
		name       = "The Eagle",
		icon       = "🦅",
		rarity     = "Rare",
		rarityPct  = 8,
		description = "Sharp-eyed and independent. You see what others miss and you're not afraid to fly alone. Precision and freedom define everything you do.",
		color      = Color3.fromRGB(80, 150, 60),
	},
	Butterfly = {
		name       = "The Butterfly",
		icon       = "🦋",
		rarity     = "Epic",
		rarityPct  = 4,
		description = "Rare, beautiful, and always transforming. You seem gentle but you carry more depth than anyone expects. People underestimate you — their loss.",
		color      = Color3.fromRGB(180, 80, 200),
	},
	Dragon = {
		name       = "The Dragon",
		icon       = "🐉",
		rarity     = "Legendary",
		rarityPct  = 1,
		description = "Ancient power. Unmatched intensity. You are the result that almost nobody gets. You don't follow rules — you are the rule. Truly one of a kind.",
		color      = Color3.fromRGB(220, 40, 40),
	},
}

return GameConfig
