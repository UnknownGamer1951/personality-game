-- ============================================================
--  GameConfig.lua  ← ONLY FILE YOU NEED TO EDIT PER GAME
-- ============================================================

local GameConfig = {}

-- Game branding
GameConfig.GameTitle = "What Type of Person Are You?"
GameConfig.WaitTimeSeconds = 600  -- 10 minutes

-- Robux developer product IDs (create these in Creator Dashboard)
-- Set to 0 until you create the products
GameConfig.Products = {
	SkipOneMinute  = 0,   -- costs whatever you set in dashboard, skips 1 min
	SkipFiveMinutes = 0,  -- skips 5 min
	ResetEveryone  = 0,   -- resets ALL other players' timers back to full (evil)
}

-- UI colors
GameConfig.Theme = {
	Background   = Color3.fromRGB(245, 239, 228),  -- cream
	ButtonNormal = Color3.fromRGB(100, 204, 197),  -- teal
	ButtonHover  = Color3.fromRGB(75, 175, 168),
	TextDark     = Color3.fromRGB(74, 60, 48),
	TextLight    = Color3.fromRGB(255, 255, 255),
	AccentGold   = Color3.fromRGB(255, 200, 50),
}

-- ============================================================
--  QUESTIONS
--  Each question has:
--    text    - the question string
--    answers - list of { text, scores }
--    scores is a table mapping personality key → points added
-- ============================================================
GameConfig.Questions = {
	{
		text = "What gender are you?",
		answers = {
			{ text = "Boy",              scores = { Explorer = 1 } },
			{ text = "Girl",             scores = { Creative = 1 } },
			{ text = "Other",            scores = { Rebel = 1 } },
			{ text = "Prefer not to say",scores = { Thinker = 1 } },
		},
	},
	{
		text = "Pick a weekend activity",
		answers = {
			{ text = "Go hiking",        scores = { Explorer = 2 } },
			{ text = "Paint or draw",    scores = { Creative = 2 } },
			{ text = "Play video games", scores = { Rebel = 1, Thinker = 1 } },
			{ text = "Read a book",      scores = { Thinker = 2 } },
		},
	},
	{
		text = "Your friend group is...",
		answers = {
			{ text = "Big and loud",     scores = { Explorer = 2 } },
			{ text = "Small and close",  scores = { Thinker = 2 } },
			{ text = "Chaotic and fun",  scores = { Rebel = 2 } },
			{ text = "Artsy and chill",  scores = { Creative = 2 } },
		},
	},
	{
		text = "Pick a color",
		answers = {
			{ text = "Green",            scores = { Explorer = 1, Creative = 1 } },
			{ text = "Purple",           scores = { Rebel = 1, Creative = 1 } },
			{ text = "Blue",             scores = { Thinker = 2 } },
			{ text = "Red",              scores = { Explorer = 2 } },
		},
	},
	{
		text = "How do you make decisions?",
		answers = {
			{ text = "Go with my gut",   scores = { Explorer = 2, Rebel = 1 } },
			{ text = "Overthink it",     scores = { Thinker = 3 } },
			{ text = "Ask friends",      scores = { Creative = 1, Explorer = 1 } },
			{ text = "Flip a coin",      scores = { Rebel = 3 } },
		},
	},
}

-- ============================================================
--  PERSONALITIES
--  The key must match the score keys above.
--  icon is an emoji shown on the result screen.
-- ============================================================
GameConfig.Personalities = {
	Explorer = {
		name        = "The Explorer",
		icon        = "🌍",
		description = "You're adventurous, energetic, and always chasing the next experience. You live for new places, new people, and new stories.",
		color       = Color3.fromRGB(80, 180, 80),
	},
	Creative = {
		name        = "The Creative",
		icon        = "🎨",
		description = "You see the world differently. Art, music, ideas — you bring color and imagination to everything you touch.",
		color       = Color3.fromRGB(180, 100, 200),
	},
	Thinker = {
		name        = "The Thinker",
		icon        = "🧠",
		description = "Logical, calm, and always 10 steps ahead. You analyze before you act and rarely get caught off guard.",
		color       = Color3.fromRGB(80, 130, 200),
	},
	Rebel = {
		name        = "The Rebel",
		icon        = "⚡",
		description = "Rules? What rules? You carve your own path and love shaking things up. Life's too short to be boring.",
		color       = Color3.fromRGB(220, 80, 80),
	},
}

return GameConfig
