# Mortal Atlas - Web Portal (Cursor-Ready Spec)
Version: 1.1  
Project: Mortal Warcraft Overhaul – External Intel Portal (“The Atlas”)  

---

## 1. Purpose & Role

**Mortal Atlas** is the **out-of-game web portal** for the Mortal Warcraft server. It is a read-heavy, intel-and-economy tool that surfaces:

- World & territory control (map overlays).
- Killfeed & killboard (ZKillboard-style).
- Market & price history (EVE Central-style).
- Character & guild profiles.
- Supporter/shop features (cosmetics, tokens, etc.).
- Forum/Discourse SSO integration.

It is designed to be:

- **Cursor-friendly** – clear structure, small focused modules, minimal magic.
- **API-first** – backend exposes clean JSON for both the Atlas frontend and possible future tools.
- **Decoupled from the game server** – reads from **Mortal telemetry DB / views** and cached snapshots, not directly from live AC processes.

---

## Related Specs

For full context on the Atlas web portal, see:

- **`49-webportal-wiki-spec.md`** — Wiki system integrated into Atlas
- **`91-mortal-anomalies-rifts-hellgates.md`** — Anomalies and rifts that Atlas provides scanning for
- **`58-world-contracts-and-map-pins.md`** — Map pins and world contracts displayed in Atlas
- **`99-mortal-faction-meta-civic-frontier-cartel-atlas.md`** — Atlas Consortium faction that operates the portal
- **`08-guilds-sovereignty.md`** — Stronghold and territory control displayed in Atlas maps
- **`11-pvp-systems.md`** — PvP systems (killboard) displayed in Atlas
- **`04-economy.md`** — Economy system (market data) displayed in Atlas

---

## 2. Tech Stack

**Frontend**

- React + TypeScript + Vite
- Tailwind CSS
- Zustand (state management)
- React Router
- React Query (data fetching/cache)
- Axios (HTTP client)
- Leaflet (interactive map)

**Backend**

- Go 1.22+
- Gin (HTTP framework)
- GORM (ORM) with MySQL driver
- JWT for auth
- Viper (config)
- Zap / logrus (logging, optional)
- CORS middleware

**Database**

- MySQL (can be same server as AzerothCore, separate DB/schema is recommended)
- Read-only views into:
  - Kills / deaths telemetry
  - Territory ownership
  - Market data
  - Character/guild summaries

---

## 3. Repository Layout

Root folder: `mortal-atlas/`

```bash
mortal-atlas/
├── backend/
│   ├── cmd/
│   │   └── atlas-api/
│   │       └── main.go
│   ├── go.mod
│   ├── go.sum
│   └── internal/
│       ├── api/          # HTTP routes + handlers
│       │   ├── auth/
│       │   │   └── auth_handlers.go
│       │   ├── kills/
│       │   │   └── kills_handlers.go
│       │   ├── map/
│       │   │   └── map_handlers.go
│       │   ├── market/
│       │   │   └── market_handlers.go
│       │   ├── profiles/
│       │   │   └── profiles_handlers.go
│       │   ├── shop/
│       │   │   └── shop_handlers.go
│       │   └── router.go
│       ├── config/
│       │   └── config.go
│       ├── database/
│       │   ├── db.go
│       │   └── migrations/  # optional SQL migrations
│       ├── middleware/
│       │   ├── auth_middleware.go
│       │   └── cors_middleware.go
│       ├── models/
│       │   ├── user.go
│       │   ├── kill.go
│       │   ├── territory.go
│       │   ├── market.go
│       │   ├── character.go
│       │   └── guild.go
│       ├── services/
│       │   ├── auth_service.go
│       │   ├── kill_service.go
│       │   ├── map_service.go
│       │   ├── market_service.go
│       │   ├── profile_service.go
│       │   └── shop_service.go
│       └── util/
│           ├── jwt.go
│           ├── password.go
│           └── responses.go
├── frontend/
│   ├── index.html
│   ├── package.json
│   ├── tsconfig.json
│   ├── vite.config.ts
│   └── src/
│       ├── main.tsx
│       ├── App.tsx
│       ├── lib/
│       │   ├── apiClient.ts
│       │   └── queryClient.ts
│       ├── routes/
│       │   ├── Router.tsx
│       │   └── ProtectedRoute.tsx
│       ├── pages/
│       │   ├── DashboardPage.tsx
│       │   ├── LoginPage.tsx
│       │   ├── KillboardPage.tsx
│       │   ├── MapPage.tsx
│       │   ├── MarketPage.tsx
│       │   ├── CharacterPage.tsx
│       │   ├── GuildPage.tsx
│       │   └── ShopPage.tsx
│       ├── components/
│       │   ├── layout/
│       │   │   ├── Sidebar.tsx
│       │   │   ├── Topbar.tsx
│       │   │   └── Layout.tsx
│       │   ├── map/
│       │   │   ├── AtlasMap.tsx
│       │   │   └── TerritoryLegend.tsx
│       │   ├── kills/
│       │   │   └── KillTable.tsx
│       │   ├── market/
│       │   │   └── MarketTable.tsx
│       │   ├── profiles/
│       │   │   ├── CharacterSummary.tsx
│       │   │   └── GuildSummary.tsx
│       │   └── common/
│       │       ├── Loader.tsx
│       │       ├── ErrorState.tsx
│       │       └── Card.tsx
│       ├── stores/
│       │   ├── authStore.ts
│       │   └── uiStore.ts
│       ├── styles/
│       │   └── index.css
│       └── types/
│           ├── api.ts
│           ├── kill.ts
│           ├── map.ts
│           ├── market.ts
│           └── profiles.ts
└── docs/
    └── WEBPORTAL_SPEC_THE_ATLAS.md   # This file, or a link to it
```

