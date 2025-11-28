import React, { useEffect } from 'react'
import { useLauncherStore } from './stores/launcherStore'
import Dashboard from './pages/Dashboard'
import Settings from './pages/Settings'
import Logs from './pages/Logs'
import About from './pages/About'
import Sidebar from './components/layout/Sidebar'
import Header from './components/layout/Header'

type Page = 'dashboard' | 'settings' | 'logs' | 'about'

function App() {
  const [currentPage, setCurrentPage] = React.useState<Page>('dashboard')
  const loadStatus = useLauncherStore((state) => state.loadStatus)

  useEffect(() => {
    loadStatus()
  }, [loadStatus])

  return (
    <div className="flex h-screen bg-mortal-darker text-white">
      <Sidebar currentPage={currentPage} onNavigate={setCurrentPage} />
      <div className="flex-1 flex flex-col overflow-hidden">
        <Header />
        <main className="flex-1 overflow-y-auto p-6">
          {currentPage === 'dashboard' && <Dashboard />}
          {currentPage === 'settings' && <Settings />}
          {currentPage === 'logs' && <Logs />}
          {currentPage === 'about' && <About />}
        </main>
      </div>
    </div>
  )
}

export default App

