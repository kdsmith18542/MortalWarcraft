import React from 'react'

type Page = 'dashboard' | 'settings' | 'logs' | 'about'

interface SidebarProps {
  currentPage: Page
  onNavigate: (page: Page) => void
}

export default function Sidebar({ currentPage, onNavigate }: SidebarProps) {
  const menuItems = [
    { id: 'dashboard' as Page, label: 'Dashboard', icon: '📊' },
    { id: 'settings' as Page, label: 'Settings', icon: '⚙️' },
    { id: 'logs' as Page, label: 'Logs', icon: '📝' },
    { id: 'about' as Page, label: 'About', icon: 'ℹ️' },
  ]

  return (
    <div className="w-64 bg-mortal-dark border-r border-mortal-accent flex flex-col">
      <div className="p-6 border-b border-mortal-accent">
        <h1 className="text-2xl font-bold text-mortal-gold">Mortal Launcher</h1>
        <p className="text-sm text-gray-400 mt-1">v1.0.0</p>
      </div>
      <nav className="flex-1 p-4">
        {menuItems.map((item) => (
          <button
            key={item.id}
            onClick={() => onNavigate(item.id)}
            className={`w-full text-left px-4 py-3 rounded-lg mb-2 transition-colors ${
              currentPage === item.id
                ? 'bg-mortal-accent text-mortal-gold'
                : 'text-gray-300 hover:bg-mortal-accent hover:text-white'
            }`}
          >
            <span className="mr-3">{item.icon}</span>
            {item.label}
          </button>
        ))}
      </nav>
      <div className="p-4 border-t border-mortal-accent">
        <a
          href="https://atlas.mortalwarcraft.com"
          target="_blank"
          rel="noopener noreferrer"
          className="block text-sm text-blue-400 hover:text-blue-300"
        >
          🌐 Mortal Atlas
        </a>
      </div>
    </div>
  )
}

