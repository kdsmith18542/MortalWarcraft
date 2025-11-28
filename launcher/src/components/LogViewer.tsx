import React, { useRef, useEffect } from 'react'

interface LogViewerProps {
  logs: string[]
}

export default function LogViewer({ logs }: LogViewerProps) {
  const logEndRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    logEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [logs])

  return (
    <div className="bg-mortal-dark rounded-lg border border-mortal-accent p-4">
      <div className="bg-mortal-darker rounded p-4 h-96 overflow-y-auto font-mono text-sm">
        {logs.length === 0 ? (
          <div className="text-gray-400">No logs available</div>
        ) : (
          logs.map((log, idx) => (
            <div key={idx} className="text-gray-300 mb-1">
              {log}
            </div>
          ))
        )}
        <div ref={logEndRef} />
      </div>
    </div>
  )
}

