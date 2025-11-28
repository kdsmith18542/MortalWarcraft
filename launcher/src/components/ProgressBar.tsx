import React from 'react'

export default function ProgressBar() {
  return (
    <div className="bg-mortal-dark p-4 rounded-lg border border-mortal-accent mb-6">
      <div className="flex items-center gap-3">
        <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-mortal-gold"></div>
        <span className="text-gray-400">Processing...</span>
      </div>
    </div>
  )
}

