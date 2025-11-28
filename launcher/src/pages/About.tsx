import React from 'react'

export default function About() {
  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">About</h1>

      <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent space-y-4">
        <div>
          <h2 className="text-xl font-semibold mb-2">Mortal Warcraft Launcher</h2>
          <p className="text-gray-400">Version 1.0.0</p>
        </div>

        <div>
          <h3 className="font-semibold mb-2">Features</h3>
          <ul className="list-disc list-inside text-gray-400 space-y-1">
            <li>Client integrity verification</li>
            <li>Automatic DBC patching</li>
            <li>Addon installation and management</li>
            <li>Server configuration</li>
            <li>Manifest synchronization</li>
          </ul>
        </div>

        <div>
          <h3 className="font-semibold mb-2">Links</h3>
          <div className="space-y-2">
            <a
              href="https://atlas.mortalwarcraft.com"
              target="_blank"
              rel="noopener noreferrer"
              className="block text-blue-400 hover:text-blue-300"
            >
              🌐 Mortal Atlas Web Portal
            </a>
            <a
              href="https://discord.gg/vVW77pgj"
              target="_blank"
              rel="noopener noreferrer"
              className="block text-blue-400 hover:text-blue-300"
            >
              💬 Discord Server
            </a>
          </div>
        </div>

        <div className="pt-4 border-t border-mortal-accent">
          <p className="text-sm text-gray-400">
            Mortal Warcraft Overhaul - A skill-based, classless MMO experience
          </p>
        </div>
      </div>
    </div>
  )
}

