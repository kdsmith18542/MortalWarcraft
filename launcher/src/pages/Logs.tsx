import React, { useState, useEffect } from 'react'
import LogViewer from '../components/LogViewer'

export default function Logs() {
  const [logs, setLogs] = useState<string[]>([])

  useEffect(() => {
    loadLogs()
    // Refresh logs every 5 seconds
    const interval = setInterval(loadLogs, 5000)
    return () => clearInterval(interval)
  }, [])

  const loadLogs = async () => {
    try {
      const { readTextFile } = await import('@tauri-apps/api/fs')
      const { appDataDir } = await import('@tauri-apps/api/path')
      
      const dataDir = await appDataDir()
      const logPath = `${dataDir}launcher.log`
      
      try {
        const content = await readTextFile(logPath)
        const lines = content.split('\n').filter(line => line.trim() !== '')
        setLogs(lines.slice(-100)) // Last 100 lines
      } catch (err) {
        // Log file doesn't exist yet, use console logs
        setLogs([
          '[INFO] Launcher started',
          '[INFO] Log file will be created when operations are performed',
          '[INFO] Check console for real-time logs',
        ])
      }
    } catch (err) {
      // Fallback if Tauri APIs not available
      setLogs([
        '[INFO] Launcher started',
        '[INFO] Log loading requires Tauri APIs',
        '[INFO] Check console output for logs',
      ])
    }
  }

  return (
    <div className="max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Logs</h1>
      <LogViewer logs={logs} />
    </div>
  )
}

