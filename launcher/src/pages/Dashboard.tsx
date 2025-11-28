import React from 'react'
import { useLauncherStore } from '../stores/launcherStore'
import StatusCard from '../components/StatusCard'
import LaunchButton from '../components/LaunchButton'
import ProgressBar from '../components/ProgressBar'
import { ClientDownloader } from '../components/ClientDownloader'

export default function Dashboard() {
  const {
    clientPath,
    integrityOk,
    patched,
    addonsInstalled,
    serverIp,
    serverPort,
    loading,
    error,
    checkIntegrity,
    patchClient,
    installAddons,
    syncManifest,
    injectConfig,
  } = useLauncherStore()

  const isReady = clientPath && integrityOk && patched && addonsInstalled

  return (
    <div className="max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Dashboard</h1>

      {error && (
        <div className="bg-red-900 bg-opacity-50 border border-red-600 rounded-lg p-4 mb-6">
          <div className="text-red-400">{error}</div>
        </div>
      )}

      {/* Status Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
        <StatusCard
          title="Client Path"
          status={clientPath ? 'Set' : 'Not Set'}
          value={clientPath || 'Not configured'}
          statusOk={!!clientPath}
        />
        <StatusCard
          title="Integrity Check"
          status={integrityOk ? 'Passed' : 'Not Checked'}
          value={integrityOk ? 'All files verified' : 'Click to verify'}
          statusOk={integrityOk}
          onClick={checkIntegrity}
        />
        <StatusCard
          title="DBC Patches"
          status={patched ? 'Applied' : 'Not Applied'}
          value={patched ? 'Client patched' : 'Click to patch'}
          statusOk={patched}
          onClick={patchClient}
        />
        <StatusCard
          title="Addons"
          status={addonsInstalled ? 'Installed' : 'Not Installed'}
          value={addonsInstalled ? 'MortalUI ready' : 'Click to install'}
          statusOk={addonsInstalled}
          onClick={installAddons}
        />
      </div>

      {/* Server Config */}
      <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent mb-6">
        <h2 className="text-xl font-semibold mb-4">Server Configuration</h2>
        <div className="space-y-2">
          <div>
            <span className="text-gray-400">Server IP:</span>{' '}
            <span className="text-mortal-gold">{serverIp}</span>
          </div>
          <div>
            <span className="text-gray-400">Server Port:</span>{' '}
            <span className="text-mortal-gold">{serverPort}</span>
          </div>
          <button
            onClick={injectConfig}
            disabled={loading || !clientPath}
            className="mt-4 px-4 py-2 bg-blue-600 hover:bg-blue-700 disabled:opacity-50 rounded"
          >
            Update Config
          </button>
        </div>
      </div>

      {/* Actions */}
      <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent mb-6">
        <h2 className="text-xl font-semibold mb-4">Actions</h2>
        <div className="space-y-2">
          <button
            onClick={syncManifest}
            disabled={loading || !clientPath}
            className="w-full px-4 py-2 bg-mortal-accent hover:bg-opacity-80 disabled:opacity-50 rounded"
          >
            Sync Manifest
          </button>
        </div>
      </div>

      {/* Client Downloader */}
      {!clientPath && (
        <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent mb-6">
          <ClientDownloader />
        </div>
      )}

      {/* Launch Button */}
      {loading && <ProgressBar />}
      <LaunchButton disabled={!isReady || loading} />
    </div>
  )
}

