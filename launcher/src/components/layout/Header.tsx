import React from 'react'

export default function Header() {
  return (
    <header className="bg-mortal-dark border-b border-mortal-accent px-6 py-4">
      <div className="flex items-center justify-between">
        <h2 className="text-xl font-semibold">Mortal Warcraft Launcher</h2>
        <div className="flex items-center gap-4">
          <a
            href="https://discord.gg/vVW77pgj"
            target="_blank"
            rel="noopener noreferrer"
            className="text-sm text-blue-400 hover:text-blue-300"
          >
            Discord
          </a>
        </div>
      </div>
    </header>
  )
}