---

## 4. Backend – Detailed Design

### 4.1 Config & Bootstrap

`backend/cmd/atlas-api/main.go` (Cursor starter outline):

```go
package main

import (
    "log"

    "github.com/yourorg/mortal-atlas/internal/api"
    "github.com/yourorg/mortal-atlas/internal/config"
    "github.com/yourorg/mortal-atlas/internal/database"
)

func main() {
    cfg, err := config.Load()
    if err != nil {
        log.Fatalf("failed to load config: %v", err)
    }

    db, err := database.Connect(cfg)
    if err != nil {
        log.Fatalf("failed to connect to database: %v", err)
    }

    r := api.SetupRouter(cfg, db)

    if err := r.Run(":" + cfg.ServerPort); err != nil {
        log.Fatalf("server failed: %v", err)
    }
}
```

`config/config.go`:

- Reads from env:
  - `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME`
  - `JWT_SECRET`
  - `SERVER_PORT`
  - `FRONTEND_URL`
- Optionally uses Viper.

---

### 4.2 Models

#### User (for Atlas, not game account)

`models/user.go`:

```go
type User struct {
    ID        uint      `gorm:"primaryKey"`
    Email     string    `gorm:"uniqueIndex"`
    Password  string    // bcrypt hash
    Role      string    // "user", "admin"
    CreatedAt time.Time
}
```

#### Kill

`models/kill.go`:

```go
type Kill struct {
    ID            uint      `gorm:"primaryKey"`
    Timestamp     time.Time `gorm:"index"`
    KillerName    string
    KillerGuild   string
    VictimName    string
    VictimGuild   string
    ZoneID        int
    ZoneName      string
    Value         int64  // estimated loot value in gold
    IsRedZone     bool
}
```

Source: a **view** or ETL job from game telemetry.

#### Territory

`models/territory.go`:

```go
type Territory struct {
    ID           uint   `gorm:"primaryKey"`
    ZoneID       int    `gorm:"uniqueIndex"`
    ZoneName     string
    ControllingGuild string
    ControllingFaction string
    LastChanged  time.Time
    // Optional: polygon / region key for frontend map
}
```

#### Market

`models/market.go`:

```go
type MarketPrice struct {
    ID        uint      `gorm:"primaryKey"`
    ItemID    int       `gorm:"index:idx_item_time"`
    ItemName  string
    Region    string    `gorm:"index"`
    AvgPrice  float64
    MinPrice  float64
    MaxPrice  float64
    Volume    int64
    Timestamp time.Time `gorm:"index:idx_item_time"`
}
```

#### Character & Guild Summary

`models/character.go` / `models/guild.go`:

- Store **denormalized snapshots** for portal usage.

---

### 4.3 API Routes (High-Level)

Base URL: `/api`

- `POST /api/auth/login` – JWT login (Atlas account or SSO).
- `POST /api/auth/refresh` – refresh token.
- `GET /api/auth/me` – current user profile.

- `GET /api/kills` – paginated killboard.
  - Query params: `page`, `pageSize`, `guild`, `player`, `zone`, `from`, `to`.
- `GET /api/kills/:id` – kill detail.

- `GET /api/map/territories` – list of territories + controlling guild.
- `GET /api/map/hotspots` – aggregated recent kill hotspots.

- `GET /api/market/prices` – filtered price data.
  - Query: `itemID`, `region`, `from`, `to`.
- `GET /api/market/top-movers` – big price changes.

- `GET /api/profiles/characters/:name` – character profile.
- `GET /api/profiles/guilds/:name` – guild profile.
- `GET /api/profiles/guilds/:name/members` – member list.

- `GET /api/shop/items` – list of store items (supporter, cosmetics).
- `POST /api/shop/checkout` – placeholder; integrate with payment provider later.

---

### 4.4 Example Handler Outline

`internal/api/kills/kills_handlers.go`:

