package models

import "time"

// Territory & Map Models
type Stronghold struct {
	ID              int       `json:"id"`
	ZoneID          int       `json:"zone_id"`
	PointName       string    `json:"point_name"`
	LocationX       float64   `json:"location_x"`
	LocationY       float64   `json:"location_y"`
	LocationZ       float64   `json:"location_z"`
	ControllingGuild int      `json:"controlling_guild"`
	GuildName       string    `json:"guild_name,omitempty"`
	TaxRate         float64   `json:"tax_rate,omitempty"`
	OwnerMessage    string    `json:"owner_message,omitempty"`
	ControlDuration int       `json:"control_duration,omitempty"`
}

type Hotspot struct {
	ZoneID    int     `json:"zone_id"`
	ZoneName  string  `json:"zone_name"`
	X         float64 `json:"x"`
	Y         float64 `json:"y"`
	DeathCount int    `json:"death_count"`
	TimeRange  string `json:"time_range"` // "24h", "week", "month"
}

// Killboard Models
type Kill struct {
	ID           int64     `json:"id"`
	KillerGUID   int       `json:"killer_guid"`
	KillerName   string    `json:"killer_name"`
	KillerGuild  string    `json:"killer_guild,omitempty"`
	VictimGUID   int       `json:"victim_guid"`
	VictimName   string    `json:"victim_name"`
	VictimGuild  string    `json:"victim_guild,omitempty"`
	ZoneID       int       `json:"zone_id"`
	ZoneName     string    `json:"zone_name"`
	LootValue    int64     `json:"loot_value"` // Gold value in copper
	Notoriety    int       `json:"notoriety"`
	IsZerg       bool      `json:"is_zerg"`
	KillTime     time.Time `json:"kill_time"`
	Items        []KillItem `json:"items,omitempty"`
}

type KillItem struct {
	ItemEntry int    `json:"item_entry"`
	ItemName  string `json:"item_name"`
	Count     int    `json:"count"`
	Value     int64  `json:"value"` // Gold value in copper
}

type Leaderboard struct {
	Type     string      `json:"type"` // "valuable", "solo", "guild", "notorious", "losses"
	Entries  []LeaderboardEntry `json:"entries"`
	TimeRange string     `json:"time_range"`
}

type LeaderboardEntry struct {
	Rank      int    `json:"rank"`
	Name      string `json:"name"`
	Guild     string `json:"guild,omitempty"`
	Value     int64  `json:"value"`
	Count     int    `json:"count,omitempty"`
}

// Market Models
type MarketItem struct {
	ItemEntry    int     `json:"item_entry"`
	ItemName     string  `json:"item_name"`
	SellerName   string  `json:"seller_name"`
	Location     string  `json:"location"`
	ZoneID       int     `json:"zone_id"`
	Price        int64   `json:"price"` // Copper
	Stock        int     `json:"stock"`
	IsRedZone    bool    `json:"is_red_zone"`
}

type PriceHistory struct {
	ItemEntry int       `json:"item_entry"`
	Date      time.Time `json:"date"`
	Price     int64     `json:"price"`
	Volume    int       `json:"volume"`
}

type ArbitrageOpportunity struct {
	ItemEntry    int     `json:"item_entry"`
	ItemName     string  `json:"item_name"`
	BuyLocation  string  `json:"buy_location"`
	BuyPrice     int64   `json:"buy_price"`
	SellLocation string  `json:"sell_location"`
	SellPrice    int64   `json:"sell_price"`
	Profit       int64   `json:"profit"`
	RiskLevel    string  `json:"risk_level"` // "low", "medium", "high"
}

// Character Models
type CharacterProfile struct {
	GUID          int       `json:"guid"`
	Name          string    `json:"name"`
	GuildID       int       `json:"guild_id,omitempty"`
	GuildName     string    `json:"guild_name,omitempty"`
	DynamicLevel  int       `json:"dynamic_level"`
	Skills        []Skill   `json:"skills"`
	TotalSkills   int       `json:"total_skills"`
	Notoriety     int       `json:"notoriety"`
	CriminalStatus string   `json:"criminal_status"` // "innocent", "thief", "murderer"
	BountyStatus  bool      `json:"bounty_status"`
	Blueprints    []Blueprint `json:"blueprints,omitempty"`
	KillDeathRatio float64   `json:"kill_death_ratio,omitempty"`
	Playtime      int        `json:"playtime,omitempty"` // Minutes
}

type Skill struct {
	SkillID   int     `json:"skill_id"`
	SkillName string  `json:"skill_name"`
	Value     float64 `json:"value"`
	MaxValue  int     `json:"max_value"`
}

type Blueprint struct {
	BlueprintID   int    `json:"blueprint_id"`
	BlueprintName string `json:"blueprint_name"`
	Type          string `json:"type"` // "BPO" (Original) or "BPC" (Copy)
	IsPublic      bool   `json:"is_public"`
}

// World Event Models
type WorldBoss struct {
	BossID    int       `json:"boss_id"`
	BossName  string   `json:"boss_name"`
	ZoneID    int       `json:"zone_id"`
	ZoneName  string   `json:"zone_name"`
	Location  string   `json:"location"`
	IsActive  bool      `json:"is_active"`
	LastSpawn time.Time `json:"last_spawn,omitempty"`
	NextSpawn time.Time `json:"next_spawn,omitempty"`
}

type MidnightHorde struct {
	IsActive    bool      `json:"is_active"`
	NextEvent   time.Time `json:"next_event"`
	LastEvent   time.Time `json:"last_event,omitempty"`
	Duration    int       `json:"duration"` // Minutes
}

// Dashboard Models
type GlobalStatus struct {
	TerritoryControl TerritoryStats `json:"territory_control"`
	ActiveBosses     []WorldBoss    `json:"active_bosses"`
	MidnightHorde    MidnightHorde  `json:"midnight_horde"`
}

type TerritoryStats struct {
	Horde       int `json:"horde"`
	Alliance    int `json:"alliance"`
	Independent int `json:"independent"`
	Total       int `json:"total"`
}

