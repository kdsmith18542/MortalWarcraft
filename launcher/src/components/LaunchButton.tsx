import React from 'react'
import { tauriClient } from '../lib/tauriClient'
import { useLauncherStore } from '../stores/launcherStore'

interface LaunchButtonProps {
  disabled: boolean
}

export default function LaunchButton({ disabled }: LaunchButtonProps) {
  const { clientPath } = useLauncherStore()

  const handleLaunch = async () => {
    if (!clientPath) return

    try {
      await tauriClient.launchGame(clientPath)
    } catch (err: any) {
      console.error('Failed to launch game:', err)
      alert(`Failed to launch game: ${err.message || 'Unknown error'}`)
    }
  }

  return (
    <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
      <button
        onClick={handleLaunch}
        disabled={disabled}
        className={`w-full px-6 py-4 rounded-lg font-semibold text-lg ${
          disabled
            ? 'bg-gray-700 text-gray-400 cursor-not-allowed'
            : 'bg-green-600 hover:bg-green-700 text-white'
        }`}
      >
        {disabled ? 'Configure Client First' : 'Launch Game'}
      </button>
      {disabled && (
        <p className="text-sm text-gray-400 mt-2 text-center">
          Complete all setup steps before launching
        </p>
      )}
    </div>
  )
}