```go
package kills

import (
    "net/http"

    "github.com/gin-gonic/gin"
)

type KillService interface {
    ListKills(params ListParams) ([]KillDTO, int64, error)
}

func RegisterRoutes(r *gin.RouterGroup, svc KillService) {
    r.GET("/kills", func(c *gin.Context) {
        params := parseListParams(c)
        kills, total, err := svc.ListKills(params)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "internal_error"})
            return
        }
        c.JSON(http.StatusOK, gin.H{
            "data":  kills,
            "total": total,
        })
    })
}
```

`internal/services/kill_service.go` handles querying GORM with filters.

---

## 5. Frontend – Detailed Design

### 5.1 Routing

`src/routes/Router.tsx`:

- Public routes:
  - `/login`
  - `/killboard`
  - `/map`
  - `/market`
  - `/character/:name`
  - `/guild/:name`
- Protected routes (require JWT in `authStore`):
  - `/dashboard`
  - `/shop` (if you want it gated)
  - `/admin/*` (future)

Use `ProtectedRoute` wrapper.

---

### 5.2 State & Data

- `authStore.ts` (Zustand):
  - Holds `accessToken`, `user`, `login`, `logout`, `refresh`.
- `uiStore.ts`:
  - Simple UI prefs: theme, sidebar collapsed, etc.

- `apiClient.ts`:
  - Axios instance with baseURL `/api`, interceptors for JWT.
- `queryClient.ts`:
  - React Query client with sensible defaults.

---

### 5.3 Core Pages

#### DashboardPage

- High-level summary:
  - Recent kills (table).
  - Current top guilds by territory.
  - Market movers.

#### KillboardPage

- Filters:
  - Text inputs for player/guild.
  - Drop-down for zone.
  - Time-range selector.
- Table:
  - Killer, Victim, Zone, Time, Value.
- Pagination.

#### MapPage

- Uses Leaflet + `AtlasMap` component.
- Overlays territories:
  - Colors by controlling guild/faction.
- Sidebar:
  - List of territories.
  - Clicking highlights on map.
- Uses `/api/map/territories` and `/api/map/hotspots`.

#### MarketPage

- Search bar by item name.
- Region selector.
- Price history sparkline chart (per item).
- Table with avg/min/max and volume.

#### CharacterPage / GuildPage

- Pulls from `/api/profiles/*`.
- Shows:
  - Recent kills/deaths (for character).
  - Territory ownership, wars, top killers (for guild).

#### ShopPage

- Lists store items from `/api/shop/items`.
- Click to purchase (stubbed for now).

---

## 6. Environment & Local Dev

### 6.1 Backend

Env vars (for `.env` or system):

```bash
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASS=password
DB_NAME=mortal_atlas
JWT_SECRET=your-secret-key
SERVER_PORT=8080
FRONTEND_URL=http://localhost:5173
```

Run:

```bash
cd backend
go mod tidy
go run ./cmd/atlas-api
```

### 6.2 Frontend

```bash
cd frontend
npm install
npm run dev
```

By default, Vite uses port 5173. Configure a dev proxy in `vite.config.ts`:

```ts
server: {
  proxy: {
    '/api': {
      target: 'http://localhost:8080',
      changeOrigin: true,
    },
  },
},
```

---

## 7. Cursor Tasks (Suggested)

This section is just to help you drive Cursor agents.

### 7.1 Backend Tasks

1. **Initialize Go module & basic main.go.**
2. Implement `config.Load()` using env + sane defaults.
3. Implement `database.Connect()` with GORM + MySQL.
4. Implement `api.SetupRouter()`:
   - Global middleware (CORS, logging, recovery).
   - Route groups for `/auth`, `/kills`, `/map`, `/market`, `/profiles`, `/shop`.
5. Scaffold models for `User`, `Kill`, `Territory`, `MarketPrice`, `Character`, `Guild`.
6. Implement:
   - `AuthService` (basic email/password; SSO hooks later).
   - `KillService` with pagination + filters.
   - `MapService` returning territories.
   - `MarketService` returning recent price rows.
   - `ProfileService` returning character/guild summary DTOs.

### 7.2 Frontend Tasks

1. Create React+TS+Vite project with Tailwind and React Router.
2. Implement `authStore` and `apiClient` with JWT hooks.
3. Implement basic layout (`Sidebar`, `Topbar`, `Layout`).
4. Implement pages:
   - `LoginPage`, `DashboardPage`.
   - `KillboardPage` with React Query + table.
   - `MapPage` with Leaflet.
   - `MarketPage` with a table and a placeholder chart component.
5. Add reusable components: `Loader`, `ErrorState`, `Card`.

---

## 8. Status

- This file is the **Cursor-ready technical spec** for the Mortal Atlas web portal.
- It supersedes earlier minimal notes and should live at:

`docs/WEBPORTAL_SPEC_THE_ATLAS.md`

in your repo, or you can keep it as `24-webportal-mortal-atlas.md` and reference it there.
