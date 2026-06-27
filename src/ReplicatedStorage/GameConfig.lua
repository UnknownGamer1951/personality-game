-- ============================================================
--  GameConfig.lua  ← ONLY FILE YOU NEED TO EDIT PER GAME
-- ============================================================

local GameConfig = {}

-- Game branding
GameConfig.GameTitle = "What Animal Are You?"
GameConfig.WaitTimeSeconds = 600  -- 10 minutes

-- Robux developer product IDs (create these in Creator Dashboard)
-- Set to 0 until you create the products
GameConfig.Products = {
	SkipOneMinute   = 0,  -- skips 1 min off your timer
	SkipFiveMinutes = 0,  -- skips 5 min off your timer
	ResetEveryone   = 0,  -- resets ALL other players' timers back to full (evil)
}

-- UI colors
GameConfig.Theme = {
	Background   = Color3.fromRGB(245, 239, 228),
	ButtonNormal = Color3.fromRGB(100, 204, 197),
	ButtonHover  = Color3.fromRGB(75, 175, 168),
	TextDark     = Color3.fromRGB(74, 60, 48),
	TextLight    = Color3.fromRGB(255, 255, 255),
	AccentGold   = Color3.fromRGB(255, 200, 50),
}

-- ============================================================
--  QUESTIONS
-- ============================================================
GameConfig.Questions = {
	{
		text = "Pick a place to hang out",
		answers = {
			{ text = "Deep in the forest",    scores = { Wolf = 2 } },
			{ text = "A sunny open field",    scores = { Eagle = 2 } },
			{ text = "Near the ocean",        scores = { Dolphin = 2 } },
			{ text = "A cozy cave or den",    scores = { Bear = 2 } },
		},
	},
	{
		text = "How do you handle problems?",
		answers = {
			{ text = "Attack head-on",        scores = { Wolf = 2, Bear = 1 } },
			{ text = "Get a birds-eye view",  scores = { Eagle = 2 } },
			{ text = "Talk it out",           scores = { Dolphin = 2 } },
			{ text = "Wait and be patient",   scores = { Bear = 2 } },
		},
	},
	{
		text = "Your ideal Friday night?",
		answers = {
			{ text = "Howling with friends",  scores = { Wolf = 2 } },
			{ text = "Soaring solo",          scores = { Eagle = 2 } },
			{ text = "Playing in the water",  scores = { Dolphin = 2 } },
			{ text = "Eating and sleeping",   scores = { Bear = 3 } },
		},
	},
	{
		text = "Pick a superpower",
		answers = {
			{ text = "Super speed",           scores = { Wolf = 2 } },
			{ text = "Flight",                scores = { Eagle = 2 } },
			{ text = "Talk to animals",       scores = { Dolphin = 2 } },
			{ text = "Super strength",        scores = { Bear = 2 } },
		},
	},
	{
		text = "How do your friends describe you?",
		answers = {
			{ text = "Loyal and fierce",      scores = { Wolf = 3 } },
			{ text = "Sharp and focused",     scores = { Eagle = 3 } },
			{ text = "Fun and social",        scores = { Dolphin = 3 } },
			{ text = "Calm but powerful",     scores = { Bear = 3 } },
		},
	},
	{
		text = "What do you do when someone messes with you?",
		answers = {
			{ text = "Fight back immediately",scores = { Wolf = 2, Bear = 1 } },
			{ text = "Watch from a distance", scores = { Eagle = 2 } },
			{ text = "Try to make peace",     scores = { Dolphin = 2 } },
			{ text = "Ignore it... for now",  scores = { Bear = 2 } },
		},
	},
	{
		text = "Pick a snack",
		answers = {
			{ text = "Meat",                  scores = { Wolf = 2 } },
			{ text = "Fish",                  scores = { Eagle = 2, Bear = 1 } },
			{ text = "Seafood",               scores = { Dolphin = 2 } },
			{ text = "Honey and berries",     scores = { Bear = 2 } },
		},
	},
}

-- ============================================================
--  PERSONALITIES
-- ============================================================
GameConfig.Personalities = {
	Wolf = {
		name        = "The Wolf",
		icon        = "🐺",
		description = "Fierce, loyal, and built for the pack. You lead from the front and never leave your people behind. When things get tough, you get tougher.",
		color       = Color3.fromRGB(100, 100, 160),
	},
	Eagle = {
		name        = "The Eagle",
		icon        = "🦅",
		description = "Sharp-eyed and independent. You see what others miss and you're not afraid to fly alone. Precision and freedom define you.",
		color       = Color3.fromRGB(200, 140, 40),
	},
	Dolphin = {
		name        = "The Dolphin",
		icon        = "🐬",
		description = "Social, clever, and always having fun. You light up every room and make friends wherever you go. Life's a game and you're winning.",
		color       = Color3.fromRGB(60, 160, 210),
	},
	Bear = {
		name        = "The Bear",
		icon        = "🐻",
		description = "Calm, powerful, and deeply chill — until someone pushes you too far. You conserve your energy for what matters and crush it when it counts.",
		color       = Color3.fromRGB(160, 100, 60),
	},
}

return GameConfig
