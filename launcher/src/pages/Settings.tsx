import React from 'react'
import { useLauncherStore } from '../stores/launcherStore'

export default function Settings() {
  const {
    clientPath,
    serverIp,
    serverPort,
    setClientPath,
    setServerIp,
    setServerPort,
  } = useLauncherStore()

  const handleBrowsePath = async () => {
    try {
      const { open } = await import('@tauri-apps/api/dialog')
      const selected = await open({
        directory: true,
        multiple: false,
        title: 'Select World of Warcraft Installation Directory',
      })
      if (selected && typeof selected === 'string') {
        setClientPath(selected)
      }
    } catch (err) {
      // Fallback to prompt if dialog API not available
      const path = prompt('Enter WoW client path:')
      if (path) {
        setClientPath(path)
      }
    }
  }

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Settings</h1>

      <div className="space-y-6">
        {/* Client Path */}
        <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
          <h2 className="text-xl font-semibold mb-4">Client Path</h2>
          <div className="space-y-2">
            <input
              type="text"
              value={clientPath || ''}
              onChange={(e) => setClientPath(e.target.value)}
              placeholder="C:\Program Files\World of Warcraft"
              className="w-full bg-mortal-darker border border-mortal-accent rounded px-4 py-2 text-white"
            />
            <button
              onClick={handleBrowsePath}
              className="px-4 py-2 bg-mortal-accent hover:bg-opacity-80 rounded"
            >
              Browse...
            </button>
          </div>
        </div>

        {/* Server Settings */}
        <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent">
          <h2 className="text-xl font-semibold mb-4">Server Settings</h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-1">Server IP</label>
              <input
                type="text"
                value={serverIp}
                onChange={(e) => setServerIp(e.target.value)}
                className="w-full bg-mortal-darker border border-mortal-accent rounded px-4 py-2 text-white"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Server Port</label>
              <input
                type="number"
                value={serverPort}
                onChange={(e) => setServerPort(parseInt(e.target.value) || 3724)}
                className="w-full bg-mortal-darker border border-mortal-accent rounded px-4 py-2 text-white"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

