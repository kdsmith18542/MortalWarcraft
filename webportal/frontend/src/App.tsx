import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Layout from './components/Layout'
import ProtectedRoute from './components/ProtectedRoute'
import Dashboard from './pages/Dashboard'
import Killboard from './pages/Killboard'
import Map from './pages/Map'
import Market from './pages/Market'
import Warfronts from './pages/Warfronts'
import SiegeDetail from './pages/SiegeDetail'
import GuildPolitics from './pages/GuildPolitics'
import CharacterProfile from './pages/CharacterProfile'
import Shop from './pages/Shop'
import Wiki from './pages/Wiki'
import Login from './pages/Login'
import Register from './pages/Register'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/" element={<Layout />}>
          <Route index element={<Dashboard />} />
          <Route path="killboard" element={<Killboard />} />
          <Route path="map" element={<Map />} />
          <Route path="market" element={<Market />} />
          <Route path="warfronts" element={<Warfronts />} />
          <Route path="sieges/:id" element={<SiegeDetail />} />
          <Route path="politics/guild/:id" element={<GuildPolitics />} />
          <Route path="character/:name" element={<CharacterProfile />} />
          <Route path="shop" element={<ProtectedRoute><Shop /></ProtectedRoute>} />
          <Route path="wiki" element={<Wiki />} />
          <Route path="wiki/:slug" element={<Wiki />} />
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

export default App

