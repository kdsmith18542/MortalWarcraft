# Mortal Atlas - Web Portal

Web portal for Mortal Warcraft Overhaul ("The Atlas") - Intel tool for sandbox economy and war.

## Tech Stack

- **Frontend:** React + TypeScript + Vite + Tailwind CSS
- **Backend:** Go + Gin + MySQL
- **Mapping:** Leaflet
- **State Management:** Zustand
- **API Client:** Axios + React Query

## Project Structure

```
webportal/
├── backend/          # Go API server
│   ├── main.go
│   ├── go.mod
│   └── internal/
│       ├── api/      # API routes and handlers
│       ├── config/   # Configuration
│       ├── database/ # Database connection
│       ├── models/   # Data models
│       └── services/ # Business logic
└── frontend/         # React application
    ├── src/
    │   ├── components/
    │   ├── pages/
    │   ├── stores/
    │   └── App.tsx
    └── package.json
```

## Setup

### Backend

```bash
cd backend
go mod download
go run main.go
```

Environment variables:
```bash
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASS=password
DB_NAME=azerothcore_world
JWT_SECRET=your-secret-key
PORT=8080
FRONTEND_URL=http://localhost:3000
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

## Features

### Implemented
- ✅ Project structure
- ✅ Basic routing
- ✅ Layout and navigation
- ✅ Dashboard placeholder
- ✅ API structure (handlers stubbed)

### To Implement
- [ ] Authentication (JWT)
- [ ] Killboard (ZKillboard clone)
- [ ] Interactive map with territory overlays
- [ ] Market tracker (EVE Central clone)
- [ ] Character profiles
- [ ] Shop (monetization)
- [ ] Discourse SSO integration

## API Endpoints

See `docs/WEBPORTAL_SPEC_THE_ATLAS.md` for full API specification.

## Development

Backend runs on port 8080, frontend on port 3000. Frontend proxies `/api` requests to backend.

## Status

**Current:** Scaffold complete, ready for feature implementation.

