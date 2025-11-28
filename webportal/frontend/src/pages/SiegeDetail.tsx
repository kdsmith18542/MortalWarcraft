import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import apiClient from '../lib/apiClient'

interface Siege {
  siege_id: number
  stronghold_id: number
  stronghold_name: string
  zone_id: number
  attacker_guild_id: number
  attacker_guild_name: string
  defender_guild_id: number
  defender_guild_name: string
  start_time: number
  end_time: number
  is_active: boolean
  lifecycle_stage: string
  attacker_count: number
  defender_count: number
  minimum_level: number
  minimum_standing: number
}

export default function SiegeDetail() {
  const { id } = useParams<{ id: string }>()
  const [siege, setSiege] = useState<Siege | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [timeUntil, setTimeUntil] = useState<string>('')

  useEffect(() => {
    if (id) {
      fetchSiege(parseInt(id))
    }
  }, [id])

  useEffect(() => {
    if (!siege) return

    const updateTimer = () => {
      const now = Math.floor(Date.now() / 1000)
      const diff = siege.start_time - now

      if (diff <= 0) {
        setTimeUntil('Started')
        return
      }

      const days = Math.floor(diff / 86400)
      const hours = Math.floor((diff % 86400) / 3600)
      const minutes = Math.floor((diff % 3600) / 60)
      const seconds = diff % 60

      if (days > 0) {
        setTimeUntil(`${days}d ${hours}h ${minutes}m`)
      } else if (hours > 0) {
        setTimeUntil(`${hours}h ${minutes}m ${seconds}s`)
      } else if (minutes > 0) {
        setTimeUntil(`${minutes}m ${seconds}s`)
      } else {
        setTimeUntil(`${seconds}s`)
      }
    }

    updateTimer()
    const interval = setInterval(updateTimer, 1000)
    return () => clearInterval(interval)
  }, [siege])

  const fetchSiege = async (siegeId: number) => {
    try {
      const res = await apiClient.get(`/sieges/${siegeId}`)
      setSiege(res.data)
      setError(null)
    } catch (err: any) {
      console.error('Failed to fetch siege:', err)
      setError(err.response?.data?.error || 'Failed to load siege')
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <div className="px-4 py-6">
        <div className="text-center py-12">Loading siege details...</div>
      </div>
    )
  }

  if (error || !siege) {
    return (
      <div className="px-4 py-6">
        <div className="bg-red-900 bg-opacity-50 border border-red-600 rounded-lg p-4">
          <div className="text-red-400">Error: {error || 'Siege not found'}</div>
          <Link to="/warfronts" className="text-mortal-gold hover:underline mt-2 block">
            ← Back to Warfronts
          </Link>
        </div>
      </div>
    )
  }

  const startDate = new Date(siege.start_time * 1000)
  const endDate = new Date(siege.end_time * 1000)

  return (
    <div className="px-4 py-6">
      <Link to="/warfronts" className="text-mortal-gold hover:underline mb-4 inline-block">
        ← Back to Warfronts
      </Link>

      <div className="bg-mortal-dark rounded-lg border-2 border-mortal-accent p-6">
        {/* Header */}
        <div className="mb-6">
          <h1 className="text-3xl font-bold mb-2">{siege.stronghold_name}</h1>
          <div className={`inline-block px-3 py-1 rounded text-sm font-semibold ${
            siege.is_active 
              ? 'bg-red-600 text-white' 
              : siege.lifecycle_stage === 'lock_in'
              ? 'bg-yellow-600 text-white'
              : siege.lifecycle_stage === 'signup'
              ? 'bg-green-600 text-white'
              : 'bg-gray-600 text-white'
          }`}>
            {siege.is_active ? 'ACTIVE' : siege.lifecycle_stage.toUpperCase()}
          </div>
        </div>

        {/* Countdown */}
        {!siege.is_active && (
          <div className="bg-mortal-darker rounded-lg p-6 mb-6 border border-mortal-accent">
            <div className="text-center">
              <div className="text-sm text-gray-400 mb-2">Siege starts in</div>
              <div className="text-4xl font-bold text-mortal-gold mb-2">{timeUntil}</div>
              <div className="text-sm text-gray-400">
                {startDate.toLocaleString()}
              </div>
            </div>
          </div>
        )}

        {/* Guilds */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
          <div className="bg-mortal-darker rounded-lg p-4 border border-red-500">
            <div className="flex items-center gap-3 mb-3">
              <div className="w-4 h-4 bg-red-500 rounded-full"></div>
              <h3 className="text-lg font-semibold text-red-400">Attacker</h3>
            </div>
            <div className="text-xl font-bold mb-2">{siege.attacker_guild_name}</div>
            <div className="text-sm text-gray-400">
              {siege.attacker_count} players registered
            </div>
          </div>

          <div className="bg-mortal-darker rounded-lg p-4 border border-blue-500">
            <div className="flex items-center gap-3 mb-3">
              <div className="w-4 h-4 bg-blue-500 rounded-full"></div>
              <h3 className="text-lg font-semibold text-blue-400">Defender</h3>
            </div>
            <div className="text-xl font-bold mb-2">{siege.defender_guild_name}</div>
            <div className="text-sm text-gray-400">
              {siege.defender_count} players registered
            </div>
          </div>
        </div>

        {/* Details */}
        <div className="bg-mortal-darker rounded-lg p-4 mb-6">
          <h3 className="font-semibold mb-3">Siege Details</h3>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <div className="text-gray-400">Start Time</div>
              <div className="text-mortal-gold">{startDate.toLocaleString()}</div>
            </div>
            <div>
              <div className="text-gray-400">End Time</div>
              <div className="text-mortal-gold">{endDate.toLocaleString()}</div>
            </div>
            <div>
              <div className="text-gray-400">Zone</div>
              <div className="text-gray-300">{siege.zone_id}</div>
            </div>
            {siege.minimum_level > 0 && (
              <div>
                <div className="text-gray-400">Minimum Level</div>
                <div className="text-mortal-gold">{siege.minimum_level}</div>
              </div>
            )}
            {siege.minimum_standing > 0 && (
              <div>
                <div className="text-gray-400">Minimum Standing</div>
                <div className="text-mortal-gold">{siege.minimum_standing}</div>
              </div>
            )}
          </div>
        </div>

        {/* Warning */}
        <div className="bg-red-900 bg-opacity-30 border border-red-600 rounded-lg p-4">
          <div className="flex items-start gap-3">
            <div className="text-red-400 text-2xl">⚠</div>
            <div>
              <h4 className="font-semibold text-red-400 mb-1">Full Loot Zone</h4>
              <p className="text-sm text-gray-300">
                This siege takes place in a Red Zone. All items will drop on death. 
                Only join if you are prepared to risk your equipment.
              </p>
            </div>
          </div>
        </div>

        {/* Actions */}
        {siege.stronghold_id > 0 && (
          <div className="mt-6">
            <Link
              to={`/territory/stronghold/${siege.stronghold_id}`}
              className="block text-center bg-mortal-accent hover:bg-opacity-80 px-6 py-3 rounded transition-colors"
            >
              View Stronghold Details
            </Link>
          </div>
        )}
      </div>
    </div>
  )
}

