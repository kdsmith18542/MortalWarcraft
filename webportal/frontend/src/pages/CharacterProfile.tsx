import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import apiClient from '../lib/apiClient'

interface CharacterProfile {
  guid: number
  name: string
  guild_id?: number
  guild_name?: string
  dynamic_level: number
  skills: Skill[]
  total_skills: number
  notoriety: number
  criminal_status: string
  bounty_status: boolean
  kill_death_ratio?: number
  playtime?: number
  blueprints?: Blueprint[]
}

interface Skill {
  skill_id: number
  skill_name: string
  value: number
  max_value: number
}

interface Blueprint {
  blueprint_id: number
  blueprint_name: string
  type: string
  is_public: boolean
}

export default function CharacterProfile() {
  const { name } = useParams<{ name: string }>()
  const [profile, setProfile] = useState<CharacterProfile | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (name) {
      fetchProfile(name)
    }
  }, [name])

  const fetchProfile = async (charName: string) => {
    try {
      const res = await apiClient.get(`/character/${charName}`)
      setProfile(res.data)
      setError(null)
    } catch (err: any) {
      console.error('Failed to fetch profile:', err)
      setError(err.response?.data?.error || 'Failed to load character profile')
    } finally {
      setLoading(false)
    }
  }

  const getCriminalStatusColor = (status: string) => {
    switch (status) {
      case 'innocent':
        return 'text-green-400'
      case 'thief':
        return 'text-yellow-400'
      case 'murderer':
        return 'text-red-400'
      default:
        return 'text-gray-400'
    }
  }

  if (loading) {
    return (
      <div className="px-4 py-6">
        <div className="text-center py-12">Loading character profile...</div>
      </div>
    )
  }

  if (error || !profile) {
    return (
      <div className="px-4 py-6">
        <div className="bg-red-900 bg-opacity-50 border border-red-600 rounded-lg p-4">
          <div className="text-red-400">Error: {error || 'Character not found'}</div>
        </div>
      </div>
    )
  }

  return (
    <div className="px-4 py-6">
      <div className="flex justify-between items-start mb-6">
        <div>
          <h1 className="text-3xl font-bold">{profile.name}</h1>
          {profile.guild_name && (
            <p className="text-gray-400 mt-1">&lt;{profile.guild_name}&gt;</p>
          )}
        </div>
        <div className="text-right">
          <div className="text-2xl font-bold text-mortal-gold">Level {profile.dynamic_level}</div>
          <div className="text-sm text-gray-400">Dynamic Level</div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Stats */}
        <div className="lg:col-span-2 space-y-6">
          {/* Skills */}
          <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
            <h2 className="text-xl font-semibold mb-4">Skills</h2>
            <div className="mb-4">
              <div className="flex justify-between mb-2">
                <span>Total Primary Skills</span>
                <span className="font-semibold">
                  {profile.total_skills} / 1200
                </span>
              </div>
              <div className="w-full bg-gray-800 rounded-full h-2">
                <div
                  className="bg-mortal-gold h-2 rounded-full"
                  style={{ width: `${Math.min((profile.total_skills / 1200) * 100, 100)}%` }}
                />
              </div>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {profile.skills && profile.skills.length > 0 ? (
                profile.skills.map((skill) => (
                  <div key={skill.skill_id} className="border border-mortal-accent rounded p-3">
                    <div className="flex justify-between mb-1">
                      <span className="font-semibold">{skill.skill_name}</span>
                      <span className="text-mortal-gold">
                        {Math.floor(skill.value)} / {skill.max_value}
                      </span>
                    </div>
                    <div className="w-full bg-gray-800 rounded-full h-1.5">
                      <div
                        className="bg-blue-500 h-1.5 rounded-full"
                        style={{ width: `${Math.min((skill.value / skill.max_value) * 100, 100)}%` }}
                      />
                    </div>
                  </div>
                ))
              ) : (
                <p className="text-gray-400 col-span-2">No skills recorded</p>
              )}
            </div>
          </div>

          {/* Reputation */}
          <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
            <h2 className="text-xl font-semibold mb-4">Reputation</h2>
            <div className="space-y-3">
              <div className="flex justify-between">
                <span>Criminal Status</span>
                <span className={getCriminalStatusColor(profile.criminal_status)}>
                  {profile.criminal_status.charAt(0).toUpperCase() + profile.criminal_status.slice(1)}
                </span>
              </div>
              <div className="flex justify-between">
                <span>Notoriety</span>
                <span className={profile.notoriety > 0 ? 'text-red-400' : 'text-gray-400'}>
                  {profile.notoriety}
                </span>
              </div>
              {profile.bounty_status && (
                <div className="flex justify-between">
                  <span>Bounty Status</span>
                  <span className="text-red-400">Active Bounty</span>
                </div>
              )}
            </div>
          </div>

          {/* Combat Stats */}
          {profile.kill_death_ratio !== undefined && (
            <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
              <h2 className="text-xl font-semibold mb-4">Combat Statistics</h2>
              <div className="space-y-3">
                <div className="flex justify-between">
                  <span>Kill/Death Ratio</span>
                  <span className="font-semibold">
                    {profile.kill_death_ratio.toFixed(2)}
                  </span>
                </div>
              </div>
            </div>
          )}

          {/* Blueprints */}
          {profile.blueprints && profile.blueprints.length > 0 && (
            <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
              <h2 className="text-xl font-semibold mb-4">Blueprints</h2>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                {profile.blueprints.map((bp) => (
                  <div
                    key={bp.blueprint_id}
                    className="border border-mortal-accent rounded p-3 text-center"
                  >
                    <div className="font-semibold">{bp.blueprint_name}</div>
                    <div className="text-sm text-gray-400">{bp.type}</div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Sidebar */}
        <div className="lg:col-span-1 space-y-6">
          <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
            <h3 className="font-semibold mb-4">Quick Links</h3>
            <div className="space-y-2">
              <Link
                to={`/killboard?killer=${profile.name}`}
                className="block text-blue-400 hover:underline"
              >
                View Kills
              </Link>
              <Link
                to={`/killboard?victim=${profile.name}`}
                className="block text-blue-400 hover:underline"
              >
                View Deaths
              </Link>
              {profile.guild_name && (
                <Link
                  to={`/map?guild=${profile.guild_id}`}
                  className="block text-blue-400 hover:underline"
                >
                  View Guild Territory
                </Link>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
