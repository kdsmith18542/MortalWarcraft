import { useEffect, useState, useRef } from 'react'
import { MapContainer, TileLayer, Marker, Popup, Circle, useMap } from 'react-leaflet'
import L from 'leaflet'
import apiClient from '../lib/apiClient'
import 'leaflet/dist/leaflet.css'

// Fix for default marker icons in React-Leaflet
delete (L.Icon.Default.prototype as any)._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon-2x.png',
  iconUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png',
})

interface Stronghold {
  id: number
  zone_id: number
  point_name: string
  location_x: number
  location_y: number
  location_z: number
  controlling_guild?: number
  guild_name?: string
  tax_rate?: number
  owner_message?: string
  control_duration?: number
}

interface Hotspot {
  zone_id: number
  zone_name: string
  x: number
  y: number
  death_count: number
  time_range: string
}

// Zone ID to approximate map coordinates (simplified mapping)
// In a real implementation, you'd use proper zone-to-world coordinates
const ZONE_COORDINATES: { [key: number]: [number, number] } = {
  45: [0, 0],      // Arathi Highlands
  47: [100, 100],  // The Hinterlands
  139: [-100, -100], // Eastern Plaguelands
  28: [-50, -50],  // Western Plaguelands
  3: [-200, 0],    // Badlands
}

export default function Map() {
  const [strongholds, setStrongholds] = useState<Stronghold[]>([])
  const [hotspots, setHotspots] = useState<Hotspot[]>([])
  const [loading, setLoading] = useState(true)
  const [showHotspots, setShowHotspots] = useState(false)
  const [showStrongholds, setShowStrongholds] = useState(true)

  useEffect(() => {
    fetchStrongholds()
    fetchHotspots()
  }, [])

  const fetchStrongholds = async () => {
    try {
      const res = await apiClient.get('/territory/strongholds')
      setStrongholds(res.data.strongholds || [])
    } catch (err) {
      console.error('Failed to fetch strongholds:', err)
    } finally {
      setLoading(false)
    }
  }

  const fetchHotspots = async () => {
    try {
      const res = await apiClient.get('/map/hotspots?range=24h')
      setHotspots(res.data.hotspots || [])
    } catch (err) {
      console.error('Failed to fetch hotspots:', err)
    }
  }

  // Convert zone coordinates to map coordinates (simplified)
  const getMapCoordinates = (zoneId: number, x: number, y: number): [number, number] => {
    // This is a simplified conversion - in reality you'd need proper zone-to-world mapping
    const baseCoords = ZONE_COORDINATES[zoneId] || [0, 0]
    // Scale coordinates (WoW coordinates are large, map coordinates are smaller)
    const scale = 0.001
    return [baseCoords[0] + x * scale, baseCoords[1] + y * scale]
  }

  // Get color based on guild/faction
  const getStrongholdColor = (stronghold: Stronghold): string => {
    if (!stronghold.controlling_guild) {
      return '#808080' // Gray for independent
    }
    // In a real implementation, check guild faction
    return '#8B4513' // Brown for now
  }

  if (loading) {
    return (
      <div className="px-4 py-6">
        <div className="text-center py-12">Loading map...</div>
      </div>
    )
  }

  return (
    <div className="px-4 py-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Territory Map</h1>
        <div className="flex gap-4">
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={showStrongholds}
              onChange={(e) => setShowStrongholds(e.target.checked)}
              className="w-4 h-4"
            />
            <span>Strongholds</span>
          </label>
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={showHotspots}
              onChange={(e) => setShowHotspots(e.target.checked)}
              className="w-4 h-4"
            />
            <span>PvP Hotspots</span>
          </label>
        </div>
      </div>

      <div className="bg-mortal-dark rounded-lg border border-mortal-accent overflow-hidden" style={{ height: '600px' }}>
        <MapContainer
          center={[0, 0]}
          zoom={2}
          style={{ height: '100%', width: '100%' }}
        >
          <TileLayer
            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          />

          {showStrongholds && strongholds.map((stronghold) => {
            const coords = getMapCoordinates(stronghold.zone_id, stronghold.location_x, stronghold.location_y)
            return (
              <Marker key={stronghold.id} position={coords}>
                <Popup>
                  <div className="text-black">
                    <h3 className="font-bold mb-2">{stronghold.point_name}</h3>
                    <p className="text-sm">Zone: {stronghold.zone_id}</p>
                    {stronghold.guild_name && (
                      <p className="text-sm">Guild: {stronghold.guild_name}</p>
                    )}
                    {stronghold.tax_rate && (
                      <p className="text-sm">Tax Rate: {stronghold.tax_rate}%</p>
                    )}
                    {stronghold.control_duration && (
                      <p className="text-sm">
                        Controlled: {Math.floor(stronghold.control_duration / 3600)}h
                      </p>
                    )}
                  </div>
                </Popup>
                <Circle
                  center={coords}
                  radius={500}
                  pathOptions={{
                    color: getStrongholdColor(stronghold),
                    fillColor: getStrongholdColor(stronghold),
                    fillOpacity: 0.2,
                  }}
                />
              </Marker>
            )
          })}

          {showHotspots && hotspots.map((hotspot, idx) => {
            const coords = getMapCoordinates(hotspot.zone_id, hotspot.x, hotspot.y)
            const intensity = Math.min(hotspot.death_count / 10, 1) // Normalize to 0-1
            return (
              <Circle
                key={idx}
                center={coords}
                radius={300 * (1 + intensity)}
                pathOptions={{
                  color: '#ff0000',
                  fillColor: '#ff0000',
                  fillOpacity: 0.3 * intensity,
                }}
              >
                <Popup>
                  <div className="text-black">
                    <h3 className="font-bold mb-2">PvP Hotspot</h3>
                    <p className="text-sm">Zone: {hotspot.zone_name}</p>
                    <p className="text-sm">Deaths: {hotspot.death_count}</p>
                    <p className="text-sm">Time Range: {hotspot.time_range}</p>
                  </div>
                </Popup>
              </Circle>
            )
          })}
        </MapContainer>
      </div>

      <div className="mt-4 grid grid-cols-1 md:grid-cols-2 gap-4">
        <div className="bg-mortal-dark p-4 rounded-lg border border-mortal-accent">
          <h3 className="font-semibold mb-2">Legend</h3>
          <div className="space-y-1 text-sm">
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 bg-mortal-accent rounded"></div>
              <span>Stronghold (Controlled)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 bg-gray-600 rounded"></div>
              <span>Stronghold (Independent)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 bg-red-600 rounded-full opacity-50"></div>
              <span>PvP Hotspot (Recent Deaths)</span>
            </div>
          </div>
        </div>

        <div className="bg-mortal-dark p-4 rounded-lg border border-mortal-accent">
          <h3 className="font-semibold mb-2">Map Controls</h3>
          <p className="text-sm text-gray-400">
            Toggle overlays using the checkboxes above. Click on markers for details.
          </p>
        </div>
      </div>
    </div>
  )
}
