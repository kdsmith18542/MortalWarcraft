import { create } from 'zustand'
import { tauriClient, LauncherStatus } from '../lib/tauriClient'

interface LauncherState extends LauncherStatus {
  loading: boolean
  error: string | null
  setClientPath: (path: string) => void
  setServerIp: (ip: string) => void
  setServerPort: (port: number) => void
  checkIntegrity: () => Promise<void>
  patchClient: () => Promise<void>
  installAddons: () => Promise<void>
  syncManifest: () => Promise<void>
  injectConfig: () => Promise<void>
  loadStatus: () => Promise<void>
}

export const useLauncherStore = create<LauncherState>((set, get) => ({
  clientPath: null,
  integrityOk: false,
  patched: false,
  addonsInstalled: false,
  serverIp: '127.0.0.1',
  serverPort: 3724,
  loading: false,
  error: null,

  setClientPath: (path: string) => set({ clientPath: path }),
  setServerIp: (ip: string) => set({ serverIp: ip }),
  setServerPort: (port: number) => set({ serverPort: port }),

  checkIntegrity: async () => {
    const { clientPath } = get()
    if (!clientPath) {
      set({ error: 'No client path set' })
      return
    }

    set({ loading: true, error: null })
    try {
      const ok = await tauriClient.checkClientIntegrity(clientPath)
      set({ integrityOk: ok, loading: false })
    } catch (err: any) {
      set({ error: err.message || 'Integrity check failed', loading: false })
    }
  },

  patchClient: async () => {
    const { clientPath } = get()
    if (!clientPath) {
      set({ error: 'No client path set' })
      return
    }

    set({ loading: true, error: null })
    try {
      await tauriClient.patchDbcFiles(clientPath)
      set({ patched: true, loading: false })
    } catch (err: any) {
      set({ error: err.message || 'Patching failed', loading: false })
    }
  },

  installAddons: async () => {
    const { clientPath } = get()
    if (!clientPath) {
      set({ error: 'No client path set' })
      return
    }

    set({ loading: true, error: null })
    try {
      await tauriClient.installAddons(clientPath)
      set({ addonsInstalled: true, loading: false })
    } catch (err: any) {
      set({ error: err.message || 'Addon installation failed', loading: false })
    }
  },

  syncManifest: async () => {
    const { serverIp, serverPort } = get()
    const serverUrl = `http://${serverIp}:${serverPort}`

    set({ loading: true, error: null })
    try {
      await tauriClient.syncManifest(serverUrl)
      set({ loading: false })
    } catch (err: any) {
      set({ error: err.message || 'Manifest sync failed', loading: false })
    }
  },

  injectConfig: async () => {
    const { clientPath, serverIp, serverPort } = get()
    if (!clientPath) {
      set({ error: 'No client path set' })
      return
    }

    set({ loading: true, error: null })
    try {
      await tauriClient.injectConfig(clientPath, serverIp, serverPort)
      set({ loading: false })
    } catch (err: any) {
      set({ error: err.message || 'Config injection failed', loading: false })
    }
  },

  loadStatus: async () => {
    set({ loading: true })
    try {
      const path = await tauriClient.getClientPath()
      set({ clientPath: path, loading: false })
    } catch (err: any) {
      set({ error: err.message || 'Failed to load status', loading: false })
    }
  },
}))

