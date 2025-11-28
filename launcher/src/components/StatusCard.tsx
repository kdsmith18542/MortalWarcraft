import React from 'react'

interface StatusCardProps {
  title: string
  status: string
  value: string
  statusOk: boolean
  onClick?: () => void
}

export default function StatusCard({ title, status, value, statusOk, onClick }: StatusCardProps) {
  return (
    <div
      className={`bg-mortal-dark p-4 rounded-lg border ${
        statusOk ? 'border-green-600' : 'border-mortal-accent'
      } ${onClick ? 'cursor-pointer hover:bg-mortal-accent' : ''}`}
      onClick={onClick}
    >
      <div className="flex items-center justify-between mb-2">
        <h3 className="font-semibold">{title}</h3>
        <span
          className={`text-xs px-2 py-1 rounded ${
            statusOk ? 'bg-green-900 text-green-300' : 'bg-gray-800 text-gray-400'
          }`}
        >
          {status}
        </span>
      </div>
      <p className="text-sm text-gray-400">{value}</p>
    </div>
  )
}

