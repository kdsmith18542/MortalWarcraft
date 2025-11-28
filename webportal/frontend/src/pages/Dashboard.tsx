import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import apiClient from '../lib/apiClient'

interface GlobalStatus {
  territory_control: {
    horde: number
    alliance: number
    independent: number
    total: number
  }
  active_bosses: any[]
  midnight_horde: {
    is_active: boolean
    next_event: string
  }
}

export default function Dashboard() {
  const [status, setStatus] = useState<GlobalStatus | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    fetchStatus()
    // Refresh every 5 minutes
    const interval = setInterval(fetchStatus, 5 * 60 * 1000)
    return () => clearInterval(interval)
  }, [])

  const fetchStatus = async () => {
    try {
      const res = await apiClient.get('/dashboard')
      setStatus(res.data)
      setError(null)
    } catch (err: any) {
      console.error('Failed to fetch status:', err)
      setError(err.response?.data?.error || 'Failed to load status')
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <div className="px-4 py-6">
        <div className="text-center py-12">Loading global status...</div>
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

  const hordePercent = status?.territory_control.total
    ? Math.round((status.territory_control.horde / status.territory_control.total) * 100)
    : 0
  const alliancePercent = status?.territory_control.total
    ? Math.round((status.territory_control.alliance / status.territory_control.total) * 100)
    : 0
  const independentPercent = status?.territory_control.total
    ? Math.round((status.territory_control.independent / status.territory_control.total) * 100)
    : 0

  return (
    <div className="px-4 py-6">
      <h1 className="text-3xl font-bold mb-6">Global Status</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        {/* Territory Control */}
        <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
          <h2 className="text-xl font-semibold mb-4">Territory Control</h2>
          <div className="space-y-3">
            <div>
              <div className="flex justify-between mb-1">
                <span className="text-red-400">Horde</span>
                <span className="text-red-400 font-semibold">
                  {status?.territory_control.horde || 0} ({hordePercent}%)
                </span>
              </div>
              <div className="w-full bg-gray-800 rounded-full h-2">
                <div
                  className="bg-red-600 h-2 rounded-full"
                  style={{ width: `${hordePercent}%` }}
                />
              </div>
            </div>
            <div>
              <div className="flex justify-between mb-1">
                <span className="text-blue-400">Alliance</span>
                <span className="text-blue-400 font-semibold">
                  {status?.territory_control.alliance || 0} ({alliancePercent}%)
                </span>
              </div>
              <div className="w-full bg-gray-800 rounded-full h-2">
                <div
                  className="bg-blue-600 h-2 rounded-full"
                  style={{ width: `${alliancePercent}%` }}
                />
              </div>
            </div>
            <div>
              <div className="flex justify-between mb-1">
                <span className="text-gray-400">Independent</span>
                <span className="text-gray-400 font-semibold">
                  {status?.territory_control.independent || 0} ({independentPercent}%)
                </span>
              </div>
              <div className="w-full bg-gray-800 rounded-full h-2">
                <div
                  className="bg-gray-600 h-2 rounded-full"
                  style={{ width: `${independentPercent}%` }}
                />
              </div>
            </div>
            <div className="flex justify-between border-t border-mortal-accent pt-3 mt-3">
              <span className="font-semibold">Total Strongholds</span>
              <span className="font-semibold">{status?.territory_control.total || 0}</span>
            </div>
          </div>
          <Link
            to="/map"
            className="block mt-4 text-center bg-mortal-accent hover:bg-opacity-80 px-4 py-2 rounded transition-colors"
          >
            View Map
          </Link>
        </div>

        {/* Active World Bosses */}
        <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
          <h2 className="text-xl font-semibold mb-4">Active World Bosses</h2>
          {status?.active_bosses && status.active_bosses.length > 0 ? (
            <div className="space-y-2">
              {status.active_bosses.map((boss: any, idx: number) => (
                <div key={idx} className="text-yellow-400">
                  {boss.boss_name} - {boss.zone_name}
                </div>
              ))}
            </div>
          ) : (
            <p className="text-gray-400">No active world bosses</p>
          )}
        </div>

        {/* Midnight Horde */}
        <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
          <h2 className="text-xl font-semibold mb-4">Midnight Horde</h2>
          <div className="space-y-2">
            <div className={`text-lg font-semibold ${status?.midnight_horde?.is_active ? 'text-red-400' : 'text-gray-400'}`}>
              {status?.midnight_horde?.is_active ? 'ACTIVE' : 'Inactive'}
            </div>
            {status?.midnight_horde?.next_event && (
              <div className="text-sm text-gray-400">
                <div>Next Event:</div>
                <div className="text-mortal-gold">
                  {new Date(status.midnight_horde.next_event).toLocaleString()}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Quick Links */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-6">
        <Link
          to="/killboard"
          className="bg-mortal-dark p-4 rounded-lg border border-mortal-accent hover:bg-mortal-darker transition-colors"
        >
          <h3 className="font-semibold mb-2">Recent Kills</h3>
          <p className="text-sm text-gray-400">View the latest PvP activity</p>
        </Link>
        <Link
          to="/market"
          className="bg-mortal-dark p-4 rounded-lg border border-mortal-accent hover:bg-mortal-darker transition-colors"
        >
          <h3 className="font-semibold mb-2">Market Tracker</h3>
          <p className="text-sm text-gray-400">Find the best prices across Azeroth</p>
        </Link>
      </div>
    </div>
  )
}
