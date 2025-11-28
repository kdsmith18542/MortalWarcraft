import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import apiClient from '../lib/apiClient'

interface Kill {
  id: number
  killer_name: string
  killer_guild?: string
  victim_name: string
  victim_guild?: string
  zone_name?: string
  loot_value: number
  notoriety: number
  is_zerg: boolean
  kill_time: string
}

export default function Killboard() {
  const [kills, setKills] = useState<Kill[]>([])
  const [loading, setLoading] = useState(true)
  const [selectedKill, setSelectedKill] = useState<Kill | null>(null)

  useEffect(() => {
    fetchKills()
  }, [])

  const fetchKills = async () => {
    try {
      const res = await apiClient.get('/killboard/recent?limit=50')
      setKills(res.data.kills || [])
    } catch (err) {
      console.error('Failed to fetch kills:', err)
    } finally {
      setLoading(false)
    }
  }

  const formatGold = (copper: number) => {
    const gold = Math.floor(copper / 10000)
    const silver = Math.floor((copper % 10000) / 100)
    const copperRemainder = copper % 100
    return `${gold}g ${silver}s ${copperRemainder}c`
  }

  const formatTime = (timeStr: string) => {
    return new Date(timeStr).toLocaleString()
  }

  if (loading) {
    return (
      <div className="px-4 py-6">
        <div className="text-center py-12">Loading killboard...</div>
      </div>
    )
  }

  return (
    <div className="px-4 py-6">
      <h1 className="text-3xl font-bold mb-6">Killboard</h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Kill List */}
        <div className="lg:col-span-2">
          <div className="bg-mortal-dark rounded-lg border border-mortal-accent overflow-hidden">
            <div className="bg-mortal-accent px-4 py-2 font-semibold">
              Recent Kills
            </div>
            <div className="divide-y divide-mortal-accent">
              {kills.length === 0 ? (
                <div className="p-8 text-center text-gray-400">
                  No kills recorded yet
                </div>
              ) : (
                kills.map((kill) => (
                  <div
                    key={kill.id}
                    className="p-4 hover:bg-mortal-darker cursor-pointer transition-colors"
                    onClick={() => setSelectedKill(kill)}
                  >
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <span className="text-red-400 font-semibold">
                            {kill.killer_name}
                          </span>
                          {kill.killer_guild && (
                            <span className="text-gray-400 text-sm">
                              &lt;{kill.killer_guild}&gt;
                            </span>
                          )}
                          {kill.is_zerg && (
                            <span className="text-xs bg-red-600 px-2 py-0.5 rounded">
                              ZERG
                            </span>
                          )}
                          <span className="text-gray-500">→</span>
                          <span className="text-blue-400 font-semibold">
                            {kill.victim_name}
                          </span>
                          {kill.victim_guild && (
                            <span className="text-gray-400 text-sm">
                              &lt;{kill.victim_guild}&gt;
                            </span>
                          )}
                        </div>
                        <div className="text-sm text-gray-400">
                          {kill.zone_name || `Zone ${kill.zone_id}`} • {formatTime(kill.kill_time)}
                        </div>
                      </div>
                      <div className="text-right">
                        <div className="text-mortal-gold font-semibold">
                          {formatGold(kill.loot_value)}
                        </div>
                        {kill.notoriety > 0 && (
                          <div className="text-xs text-red-400">
                            +{kill.notoriety} Notoriety
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>

        {/* Kill Details Sidebar */}
        <div className="lg:col-span-1">
          <div className="bg-mortal-dark rounded-lg border border-mortal-accent p-6">
            <h2 className="text-xl font-semibold mb-4">Kill Details</h2>
            {selectedKill ? (
              <div className="space-y-4">
                <div>
                  <div className="text-sm text-gray-400 mb-1">Killer</div>
                  <div className="text-red-400 font-semibold">
                    {selectedKill.killer_name}
                    {selectedKill.killer_guild && (
                      <span className="text-gray-400 ml-2">
                        &lt;{selectedKill.killer_guild}&gt;
                      </span>
                    )}
                  </div>
                </div>
                <div>
                  <div className="text-sm text-gray-400 mb-1">Victim</div>
                  <div className="text-blue-400 font-semibold">
                    {selectedKill.victim_name}
                    {selectedKill.victim_guild && (
                      <span className="text-gray-400 ml-2">
                        &lt;{selectedKill.victim_guild}&gt;
                      </span>
                    )}
                  </div>
                </div>
                <div>
                  <div className="text-sm text-gray-400 mb-1">Location</div>
                  <div>{selectedKill.zone_name || `Zone ${selectedKill.zone_id}`}</div>
                </div>
                <div>
                  <div className="text-sm text-gray-400 mb-1">Loot Value</div>
                  <div className="text-mortal-gold font-semibold">
                    {formatGold(selectedKill.loot_value)}
                  </div>
                </div>
                {selectedKill.notoriety > 0 && (
                  <div>
                    <div className="text-sm text-gray-400 mb-1">Notoriety</div>
                    <div className="text-red-400">+{selectedKill.notoriety}</div>
                  </div>
                )}
                <div>
                  <div className="text-sm text-gray-400 mb-1">Time</div>
                  <div>{formatTime(selectedKill.kill_time)}</div>
                </div>
                <Link
                  to={`/killboard/kill/${selectedKill.id}`}
                  className="block mt-4 text-center bg-mortal-accent hover:bg-opacity-80 px-4 py-2 rounded transition-colors"
                >
                  View Full Details
                </Link>
              </div>
            ) : (
              <div className="text-gray-400 text-sm">
                Select a kill to view details
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
