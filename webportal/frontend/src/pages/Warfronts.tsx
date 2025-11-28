import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
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

export default function Warfronts() {
  const [sieges, setSieges] = useState<Siege[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    fetchSieges()
    // Refresh every 30 seconds
    const interval = setInterval(fetchSieges, 30 * 1000)
    return () => clearInterval(interval)
  }, [])

  const fetchSieges = async () => {
    try {
      const res = await apiClient.get('/sieges/upcoming?limit=20')
      setSieges(res.data.sieges || [])
      setError(null)
    } catch (err: any) {
      console.error('Failed to fetch sieges:', err)
      setError(err.response?.data?.error || 'Failed to load sieges')
    } finally {
      setLoading(false)
    }
  }

  const formatTimeUntil = (startTime: number): string => {
    const now = Math.floor(Date.now() / 1000)
    const diff = startTime - now

    if (diff <= 0) return 'Started'

    const days = Math.floor(diff / 86400)
    const hours = Math.floor((diff % 86400) / 3600)
    const minutes = Math.floor((diff % 3600) / 60)
    const seconds = diff % 60

    if (days > 0) return `${days}d ${hours}h`
    if (hours > 0) return `${hours}h ${minutes}m`
    if (minutes > 0) return `${minutes}m ${seconds}s`
    return `${seconds}s`
  }

  const getStageColor = (stage: string, isActive: boolean): string => {
    if (isActive) return 'text-red-400 border-red-500'
    if (stage === 'lock_in') return 'text-yellow-400 border-yellow-500'
    if (stage === 'signup') return 'text-green-400 border-green-500'
    return 'text-gray-400 border-gray-500'
  }

  const getStageLabel = (stage: string, isActive: boolean): string => {
    if (isActive) return 'ACTIVE'
    if (stage === 'lock_in') return 'LOCK-IN'
    if (stage === 'signup') return 'SIGNUP OPEN'
    if (stage === 'announced') return 'ANNOUNCED'
    return 'UPCOMING'
  }

  if (loading) {
    return (
      <div className="px-4 py-6">
        <div className="text-center py-12">Loading sieges...</div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="px-4 py-6">
        <div className="bg-red-900 bg-opacity-50 border border-red-600 rounded-lg p-4">
          <div className="text-red-400">Error: {error}</div>
        </div>
      </div>
    )
  }

  return (
    <div className="px-4 py-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Warfronts & Sieges</h1>
        <div className="text-sm text-gray-400">
          Auto-refreshes every 30 seconds
        </div>
      </div>

      {/* Info Banner */}
      <div className="bg-mortal-dark border border-mortal-accent rounded-lg p-4 mb-6">
        <div className="flex items-start gap-3">
          <div className="text-yellow-400 text-2xl">⚠</div>
          <div>
            <h3 className="font-semibold mb-1">Full Loot Zone</h3>
            <p className="text-sm text-gray-400">
              All sieges take place in Red Zones where full-loot rules apply. 
              All items will drop on death. Recommended skill level varies by siege.
            </p>
          </div>
        </div>
      </div>

      {/* Siege Cards */}
      {sieges.length === 0 ? (
        <div className="text-center py-12 text-gray-400">
          <div className="text-4xl mb-4">⚔️</div>
          <div className="text-xl mb-2">No Upcoming Sieges</div>
          <div className="text-sm">Check back later for scheduled sieges</div>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {sieges.map((siege) => {
            const timeUntil = formatTimeUntil(siege.start_time)
            const stageColor = getStageColor(siege.lifecycle_stage, siege.is_active)
            const stageLabel = getStageLabel(siege.lifecycle_stage, siege.is_active)
            const startDate = new Date(siege.start_time * 1000)

            return (
              <div
                key={siege.siege_id}
                className={`bg-mortal-dark rounded-lg border-2 ${stageColor} p-6 hover:bg-mortal-darker transition-colors`}
              >
                {/* Header */}
                <div className="flex justify-between items-start mb-4">
                  <div>
                    <h3 className="text-xl font-bold mb-1">{siege.stronghold_name}</h3>
                    <div className={`text-xs font-semibold ${stageColor}`}>
                      {stageLabel}
                    </div>
                  </div>
                  {siege.is_active && (
                    <div className="bg-red-600 text-white text-xs font-bold px-2 py-1 rounded">
                      LIVE
                    </div>
                  )}
                </div>

                {/* Guilds */}
                <div className="mb-4 space-y-2">
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                    <div className="flex-1">
                      <div className="text-sm font-semibold text-red-400">
                        {siege.attacker_guild_name}
                      </div>
                      <div className="text-xs text-gray-400">
                        {siege.attacker_count} players
                      </div>
                    </div>
                  </div>
                  <div className="text-center text-gray-500 text-xs">VS</div>
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
                    <div className="flex-1">
                      <div className="text-sm font-semibold text-blue-400">
                        {siege.defender_guild_name}
                      </div>
                      <div className="text-xs text-gray-400">
                        {siege.defender_count} players
                      </div>
                    </div>
                  </div>
                </div>

                {/* Countdown */}
                <div className="mb-4 p-3 bg-mortal-darker rounded border border-mortal-accent">
                  {siege.is_active ? (
                    <div className="text-center">
                      <div className="text-red-400 font-bold text-lg">IN PROGRESS</div>
                      <div className="text-xs text-gray-400 mt-1">
                        Battle is ongoing
                      </div>
                    </div>
                  ) : (
                    <div className="text-center">
                      <div className="text-mortal-gold font-bold text-lg">
                        {timeUntil}
                      </div>
                      <div className="text-xs text-gray-400 mt-1">
                        {startDate.toLocaleString()}
                      </div>
                    </div>
                  )}
                </div>

                {/* Requirements */}
                <div className="mb-4 space-y-1 text-xs">
                  {siege.minimum_level > 0 && (
                    <div className="flex justify-between">
                      <span className="text-gray-400">Min Level:</span>
                      <span className="text-mortal-gold">{siege.minimum_level}</span>
                    </div>
                  )}
                  {siege.minimum_standing > 0 && (
                    <div className="flex justify-between">
                      <span className="text-gray-400">Min Standing:</span>
                      <span className="text-mortal-gold">{siege.minimum_standing}</span>
                    </div>
                  )}
                  <div className="flex justify-between">
                    <span className="text-gray-400">Zone:</span>
                    <span className="text-gray-300">{siege.zone_id}</span>
                  </div>
                </div>

                {/* Actions */}
                <div className="flex gap-2">
                  <Link
                    to={`/sieges/${siege.siege_id}`}
                    className="flex-1 text-center bg-mortal-accent hover:bg-opacity-80 px-4 py-2 rounded transition-colors text-sm"
                  >
                    View Details
                  </Link>
                  {siege.stronghold_id > 0 && (
                    <Link
                      to={`/territory/stronghold/${siege.stronghold_id}`}
                      className="flex-1 text-center bg-mortal-darker hover:bg-opacity-80 px-4 py-2 rounded transition-colors text-sm border border-mortal-accent"
                    >
                      Stronghold
                    </Link>
                  )}
                </div>
              </div>
            )
          })}
        </div>
      )}

      {/* Help Link */}
      <div className="mt-8 text-center">
        <Link
          to="/wiki/guilds-strongholds-warfronts/sieges/how-to-join"
          className="text-mortal-gold hover:underline"
        >
          How to Join a Siege →
        </Link>
      </div>
    </div>
  )
}

